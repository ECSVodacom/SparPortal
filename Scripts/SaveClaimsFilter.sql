

-- SaveClaimsFilter @UserName = 'SPARHEADOFFICE',@FilterName = 'test_Matimba'
--, @DCId=1, @ClaimTypeId=1, @ClaimCategoryId=37, @ClaimSubCategoryId=-1, @ClaimReasonId=-1
--, @ClaimSubReasonId=0, @OutcomeReasonId=3, @BuyerId=3, @SupplierId=1180, @StoreFormat='Build-It '
--,@StoreId=3514,@ClaimStatusId=-4,@ClaimNumber='111',@ManualClaimNumber='1123',@DiscountNoteNumber='1333'
--, @HasAttachments='1',@FromDate='05/11/2023',@ToDate='07/11/2023'

ALTER PROCEDURE [dbo].[SaveClaimsFilter] 
@UserName VARCHAR(100)
	,@FilterName VARCHAR(100)
	,@DCId INT
	,@ClaimTypeId INT
	,@ClaimCategoryId INT
	,@ClaimSubCategoryId INT
	,@ClaimReasonId INT
	,@ClaimSubReasonId INT
	,@OutcomeReasonId INT
	,@BuyerId INT
	,@SupplierId INT
	,@StoreFormat varchar(50)
	,@StoreId INT
	,@ClaimStatusId INT
	,@ClaimNumber VARCHAR(50) = ''
	,@ManualClaimNumber VARCHAR(50) = ''
	,@DiscountNoteNumber VARCHAR(50) = ''
	,@HasAttachments BIT
	,@FromDate DATETIME = ''
	,@ToDate DATETIME = ''
AS
DECLARE @ClaimsFilterCount INT = 0
DECLARE @ID UNIQUEIDENTIFIER = NEWID()

BEGIN
	SELECT @ClaimsFilterCount = COUNT(*)
	FROM ClaimsFilter
	WHERE Username = @UserName
		AND FilterName = @FilterName

	IF @ClaimsFilterCount = 0
	BEGIN
		INSERT INTO ClaimsFilter (
		Username
			,FilterName
			,DCId
			,ClaimTypeId
			,ClaimCategoryId
			,ClaimSubCategoryId
			,ClaimReasonId
			,ClaimSubReasonId
			,OutcomeReasonId
			,BuyerId
			,SupplierId
			,StoreFormat
			,StoreId
			,ClaimStatusId
			,ClaimNumber
			,ManualClaimNumber
			,DiscountNoteNumber
			,HasAttachments
			,FromDate
			,ToDate
			)
		VALUES (
		@UserName
			,@FilterName
			,@DCId
			,@ClaimTypeId
			,@ClaimCategoryId
			,@ClaimSubCategoryId
			,@ClaimReasonId
			,@ClaimSubReasonId
			,@OutcomeReasonId
			,@BuyerId
			,@SupplierId
			,@StoreFormat
			,@StoreId
			,@ClaimStatusId
			,@ClaimNumber
			,@ManualClaimNumber
			,@DiscountNoteNumber
			,@HasAttachments
			,@FromDate
			,@ToDate
			)
	END
	ELSE
	BEGIN
		UPDATE ClaimsFilter
		SET DCId = @DCId
			,ClaimTypeId = @ClaimTypeId
			,ClaimCategoryId = @ClaimCategoryId
			,ClaimSubCategoryId = @ClaimSubCategoryId
			,ClaimReasonId = @ClaimReasonId
			,ClaimSubReasonId = @ClaimSubReasonId
			,OutcomeReasonId = @OutcomeReasonId
			,BuyerId = @BuyerId
			,SupplierId = @SupplierId
			,StoreFormat = @StoreFormat
			,StoreId = @StoreId
			,ClaimStatusId = @ClaimStatusId
			,ClaimNumber = @ClaimNumber
			,ManualClaimNumber = @ManualClaimNumber
			,DiscountNoteNumber = @DiscountNoteNumber
			,HasAttachments = @HasAttachments
			,FromDate = @FromDate
			,ToDate = @ToDate
		WHERE Username = @UserName
			AND FilterName = @FilterName
	END
END
