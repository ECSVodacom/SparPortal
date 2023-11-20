ALTER PROC [dbo].[SearchAndListClaimsGrid]
	--DECLARE
	@DCId INT = '-1'
	,@SupplierId INT = '-1'
	,@VendorCode VARCHAR(50) = '-1'
	,@StoreId INT = '-1'
	,@ClaimStatusId INT = 0
	,@ClaimReasonId INT = - 1
	,@FromDate VARCHAR(50) = ''
	,@ToDate VARCHAR(50) = ''
	,@IsHistoryYN VARCHAR(2) = 'N'
	,@PageNumber AS INT = 1
	,@PageSize AS INT = 100
	,@ClaimTypeId AS INT = 0
	,@ClaimNumber AS VARCHAR(20) = ''
	,@ManualClaimNumber AS VARCHAR(30) = ''
	,@ClaimCategoryId AS INT = '-1'
	,@CreditNoteNumber AS VARCHAR(30) = ''
	,@ClaimsOlderThanInMonths AS INT = 0
	,@UserName AS NVARCHAR(20) = ''
	,@ToStatusId AS INT = 0
	,@CreateBatch AS BIT = 0
	,@AddClaimIds AS NVARCHAR(MAX) = ''
	,@ClaimSubCategoryId AS INT = 0
	,@ClaimSubReasonId AS INT = 0
	,@StoreFormat AS NVARCHAR(50) = ''
	,@IncludeAllDataInd AS BIT = 0
	,@BatchUploadId AS INT = 0
	,@OutcomeReason AS INT = 0
	,@HasAttachments AS INT = - 1
	,@BuyerId AS INT = 0
AS

SET NOCOUNT ON;

IF @DCId = 0
	SET @DCId = - 1

IF @VendorCode IS NULL
	SET @VendorCode = '-1'

IF @FromDate <> ''
	AND @ToDate <> ''
BEGIN
	SET @FromDate = SUBSTRING(@FromDate, 7, 4) + '/' + SUBSTRING(@FromDate, 4, 2) + '/' + LEFT(@FromDate, 2)
	SET @ToDate = SUBSTRING(@ToDate, 7, 4) + '/' + SUBSTRING(@ToDate, 4, 2) + '/' + LEFT(@ToDate, 2)
END

PRINT @outcomeReason

DECLARE @RecordFrom INT
DECLARE @RecordTo INT
DECLARE @MaxRecords INT
DECLARE @BandSize INT
DECLARE @ReturnValue INT
DECLARE @RecordCount INT
DECLARE @Type VARCHAR(50)
DECLARE @SupEAN VARCHAR(50)
DECLARE @DCEAN VARCHAR(50)
DECLARE @StoreEAN VARCHAR(50)
DECLARE @InvoiceCount INT
DECLARE @TraceID INT
DECLARE @WhereClause VARCHAR(MAX)
DECLARE @DelCount INT
DECLARE @AndCount INT
DECLARE @VendorName VARCHAR(500)

SET @DelCount = 0

-- Create the temp table
IF @CreateBatch = - 1
	SET @ClaimStatusId = 0

--DROP TABLE #TmpSearch
CREATE TABLE #TmpSearch (
	AutoID INT IDENTITY(1, 1)
	,ClaimID INT
	,SupplierName VARCHAR(500)
	)

SET @WhereClause = 
	'
		SELECT CLID FROM Claim  WITH (NOLOCK)
			INNER JOIN DC WITH (NOLOCK) ON (Claim.CLiDCID = DC.DCID)
			LEFT JOIN CreditNote WITH (NOLOCK) ON (Claim.CLiCNID  = CreditNote.CNID)
			INNER JOIN ClaimStatus WITH (NOLOCK) ON (Claim.StatusId = ClaimStatus.Id )
			LEFT JOIN ClaimReasons WITH (NOLOCK) ON (Claim.CLiReasonID = ClaimReasons.ClaimReasonId )
			LEFT JOIN ClaimCategories WITH (NOLOCK) ON (Claim.ClaimCategoryId = ClaimCategories.ClaimCategoryId)
			LEFT JOIN ClaimSubCategory WITH (NOLOCK) ON (Claim.ClaimSubCategoryId = ClaimSubCategory.SubCategoryID)
			LEFT JOIN dbo.WarehouseClaimCategories WITH (NOLOCK) ON (dbo.WarehouseClaimCategories.DCId = dbo.DC.DCID AND Claim.ClaimCategoryId = WarehouseClaimCategories.CategoryId)
			LEFT JOIN Supplier WITH (NOLOCK) ON (Supplier.SPID = Claim.CLiSupplierID)
			INNER JOIN Store WITH (NOLOCK) ON (Store.STID = Claim.CLiStoreID)
			LEFT JOIN SupplierDCLookup WITH (NOLOCK) ON (Supplier.SPcEANNumber = CASE 
				WHEN SupplierDCLookup.DespatchPoint = ' 
	+ CHAR(39) + CHAR(39) + ' THEN SupplierDCLookup.LocationCode
				ELSE SupplierDCLookup.DespatchPoint END AND BuEanCode = CLcDCEAN 
				AND SupplierDCLookup.VendorCode = CASE WHEN CLcVendorCode IS NULL THEN SupplierDCLookup.VendorCode ELSE CLcVendorCode END
			)
			LEFT JOIN Spar.dbo.Supplier SupplierWH WITH (NOLOCK) ON (SupplierWH.SPID = Claim.CLiSupplierID)
			LEFT JOIN Spar.dbo.SupplierDCLookup SupplierDCLookupWH WITH (NOLOCK) ON (Claim.CLcSupplierEan = CASE WHEN SupplierDCLookupWH.DespatchPoint = ' + CHAR(39) + CHAR(39) + ' THEN 
			SupplierDCLookupWH.LocationCode ELSE SupplierDCLookupWH.DespatchPoint END 
			AND SupplierDCLookupWH.BuEanCode = CASE TypeId WHEN 5 THEN  WarehouseEan ELSE NULL END 
			AND SupplierDCLookupWH.VendorCode = CASE WHEN CLcVendorCode IS NULL THEN SupplierDCLookupWH.VendorCode ELSE CLcVendorCode END
			)  
			
		'
SET @StoreFormat = LTRIM(RTRIM(@StoreFormat))

IF (
		(@DCId <> '-1')
		OR (@SupplierId <> '-1')
		OR (@StoreId <> '-1')
		OR (@ClaimStatusId <> '-1')
		OR (@ClaimStatusId <> '-2')
		OR (@ClaimStatusId <> '-3')
		OR (@ClaimReasonId <> '-1')
		OR (@FromDate <> '')
		OR (@ToDate <> '')
		)
BEGIN
	SET @WhereClause = @WhereClause + ' WHERE '
END

IF @DCId <> '-1'
BEGIN
	SET @WhereClause = @WhereClause + 'CLiDCID = ' + CONVERT(VARCHAR(50), @DCId)
	SET @DelCount = @DelCount + 1
END

IF @SupplierId <> '-1'
	AND @ClaimTypeId NOT IN (5)
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'Supplier.SPID = ' + CONVERT(VARCHAR(50), @SupplierID)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND Supplier.SPID = ' + CONVERT(VARCHAR(50), @SupplierID)
		SET @DelCount = @DelCount + 1
	END
END

IF @SupplierId <> '-1'
	AND @ClaimTypeId IN (5)
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'SupplierWH.SPID = ' + CONVERT(VARCHAR(50), @SupplierID)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND SupplierWH.SPID = ' + CONVERT(VARCHAR(50), @SupplierID)
		SET @DelCount = @DelCount + 1
	END
END

IF @StoreId <> '-1'
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'CLiStoreID = ' + CONVERT(VARCHAR(50), @StoreId)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND CLiStoreID = ' + CONVERT(VARCHAR(50), @StoreId)
		SET @DelCount = @DelCount + 1
	END
END

IF @StoreFormat <> ''
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'LTRIM(RTRIM(ISNULL(Store.STcFormattypeDesc,' + CHAR(39) + 'Unknown' + CHAR(39) + '))) = ' + CHAR(39) + @StoreFormat + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND LTRIM(RTRIM(ISNULL(Store.STcFormattypeDesc,' + CHAR(39) + 'Unknown' + CHAR(39) + '))) = ' + CHAR(39) + @StoreFormat + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
END

-- SHOW ALL CLAIMS REGARDLESS OF STATUS
IF @ClaimStatusId <> '-4' AND @ClaimStatusId <> '-7' AND @ClaimStatusId <> '0'
BEGIN
	-- This will be for all OPEN CLAIMS	
	IF @ClaimStatusId IN ('-1','-5','20')
	BEGIN
		IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'IsOpenOrClosed = 1'
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND IsOpenOrClosed = 1'
			SET @DelCount = @DelCount + 1
		END
	END

	--	-2,All disputed claims
	IF @ClaimStatusId = '-2'
	BEGIN
		IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'StatusId IN (8,9)'
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND StatusId IN (8,9)'
			SET @DelCount = @DelCount + 1
		END
	END

	--	-3,All closed claims
	IF @ClaimStatusId IN ('-3','-6','-8')
	BEGIN
		IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'IsOpenOrClosed = 0'
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND IsOpenOrClosed = 0'
			SET @DelCount = @DelCount + 1
		END
	END
END

--All claims with Force credit in effect for more than 80 days
IF @ClaimStatusId IN ('-9')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'DATEDIFF(DAY, CLdReceivedDate, getdate()) > 80 AND ForceCreditInEffect = 1 '
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + 'AND DATEDIFF(DAY, CLdReceivedDate, getdate()) > 80 AND ForceCreditInEffect = 1 '
		SET @DelCount = @DelCount + 1
	END
END

--All claims in an open state with no attachment that are 48 or more hours old
IF @ClaimStatusId IN ('-10')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'DATEDIFF(HOUR, CLdReceivedDate, getdate()) > 48 and HasAttachments = 0 and IsOpenOrClosed = 1 '
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + 'AND DATEDIFF(HOUR, CLdReceivedDate, getdate()) > 48 and HasAttachments = 0 and IsOpenOrClosed = 1 '
		SET @DelCount = @DelCount + 1
	END
END

--All claims in an open state that are 30 or more days old  
IF @ClaimStatusId IN ('-11')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + ' DATEDIFF(DAY, CLdReceivedDate, getdate()) > 30 and IsOpenOrClosed = 1 '
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND DATEDIFF(DAY, CLdReceivedDate, getdate()) > 30 and IsOpenOrClosed = 1 '
		SET @DelCount = @DelCount + 1
	END
END

IF (@ClaimCategoryId <> '-1')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'Claim.ClaimCategoryId = ' + CONVERT(VARCHAR(50), @ClaimCategoryId)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND Claim.ClaimCategoryId = ' + CONVERT(VARCHAR(50), @ClaimCategoryId)
		SET @DelCount = @DelCount + 1
	END
END

IF (@ClaimStatusId NOT IN ('-8','-9','-10','-11','-1','-2','-3','-4','-5','-6','20','21','-7','0'))
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'StatusId = ' + CONVERT(VARCHAR(50), @ClaimStatusId)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND StatusId = ' + CONVERT(VARCHAR(50), @ClaimStatusId)
		SET @DelCount = @DelCount + 1
	END
END

IF (@ClaimStatusId = '21')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'ForceCreditInEffect = 1 AND StatusId NOT IN (26)'
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND ForceCreditInEffect = 1 AND StatusId NOT IN (26)'
		SET @DelCount = @DelCount + 1
	END
END

IF (@ClaimStatusId = '-7')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'AssignedToHistory = ' + CHAR(39) + 'Y' + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND AssignedToHistory = ' + CHAR(39) + 'Y' + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
END

IF (@ClaimNumber <> '')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'CLcClaimNumber LIKE ' + CHAR(39) + '%' + @ClaimNumber + '%' + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND CLcClaimNumber LIKE ' + CHAR(39) + '%' + @ClaimNumber + '%' + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
END

IF (@ManualClaimNumber <> '')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'CLcManualClaimNum LIKE ' + CHAR(39) + '%' + @ManualClaimNumber + '%' + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND CLcManualClaimNum LIKE ' + CHAR(39) + '%' + @ManualClaimNumber + '%' + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
END

IF (@CreditNoteNumber <> '')
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + '(CNcCreditNoteNumber LIKE ' + CHAR(39) + '%' + @CreditNoteNumber + '%' + CHAR(39)
		SET @WhereClause = @WhereClause + ' OR ProFormaCreditNoteNumber LIKE ' + CHAR(39) + '%' + @CreditNoteNumber + '%' + CHAR(39) + ')'
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND (CNcCreditNoteNumber LIKE ' + CHAR(39) + '%' + @CreditNoteNumber + '%' + CHAR(39)
		SET @WhereClause = @WhereClause + ' OR ProFormaCreditNoteNumber LIKE ' + CHAR(39) + '%' + @CreditNoteNumber + '%' + CHAR(39) + ')'
		SET @DelCount = @DelCount + 1
	END
END

IF @ClaimTypeId = - 1
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'TypeId IN (1,3,4,5) '
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND TypeId IN (1,3,4,5) '
		SET @DelCount = @DelCount + 1
	END
END
ELSE IF @ClaimTypeId <> 0
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'TypeId = ' + CONVERT(VARCHAR(50), @ClaimTypeId)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND TypeId = ' + CONVERT(VARCHAR(50), @ClaimTypeId)
		SET @DelCount = @DelCount + 1
	END
END

IF @ClaimSubCategoryId <> - 1
BEGIN
	IF @DelCount = 0
		SET @WhereClause = @WhereClause + 'Claim.ClaimSubCategoryId = ' + CONVERT(VARCHAR(50), @ClaimSubCategoryId)
	ELSE
		SET @WhereClause = @WhereClause + ' AND Claim.ClaimSubCategoryId = ' + CONVERT(VARCHAR(50), @ClaimSubCategoryId)

	SET @DelCount = @DelCount + 1
END

IF @ClaimReasonId <> - 1
BEGIN
	DECLARE @GroupPricing BIT

	SET @GroupPricing = 0

	IF (SELECT ReasonCode FROM ClaimReasons WITH (NOLOCK) WHERE ClaimReasonId = @ClaimReasonId) = 'PD'
		SET @GroupPricing = 1

	IF @DelCount = 0
	BEGIN
		IF @GroupPricing = 0
			SET @WhereClause = @WhereClause + 'CLiReasonId = ' + CONVERT(VARCHAR(50), @ClaimReasonId)
		ELSE
			SET @WhereClause = @WhereClause + 'ReasonCode IN (''DD'',''PD'',''DR'',''RB'',''TD'',''DU'') '

		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		IF @GroupPricing = 0
			SET @WhereClause = @WhereClause + ' AND CLiReasonId = ' + CONVERT(VARCHAR(50), @ClaimReasonId)
		ELSE
			SET @WhereClause = @WhereClause + ' AND ReasonCode IN (''DD'',''PD'',''DR'',''RB'',''TD'',''DU'') '

		SET @DelCount = @DelCount + 1
	END
END

IF @ClaimSubReasonId <> 0
BEGIN
	IF @DelCount = 0
		SET @WhereClause = @WhereClause + 'Claim.CliSubReasonId = ' + CONVERT(VARCHAR(50), @ClaimSubReasonId)
	ELSE
		SET @WhereClause = @WhereClause + ' AND Claim.CliSubReasonId  = ' + CONVERT(VARCHAR(50), @ClaimSubReasonId)

	SET @DelCount = @DelCount + 1
END

IF @OutcomeReason <> 0
BEGIN
	IF @DelCount = 0
		SET @WhereClause = @WhereClause + 'claim.OutcomeReasonCode = ' + CONVERT(VARCHAR(50), @OutcomeReason)
	ELSE
		SET @WhereClause = @WhereClause + ' AND claim.OutcomeReasonCode  = ' + CONVERT(VARCHAR(50), @OutcomeReason)

	SET @DelCount = @DelCount + 1
END

-- Claims > 30 days
IF @ClaimStatusId IN ('-6','-5')
	AND @FromDate = ''
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + ' CONVERT(VARCHAR(50), CLdReceivedDate,111) < ' + CHAR(39) + CONVERT(VARCHAR(50), DATEADD(DD, - 30, GETDATE()), 111) + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND CONVERT(VARCHAR(50), CLdReceivedDate,111) < ' + CHAR(39) + CONVERT(VARCHAR(50), DATEADD(DD, - 30, GETDATE()), 111) + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
END
		-- Claims < 30 days
ELSE IF @ClaimStatusId IN ('-1','-3')
	AND @FromDate = ''
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + ' CONVERT(VARCHAR(50), CLdReceivedDate,111) BETWEEN ' + CHAR(39) + CONVERT(VARCHAR(50), DATEADD(DD, - 30, GETDATE()), 111) + CHAR(39) + ' AND ' + CHAR(39) + CONVERT(VARCHAR(50), GETDATE(), 111) + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND CONVERT(VARCHAR(50), CLdReceivedDate,111) BETWEEN ' + CHAR(39) + CONVERT(VARCHAR(50), DATEADD(DD, - 30, GETDATE()), 111) + CHAR(39) + ' AND ' + CHAR(39) + CONVERT(VARCHAR(50), GETDATE(), 111) + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
END
ELSE IF @FromDate <> ''
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'CONVERT(VARCHAR(50), CLdReceivedDate,111) BETWEEN ' + CHAR(39) + CONVERT(VARCHAR(50), @FromDate) + CHAR(39) + ' AND ' + CHAR(39) + CONVERT(VARCHAR(50), @ToDate) + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND CONVERT(VARCHAR(50), CLdReceivedDate,111) BETWEEN ' + CHAR(39) + CONVERT(VARCHAR(50), @FromDate) + CHAR(39) + ' AND ' + CHAR(39) + CONVERT(VARCHAR(50), @ToDate) + CHAR(39)
		SET @DelCount = @DelCount + 1
	END
END

IF @ClaimsOlderThanInMonths <> 0
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + 'DATEDIFF(m,CLdReceivedDate,GETDATE()) > ' + CAST(@ClaimsOlderThanInMonths AS NVARCHAR(50))
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND DATEDIFF(m,CLdReceivedDate,GETDATE()) >  ' + CAST(@ClaimsOlderThanInMonths AS NVARCHAR(50))
		SET @DelCount = @DelCount + 1
	END
END

IF @HasAttachments <> - 1
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + ' ISNULL(HasAttachments,0)=' + CAST(@HasAttachments AS VARCHAR(1))
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND ISNULL(HasAttachments,0)=' + CAST(@HasAttachments AS VARCHAR(1))
		SET @DelCount = @DelCount + 1
	END
END

IF @BuyerId <> 0
BEGIN
	IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + ' Buyer_Id=' + CAST(@BuyerId AS VARCHAR(10))
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND Buyer_Id=' + CAST(@BuyerId AS VARCHAR(10))
		SET @DelCount = @DelCount + 1
	END
END

DECLARE @MessageToUser NVARCHAR(250)
DECLARE @XML XML = N'<r><![CDATA[' + REPLACE(@AddClaimIds, '|', ']]></r><r><![CDATA[') + ']]></r>'
DECLARE @ClaimIdsTable TABLE (ClaimId INT NOT NULL)

INSERT INTO @ClaimIdsTable (ClaimId)
SELECT RTRIM(LTRIM(T.c.value('.', 'NVARCHAR(128)')))
FROM @xml.nodes('//r') T(c)

DECLARE @BatchCreated BIT = 0
DECLARE @BatchConfirmed BIT = 0

IF @CreateBatch = 1
BEGIN
	IF @BatchUploadId <> 0
	BEGIN
		UPDATE ClaimsBatchUpdateDetail
		SET IsConfirmed = 1
		WHERE ClaimsBatchUpdate_Id = @BatchUploadId
			AND ClaimId IN (SELECT ClaimId FROM @ClaimIdsTable)
		SET @MessageToUser = 'You can now track the progress of your batch from the Batch Update Tracking option'
		SET @BatchConfirmed = 1
	END
	ELSE IF (
			SELECT COUNT(CLID)
			FROM Claim WITH (NOLOCK)
			WHERE CLID IN (SELECT ClaimId FROM @ClaimIdsTable)
				AND ((ForceCreditInEffect = 1 AND @ToStatusId <> 13)
					OR (COALESCE(ForceCreditInEffect, 0) = 0 AND @ToStatusId <> 26)
					OR (ForceCreditInEffect = 1 AND @ToStatusId <> 12AND StatusId NOT IN (26)))) > 0
	BEGIN
		INSERT INTO ClaimsBatchUpdate (UserName,DateRequested,ToStatusId,BatchStatusId,BatchGuid)
		VALUES (@UserName,GETDATE(),@ToStatusId,1,NEWID())

		DECLARE @ClaimsBatchUpdate_Id INT = SCOPE_IDENTITY()

		INSERT INTO ClaimsBatchUpdateDetail (ClaimsBatchUpdate_Id,ClaimId,FromStatusId,StatusId,ToStatusId)
		SELECT @ClaimsBatchUpdate_Id,ClaimId,StatusId,1,@ToStatusId
		FROM Claim WITH (NOLOCK)
		LEFT JOIN @ClaimIdsTable ON (ClaimId = CLID)
		WHERE CLID IN (SELECT ClaimId FROM @ClaimIdsTable)
			AND ((ForceCreditInEffect = 1AND @ToStatusId <> 13) OR (COALESCE(ForceCreditInEffect, 0) = 0 AND @ToStatusId <> 26)
				OR (ForceCreditInEffect = 1AND @ToStatusId <> 12))

		SET @MessageToUser = 'New batch ' + CAST(@ClaimsBatchUpdate_Id AS NVARCHAR) + ' created'
		SET @BatchCreated = 1
	END
	ELSE
	BEGIN
		IF @ToStatusId = 26
			SET @MessageToUser = 'No batch created - Status "Permanent Force Credit" could not be applied to claims already force credited';
		ELSE IF @ToStatusId = 13
			SET @MessageToUser = 'No batch created - Status "Rejected by DC" could not be applied to claims with a force credit in effect';
		ELSE IF @ToStatusId = 12
			SET @MessageToUser = 'No batch created - Status "DC Force Credit Reversed" could not be applied to claims where Force Credit In Effect is set to "N"';
	END
END;

IF @AddClaimIds <> ''
	SET @WhereClause = @WhereClause + ' AND CLID IN (' + REPLACE(SUBSTRING(@AddClaimIds, 2, LEN(@AddClaimIds) - 2), '||', ',') + ')'

--PRINT @WhereClause
INSERT INTO #TmpSearch (ClaimID)
EXEC (@WhereClause)

DECLARE @TotalRecords INT = @@ROWCOUNT;

WITH ClaimsRN
AS (
	SELECT ROW_NUMBER() OVER (
			ORDER BY CLdReceivedDate DESC
				,DCcName
				,Supplier.SPcName
				,STcName
				,CLcClaimNumber
			) AS RowNumber
		,CLdReceivedDate AS ReceivedDateU
		,Claim.LastUpdated AS LastUpdatedU
		,Claim.CLID AS CLID
		,DCcName
		,CASE TypeId WHEN 5 THEN SupplierWH.SPcName ELSE Supplier.SPcName END SPcName
		,CASE TypeId WHEN 5 THEN ISNULL(SupplierDCLookupWH.VendorName, '-') ELSE ISNULL(SupplierDCLookup.VendorName, '-') END VendorName
		,CASE TypeId WHEN 5 THEN ISNULL(SupplierDCLookupWH.VendorCode, '-') ELSE ISNULL(SupplierDCLookup.VendorCode, '-') END VendorCode
		,CASE TypeId WHEN 5 THEN '-' ELSE Store.STcName END STcName
		,CLcClaimNumber
		,CONVERT(NVARCHAR(15), CLdReceivedDate, 106) + ' <br/>[' + CONVERT(NVARCHAR(15), CLdReceivedDate, 108) + ']' AS CLdReceivedDate
		,ClaimStatus.Value AS ClaimStatus
		,CONVERT(NVARCHAR(15), Claim.LastUpdated, 106) + ' <br/>[' + CONVERT(NVARCHAR(15), Claim.LastUpdated, 108) + ']' AS LastUpdated
		,CLcClaimType
		,isnull(ClaimReasons.value, '-') AS ClaimReason
		,CONVERT(NVARCHAR(15), CLdInvoiceDate, 106) AS CLdInvoiceDate
		,CNcCreditNoteNumber AS CreditNoteNumber
		,ROUND(CNmTotCostIncl, 2) AS CreditNoteAmount
		,CLiInvoiceID
		,CLcInvoiceNumber
		,ClaimStatus.Id AS ClaimStatusId
		,ProFormaCreditNoteNumber
		,ROUND(ProFormaCreditAmount, 2) AS ProFormaCreditAmount
		,CLiCNID
		,CreditNote.IsForceCredit CreditNoteIsForceCredit
		,CASE TypeId WHEN 5 THEN '-' ELSE Store.STcFormatTypeDesc END STcFormatTypeDesc
		,CASE  WHEN DCCategoryName IS NULL THEN ClaimCategory ELSE DCCategoryName END AS ClaimCategory
		,CASE WHEN ClaimSubCategoryName IS NULL THEN '-' ELSE ClaimSubCategoryName END AS ClaimSubCategoryName
		,CLcManualClaimNum AS ManualClaimNumber
		,ClaimStatus.IsOpenOrClosed
		,COALESCE(Claim.ForceCreditInEffect, 0) AS ForceCreditInEffect
		,CLmAmount AS ClaimAmount
		,CLmVat AS ClaimAmountVat
		,(CLmAmount - CLmVat) AS ClaimAmountExclusive
		,CLcNarratives AS Narrative
		,REPLACE((REPLACE(AuditLog_Comments, CHAR(13) + CHAR(10), ' ')), ',', ' ') Comment
		,NewClaimStatus.Value NewClaimStatus
		,ClaimInvestigationOutcomes.Value AS OutcomeReasonValue
		,AuthorisedByRep AS Authorised
		,UpliftRef
		,ClaimSubReasons.[Description] ClaimSubReason
		,@ClaimsBatchUpdate_Id ClaimsBatchUpdate_Id
		,@BatchCreated BatchCreated
		,@BatchConfirmed BatchConfirmed
		,HasAttachments
		,BuyerName
		,BuyerEmailAddress
	FROM #TmpSearch WITH (NOLOCK)
	INNER JOIN Claim ON (ClaimID = Claim.CLID)
	INNER JOIN DC WITH (NOLOCK) ON (Claim.CLiDCID = DC.DCID)
	LEFT JOIN CreditNote WITH (NOLOCK) ON (Claim.CLiCNID = CreditNote.CNID)
	INNER JOIN ClaimStatus WITH (NOLOCK) ON (Claim.StatusId = ClaimStatus.Id)
	--LEFT JOIN ClaimsBatchUpdateDetail ON (ClaimsBatchUpdateDetail.ClaimId = Claim.CLID)
	LEFT JOIN ClaimsBatchUpdateDetail ON (ClaimsBatchUpdateDetail.Id = (SELECT MAX(Id) FROM ClaimsBatchUpdateDetail WHERE ClaimId = Claim.CLID))
	LEFT JOIN ClaimStatus NewClaimStatus ON (ClaimsBatchUpdateDetail.ToStatusId = NewClaimStatus.Id)
	LEFT JOIN ClaimReasons WITH (NOLOCK) ON (Claim.CLiReasonID = ClaimReasons.ClaimReasonId)
	LEFT JOIN ClaimCategories WITH (NOLOCK) ON (Claim.ClaimCategoryId = ClaimCategories.ClaimCategoryId)
	LEFT JOIN ClaimSubReasons WITH (NOLOCK) ON (ClaimSubReasons.ClaimSubReasonId = Claim.CliSubReasonId)
	LEFT JOIN ClaimSubCategory WITH (NOLOCK) ON (Claim.ClaimSubCategoryId = ClaimSubCategory.SubCategoryID)
	LEFT JOIN dbo.WarehouseClaimCategories WITH (NOLOCK) ON (dbo.WarehouseClaimCategories.DCId = dbo.DC.DCID 
	AND Claim.ClaimCategoryId = WarehouseClaimCategories.CategoryId)
	LEFT JOIN Supplier WITH (NOLOCK) ON (Supplier.SPID = Claim.CLiSupplierID)
	LEFT JOIN SupplierDCLookup WITH (NOLOCK) ON (Supplier.SPcEANNumber = CASE WHEN SupplierDCLookup.DespatchPoint = ''
			THEN SupplierDCLookup.LocationCode
				ELSE SupplierDCLookup.DespatchPoint
				END
			AND BuEanCode = CLcDCEAN
			AND SupplierDCLookup.VendorCode = CASE 
				WHEN CLcVendorCode IS NULL
					THEN SupplierDCLookup.VendorCode
				ELSE CLcVendorCode
				END
			)
	INNER JOIN Store WITH (NOLOCK) ON (Store.STID = Claim.CLiStoreID)
	LEFT JOIN ClaimInvestigationOutcomes ON claim.OutcomeReasonCode = ClaimInvestigationOutcomes.ID
	LEFT JOIN Spar.dbo.Supplier SupplierWH WITH (NOLOCK) ON (SupplierWH.SPID = Claim.CLiSupplierID)
	LEFT JOIN Spar.dbo.SupplierDCLookup SupplierDCLookupWH WITH (NOLOCK) ON (
			Claim.CLcSupplierEan = CASE 
				WHEN SupplierDCLookupWH.DespatchPoint = ''
					THEN SupplierDCLookupWH.LocationCode
				ELSE SupplierDCLookupWH.DespatchPoint
				END
			AND SupplierDCLookupWH.BuEanCode = CASE TypeId
				WHEN 5
					THEN WarehouseEan
				ELSE NULL
				END
			AND SupplierDCLookupWH.VendorCode = CASE 
				WHEN CLcVendorCode IS NULL
					THEN SupplierDCLookupWH.VendorCode
				ELSE CLcVendorCode
				END
			)
	LEFT JOIN Buyer WITH (NOLOCK) ON (Buyer.BUID = CASE @BuyerId WHEN 0 THEN Buyer_Id ELSE @BuyerId END)
	)
SELECT *
	,@TotalRecords AS TotalRecords
	,@PageSize AS PageSize
	,@AddClaimIds ClaimIdsAdded
	,@MessageToUser MessageToUser
FROM ClaimsRN WITH (NOLOCK)
WHERE RowNumber BETWEEN (@PageNumber - 1) * @PageSize + 1
		AND @PageNumber * @PageSize
ORDER BY RowNumber

--PRINT @wHERECLAUSE