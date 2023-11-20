ALTER PROCEDURE [dbo].[addScheduleDetail] @HeaderID INT
	,@StoreCode VARCHAR(50)
	,@StoreName VARCHAR(500)
	,@DocNumber VARCHAR(50)
	,@DocDate DATETIME = ''
	,@AmtExcl NUMERIC(12, 4) = 0
	,@Vat NUMERIC(12, 4) = 0
	,@AmtIncl NUMERIC(12, 4) = 0
	,@InvRef VARCHAR(50) = NULL
	,@ClaimRef VARCHAR(50) = NULL
	,@CampaignName VARCHAR(100) = NULL
	,@BasketNo VARCHAR(50) = NULL
	,@TransactionType VARCHAR(50) = NULL
AS
IF ISNUMERIC(@ClaimRef) = 1
	SELECT @ClaimRef = LTRIM(RTRIM(str(cast(@ClaimRef AS REAL))))

SET NOCOUNT ON

/*
Author & Date
	Chris Kennedy, 02 Sept 2008

Purpose:
	This sp will add the new schedule detail record to the database
*/
DECLARE @DetailID INT
DECLARE @StoreExist BIT
DECLARE @StatusID INT
DECLARE @StatusVal VARCHAR(50)
DECLARE @DCID INT
DECLARE @ScheduleIsForceCredit BIT
DECLARE @ScheduleIsReward BIT
DECLARE @ScheduleIsStamps BIT
DECLARE @SupplierId INT
DECLARE @FileName NVARCHAR(MAX) = ''
DECLARE @ClaimId INT
DECLARE @StoreId INT

SET @StoreExist = 0
SET @StatusVal = 4

--SET @ClaimRef = dbo.GetClaimNumber(@ClaimRef)
--IF @AmtExcl <> 0 AND @Vat <> 0 AND @AmtIncl <> 0
IF @AmtExcl <> 0
	AND @AmtIncl <> 0
BEGIN
	BEGIN TRANSACTION

	DECLARE @ScheduleTolerance NUMERIC(10, 2)

	SELECT @ScheduleTolerance = ScheduleTolerance
	FROM DC
	WHERE DCID = @DCID

	IF @AmtIncl > @ScheduleTolerance
		OR @AmtExcl > @ScheduleTolerance
	BEGIN
		SET @StatusID = 37
	END

	SELECT @DCID = SHiDCID
		,@ScheduleIsForceCredit = IsForceCredit
		,@SupplierId = SHiSupplierID
		,@ScheduleIsReward = IsReward
		,@ScheduleIsStamps = IsStamps
		,@FileName = SHcFileName
	FROM Schedule_Header
	WHERE SHID = @HeaderID

	DECLARE @storeDC INT

	SELECT @storeDC = @DCID

	IF @ScheduleIsReward = 1
	BEGIN
		DECLARE @CompaignId NVARCHAR(13) = dbo.StripLeadingZeros(@DocNumber)
		DECLARE @LastCompaignId NVARCHAR(13) = NULL
		DECLARE @NewCompaignId NVARCHAR(13) = NULL

		SELECT TOP 1 @LastCompaignId = SDcDocNumber
		FROM Schedule_Detail SD
		LEFT JOIN Schedule_Header SH ON (SD.SDiHeaderID = SH.SHID)
		WHERE SH.IsReward = 1
			AND SUBSTRING(SDcDocNumber, 5, 5) = @CompaignId
			/*AND SDcDocNumber LIKE  '%' +  @CompaignId + '%'*/
			AND SH.SHID = @HeaderID
		ORDER BY CAST(SDcDocNumber AS BIGINT) DESC

		IF LEN(@LastCompaignId) = 13
		BEGIN
			SET @NewCompaignId = CAST(@LastCompaignId AS BIGINT) + 1
			SET @DocNumber = @NewCompaignId
		END
		ELSE
		BEGIN
			SET @NewCompaignId = CAST(@CompaignId + REPLICATE('0', 9 - LEN(@CompaignId)) AS BIGINT) + 1

			DECLARE @MonthPathIndex INT = 0
			DECLARE @MonthNumber INT = 0
			DECLARE @MonthName NVARCHAR(50)

			WHILE @MonthPathIndex = 0
				AND @MonthNumber < 12
			BEGIN
				SET @MonthNumber = @MonthNumber + 1
				SET @MonthName = DATENAME(MONTH, DATEADD(MONTH, @MonthNumber, - 1))
				SET @MonthPathIndex = PATINDEX('%' + @MonthName + '%', @FileName)

				IF @MonthPathIndex = 0
					SET @MonthPathIndex = PATINDEX('%' + LEFT(@MonthName, 3) + '%', @FileName)
			END

			DECLARE @Month NVARCHAR(2) = ''

			IF @MonthPathIndex = 0
				SET @Month = DATEPART(MM, GETDATE())
			ELSE
			BEGIN
				IF @MonthNumber < 10
					SET @Month = '0' + CAST(@MonthNumber AS NVARCHAR(2))
				ELSE
					SET @Month = CAST(@MonthNumber AS NVARCHAR(2))
			END

			DECLARE @Year NVARCHAR(2) = ''
			DECLARE @YearPathIndex INT = PATINDEX('%[2][0][1-3][0-9]%', @FileName)

			IF @YearPathIndex = 0
				SET @Year = RIGHT(DATEPART(YY, GETDATE()), 2)
			ELSE
				SET @Year = SUBSTRING(@FileName, @YearPathIndex + 2, 2)

			SET @DocNumber = @Year + @Month + @NewCompaignId
		END

		INSERT INTO Schedule_Detail (
			SDiHeaderID
			,SDcStoreCode
			,SDcStoreName
			,SDcDocNumber
			,SDdDocDate
			,SDmAmtExcl
			,SDmVat
			,SDmAmtIncl
			,SDiStatusID
			,SDcInvRef
			,SDcClaimRef
			,SDcCampainName
			,SDcBasketNo
			)
		VALUES (
			@HeaderID
			,RTRIM(@StoreCode)
			,@StoreName
			,@DocNumber
			,@DocDate
			,@AmtExcl
			,@Vat
			,@AmtIncl
			,@StatusVal
			,@InvRef
			,@ClaimRef
			,@CampaignName
			,@BasketNo
			)

		SET @DetailID = @@IDENTITY

		IF EXISTS (
				SELECT CNID
				FROM CreditNote WITH (NOLOCK)
				WHERE CNiDCID = @DCID
					AND CNiSupplierID = @SupplierId
					AND CNcCreditNoteNumber = @DocNumber
				)
		BEGIN
			SET @StatusVal = 26

			INSERT INTO Schedule_Exception (
				EXiDetailID
				,EXiStatusID
				)
			VALUES (
				@DetailID
				,26
				)
		END

		IF (
				@AmtExcl > 0
				OR @AmtIncl > 0
				)
		BEGIN
			SET @StatusVal = 25

			INSERT INTO Schedule_Exception (
				EXiDetailID
				,EXiStatusID
				)
			VALUES (
				@DetailID
				,25
				)
		END

		IF (@Vat <> 0)
		BEGIN
			SET @StatusVal = 24

			INSERT INTO Schedule_Exception (
				EXiDetailID
				,EXiStatusID
				)
			VALUES (
				@DetailID
				,24
				)
		END
	END
	ELSE
	BEGIN
		INSERT INTO Schedule_Detail (
			SDiHeaderID
			,SDcStoreCode
			,SDcStoreName
			,SDcDocNumber
			,SDdDocDate
			,SDmAmtExcl
			,SDmVat
			,SDmAmtIncl
			,SDiStatusID
			,SDcInvRef
			,SDcClaimRef
			,SDcCampainName
			,SDcBasketNo
			,SDcTransactionType
			)
		VALUES (
			@HeaderID
			,RTRIM(@StoreCode)
			,@StoreName
			,@DocNumber
			,@DocDate
			,@AmtExcl
			,@Vat
			,@AmtIncl
			,@StatusVal
			,@InvRef
			,@ClaimRef
			,@CampaignName
			,@BasketNo
			,@TransactionType
			)

		SET @DetailID = @@IDENTITY
	END

	-- Start validation
	-- Check the Document Number
	IF (@DocNumber = '')
	BEGIN
		SET @StatusVal = 8

		INSERT INTO Schedule_Exception (
			EXiDetailID
			,EXiStatusID
			)
		VALUES (
			@DetailID
			,8
			)
	END

	--restrict the length of the document number to 13 digits - change requested 28/07/2014
	IF len(@DocNumber) > 13
	BEGIN
		SET @StatusVal = 23

		INSERT INTO Schedule_Exception (
			EXiDetailID
			,EXiStatusID
			)
		VALUES (
			@DetailID
			,23
			)
	END

	-- Check the Document date
	IF (ISDATE(@DocDate) = 0)
	BEGIN
		SET @StatusVal = 11

		INSERT INTO Schedule_Exception (
			EXiDetailID
			,EXiStatusID
			)
		VALUES (
			@DetailID
			,11
			)
	END

	IF @ScheduleIsStamps = 1
		--Petrus
	BEGIN
		IF @TransactionType NOT LIKE '%STAMPS%'
		BEGIN
			SET @StatusVal = 27

			INSERT INTO Schedule_Exception (
				EXiDetailID
				,EXiStatusID
				)
			VALUES (
				@DetailID
				,27
				)
		END

		--Duplicate Credit check
		IF @AmtExcl < 0
			OR @AmtIncl < 0
		BEGIN
			IF EXISTS (
					SELECT CNID
					FROM CreditNote WITH (NOLOCK)
					WHERE CNiDCID = @DCID
						AND CNiSupplierID = @SupplierId
						AND CNcCreditNoteNumber = @DocNumber
					)
			BEGIN
				SET @StatusVal = 26

				INSERT INTO Schedule_Exception (
					EXiDetailID
					,EXiStatusID
					)
				VALUES (
					@DetailID
					,26
					)
			END
		END

		--Duplicate Invoice Check
		IF @AmtExcl > 0
			OR @AmtIncl > 0
		BEGIN
			IF EXISTS (
					SELECT INID
					FROM Invoice WITH (NOLOCK)
					WHERE INcDCEAN = (
							SELECT DCcEANNUMBER
							FROM DC WITH (NOLOCK)
							WHERE dcid = @DCID
							)
						AND INcSupplierEAN = (
							SELECT SpcEANnumber
							FROM Supplier WITH (NOLOCK)
							WHERE spid = @SupplierId
							)
						AND INcInvoiceNumber = @DocNumber
					)
			BEGIN
				SET @StatusVal = 28

				INSERT INTO Schedule_Exception (
					EXiDetailID
					,EXiStatusID
					)
				VALUES (
					@DetailID
					,28
					)
			END
		END
	END

	-- Check the storecode
	--Xander change 17/02/2017
	-- Added the check if the store is live and changed the StoreExist value from 1 to 0
	/*
	SELECT COUNT(*) FROM Store WITH (NOLOCK) WHERE STcCode = RTRIM('21990') AND STiDCID = 1
		SELECT STiIsLive FROM Store WITH (NOLOCK) WHERE STcCode = RTRIM('21990') AND STiDCID = 1
	*/
	IF (
			SELECT COUNT(*)
			FROM Store WITH (NOLOCK)
			WHERE STcCode = RTRIM(@StoreCode)
				AND STiDCID = @DCId
			) = 0
	BEGIN
		SET @StatusVal = 10
		SET @StoreExist = 0

		INSERT INTO Schedule_Exception (
			EXiDetailID
			,EXiStatusID
			)
		VALUES (
			@DetailID
			,10
			)
	END
	ELSE
	BEGIN
		SET @StoreExist = 1

		IF (
				SELECT COUNT(1)
				FROM Store WITH (NOLOCK)
				WHERE STcCode = RTRIM(@StoreCode)
					AND STiDCID = @DCId
				) = 0
		BEGIN
			SET @StatusVal = 29
			SET @StoreExist = 0

			INSERT INTO Schedule_Exception (
				EXiDetailID
				,EXiStatusID
				)
			VALUES (
				@DetailID
				,@StatusVal
				)
		END
	END

	-- Check the Inclisive amount
	IF (ISNUMERIC(@AmtIncl) = 0)
	BEGIN
		SET @StatusVal = 12

		/* 12	Inclusive amount not numeric */
		INSERT INTO Schedule_Exception (
			EXiDetailID
			,EXiStatusID
			)
		VALUES (
			@DetailID
			,12
			)
	END

	IF (@AmtIncl > 0)
	BEGIN
		IF (
				@AmtExcl < 0
				OR @VAT < 0
				)
		BEGIN
			SET @StatusVal = 14

			/* 14	Signage incorrect on field */
			INSERT INTO Schedule_Exception (
				EXiDetailID
				,EXiStatusID
				)
			VALUES (
				@DetailID
				,14
				)
		END
	END

	IF (@AmtIncl < 0)
	BEGIN
		IF (
				@AmtExcl > 0
				OR @VAT > 0
				)
		BEGIN
			SET @StatusVal = 14

			/* 14	Signage incorrect on field */
			INSERT INTO Schedule_Exception (
				EXiDetailID
				,EXiStatusID
				)
			VALUES (
				@DetailID
				,14
				)
		END
	END

	IF ((@AmtExcl + @Vat) <> @AmtIncl)
	BEGIN
		SET @StatusVal = 16

		/* 16	Excl and VAT amount does not add up */
		INSERT INTO Schedule_Exception (
			EXiDetailID
			,EXiStatusID
			)
		VALUES (
			@DetailID
			,16
			)
	END

	/*
IF (@ScheduleIsReward = 0 AND @ScheduleIsStamps = 0 AND @ScheduleIsForceCredit = 0)
BEGIN
	/* Additional changes Phase 7  */
	IF (@AmtIncl < 0) /* Only credits */
	BEGIN
		DECLARE @ClaimStatusId INT
		DECLARE @ClaimReference_StoreCode NVARCHAR(10)
		DECLARE @ClaimReference_ClaimNumber NVARCHAR(10)

		EXEC GetClaimNumberAndStoreCode 
			@ClaimReference = @ClaimRef,
			@StoreCode = @ClaimReference_StoreCode OUTPUT,
			@ClaimNumber = @ClaimReference_ClaimNumber  OUTPUT

		IF (@ClaimReference_ClaimNumber = '' OR @ClaimReference_ClaimNumber = '000000')
		BEGIN
			/* 18	Claim number not specified */
			SET @StatusVal = 18
			INSERT INTO Schedule_Exception (EXiDetailID, EXiStatusID)
				VALUES (@DetailID, 18)
		END
		ELSE IF (LEN(@ClaimReference_ClaimNumber) > 6)
		BEGIN
			SET @StatusVal = 30
			
			INSERT INTO Schedule_Exception (EXiDetailID, EXiStatusID)
			VALUES (@DetailID, 30)
		END
		ELSE IF (LEN(@ClaimReference_ClaimNumber) > 6
			AND @ClaimRef != @StoreCode + ' /' + @ClaimReference_ClaimNumber)
		BEGIN
			SET @StatusVal = 30
		
			INSERT INTO Schedule_Exception (EXiDetailID, EXiStatusID)
			VALUES (@DetailID, 30)
		END
		ELSE 
		BEGIN
			SELECT @ClaimId = CLID, @ClaimStatusId = StatusId FROM Claim WITH (NOLOCK)
			WHERE CLiSupplierID = @SupplierId
				AND CLiStoreID = @StoreId
				AND CLcClaimNumber = @StoreCode + ' /' + @ClaimReference_ClaimNumber

			IF @ClaimId IS NULL
			BEGIN
				SET @StatusVal = 31
				INSERT INTO Schedule_Exception (EXiDetailID, EXiStatusID)
				VALUES (@DetailID, 31)
			END
			ELSE IF @ClaimStatusId = 10
				SET @StatusVal = 32
				INSERT INTO Schedule_Exception (EXiDetailID, EXiStatusID)
				VALUES (@DetailID, 32)
		END
	END
END
*/
	/* Phase 5 updates */
	IF (@ScheduleIsForceCredit = 1)
	BEGIN
		/* Claim number not specified */
		IF (@ClaimRef = '')
		BEGIN
			SET @StatusVal = 18

			INSERT INTO Schedule_Exception (
				EXiDetailID
				,EXiStatusID
				)
			VALUES (
				@DetailID
				,18
				)
		END
		ELSE
		BEGIN
			DECLARE @ClaimCount INT
			DECLARE @IsOpenOrClosed BIT
			DECLARE @ForceCreditInEffect BIT

			SELECT @ClaimId = CLID
				,@ClaimCount = COUNT(CLID)
				,@IsOpenOrClosed = ISNULL(IsOpenOrClosed, 0)
				,@ForceCreditInEffect = ISNULL(ForceCreditInEffect, 0)
			FROM Claim WITH (NOLOCK)
			LEFT JOIN ClaimStatus WITH (NOLOCK) ON (Claim.StatusId = ClaimStatus.Id)
			WHERE dbo.GetClaimNumber(CLcClaimNumber) = dbo.GetClaimNumber(@ClaimRef) -- 52893
				AND CLiSupplierID = @SupplierId -- 1167
				AND CLiStoreID = (
					SELECT STID
					FROM Store
					WHERE STcCode = RTRIM(@StoreCode) -- 21211
						AND STiIsLive = 1
						AND STiDCID = @DCID
					)
				AND CLiDCID = @DCID -- 1
			GROUP BY CLID
				,IsOpenOrClosed
				,ForceCreditInEffect

			IF (ISNULL(@ClaimCount, 0)) = 0
			BEGIN
				SELECT @ClaimId = CLID
					,@ClaimCount = COUNT(CLID)
					,@IsOpenOrClosed = ISNULL(IsOpenOrClosed, 0)
					,@ForceCreditInEffect = ISNULL(ForceCreditInEffect, 0)
				FROM Claim
				JOIN ClaimStatus ON (Claim.StatusId = ClaimStatus.Id)
				WHERE dbo.GetClaimNumber(CLcManualClaimNum) = dbo.GetClaimNumber(@ClaimRef) -- 214337
					AND CLiSupplierID = @SupplierId -- 1167
					AND CLiStoreID = (
						SELECT STID
						FROM Store
						WHERE STcCode = RTRIM(@StoreCode) -- 21211
							AND STiIsLive = 1
							AND STiDCID = @DCID
						)
					AND CLiDCID = @DCID -- 1
				GROUP BY CLID
					,IsOpenOrClosed
					,ForceCreditInEffect
			END

			/* Claim number must match to an existing claim for the supplier */
			IF (ISNULL(@ClaimCount, 0)) = 0
			BEGIN
				SET @StatusVal = 19 /* Claim not found */

				INSERT INTO Schedule_Exception (
					EXiDetailID
					,EXiStatusID
					)
				VALUES (
					@DetailID
					,19
					)
			END
			ELSE /* Claim is found - The claim number must match to an existing "open" claim for the supplier on the CMS. */
			IF ISNULL(@IsOpenOrClosed, 0) = 0
			BEGIN
				SET @StatusVal = 20 /* Claim found is no longer an Open Claim */

				INSERT INTO Schedule_Exception (
					EXiDetailID
					,EXiStatusID
					)
				VALUES (
					@DetailID
					,20
					)
			END
			ELSE /* Matching claim is an open claim */
			BEGIN
				IF (@AmtIncl < 0.00) /* This is a credit note , Claim already has Force Credit in effect */
				BEGIN
					IF ISNULL(@ForceCreditInEffect, 0) = 1
					BEGIN
						SET @StatusVal = 21

						INSERT INTO Schedule_Exception (
							EXiDetailID
							,EXiStatusID
							)
						VALUES (
							@DetailID
							,21
							)
					END
				END
				ELSE /* An invoice, Claim does not have a Force Credit in effect */
				BEGIN
					IF ISNULL(@ForceCreditInEffect, 0) = 0
					BEGIN
						SET @StatusVal = 22

						INSERT INTO Schedule_Exception (
							EXiDetailID
							,EXiStatusID
							)
						VALUES (
							@DetailID
							,22
							)
					END
				END
			END
		END
	END

	UPDATE Schedule_Detail
	SET SDiStatusID = @StatusVal
	WHERE SDID = @DetailID

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION

		SELECT - 1 AS returnvalue

		RETURN
	END

	COMMIT TRANSACTION

	-- Check if there was eny errors
	IF (
			SELECT COUNT(*)
			FROM Schedule_Exception
			WHERE EXiDetailID = @DetailID
			) = 0
		SELECT 0 AS returnvalue
			,SScDescription AS StatusVal
		FROM Schedule_Status
		WHERE SSID = 4
	ELSE
	BEGIN
		SET @StatusID = 2
		SET @StatusVal = (
				SELECT SScDescription
				FROM Schedule_Status
				WHERE SSID = @StatusID
				)

		SELECT SSID AS returnvalue
			,SScDescription AS StatusVal
		FROM Schedule_Status
		WHERE SSID = @StatusID
	END
			/*
	ELSE
		SELECT 0 AS returnvalue, SScDescription AS StatusVal FROM Schedule_Status WHERE SSID = 4
		*/
END

RETURN
