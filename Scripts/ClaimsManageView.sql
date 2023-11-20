
ALTER PROC [dbo].[ClaimsManageView] 
	@ClaimId INT, 
	@UserLoggedInId INT = 0,
	@ClaimTypeId INT = 0
AS


SET NOCOUNT ON;

DECLARE @WGuid UNIQUEIDENTIFIER = NULL
DECLARE @StatusesApplicableIds NVARCHAR(50) = ''
DECLARE @UserLoggedIn NVARCHAR(20) 
DECLARE @ClaimSubReasonId INT
DECLARE @ClaimSubReason NVARCHAR(50)
DECLARE @OutcomeReasonCodeV  NVARCHAR(20)
Declare @WarehouseUser INT

IF @UserLoggedInId <> 0
	SELECT TOP 1 @UserLoggedIn = UScUserName, @WarehouseUser = IsWarehouseUser 
		FROM Users WITH (NOLOCK) 
	WHERE USID = @UserLoggedInId AND USiParent IN  (4612,2401,4609,4610,4611,4612,4613)
ELSE
	SET @UserLoggedIn = ''
	
EXEC GetWarehouseClaimConfiguration 
	@ClaimId = @ClaimId, 
	@StatusesApplicableIds = @StatusesApplicableIds OUTPUT,
	@WGuid = @WGuid OUTPUT

	SELECT @ClaimSubReasonId = ISNULL(CliSubReasonId,0), @ClaimSubReason=ISNULL([Description],'') FROM Claim WITH (NOLOCK)
			LEFT JOIN ClaimSubReasons WITH (NOLOCK) ON (CliSubReasonId = ClaimSubReasons.ClaimSubReasonId)
	WHERE CLID = @ClaimId

	SELECT STcName AS StoreName, STcCode AS StoreCode, STcEANNumber AS StoreEan,Store.STiIsLive AS StoreIsLive, store.STiDCID AS StoreDcID,
		CASE TypeId WHEN 5 THEN 
			CASE WHEN  SupplierDCLookupWH.VendorName IS NULL OR LEN( SupplierDCLookupWH.VendorName) = 0 THEN SupplierWH.SPcName ELSE SupplierDCLookupWH.VendorName END  
			ELSE CASE WHEN SupplierDCLookup.VendorName IS NULL OR LEN( SupplierDCLookup.VendorName) = 0 THEN Supplier.SPcName ELSE SupplierDCLookup.VendorName END
	    END SupplierName,
		CASE TypeId WHEN 5 THEN SupplierDCLookupWH.VendorCode ELSE SupplierDCLookup.VendorCode END DCVendorCode,
		CASE TypeId WHEN 5 THEN SupplierDCLookupWH.LocationCode ELSE SupplierDCLookup.LocationCode END DCVendorPrimaryEAN,
		CASE TypeId WHEN 5 THEN SupplierDCLookupWH.DespatchPoint ELSE  SupplierDCLookup.DespatchPoint END  DCVendorSecondaryEAN,
		CASE TypeId WHEN 5 THEN 
			CASE WHEN  SupplierDCLookupWH.EmailAddress IS NULL OR LEN( SupplierDCLookupWH.EmailAddress) = 0 THEN SupplierWH.SPcEMail ELSE SupplierDCLookupWH.EmailAddress END 
			ELSE CASE WHEN SupplierDCLookup.EmailAddress IS NULL OR LEN( SupplierDCLookup.EmailAddress) = 0 THEN Supplier.SPcFuncEmail ELSE SupplierDCLookup.EmailAddress  END
		END EmailAddress , 
		CLcClaimNumber AS ClaimNumber, ClaimStatus.Value AS ClaimStatus, 
		REPLACE(CONVERT(VARCHAR(50),CLdReceivedDate,120),'-','/') DateReceived, Claim.StatusId AS ClaimStatusId, 
		(SELECT TOP 1 StatusChangedByUserName FROM ClaimsAuditLog WITH (NOLOCK) WHERE ClaimId = @ClaimId ORDER BY ClaimsAuditLogId DESC)  AS UserName,
		ISNULL(AssignedToHistory,'N') AS AssignedToHistory, 
		CASE WHEN DCCategoryName IS NULL THEN ClaimCategory  ELSE DCCategoryName END AS ClaimCategory, 
		CLcManualClaimNum AS ManualClaimNumber, ClaimReasons.Value as ClaimReason,isnull(ClaimReasons.AllowSubReasons,0)AllowSubReasons , 
		TypeId AS ClaimTypeId,DC.AllowDCManageBuildIt,ISNULL(AuthorisedByRep,'0')AS AuthorisedByRep,UpliftRef,
		Claim.ClaimCategoryId,ClaimSubCategoryName,ISNULL(ClaimSubCategoryID,-1) ClaimSubCategoryID , ISNULL(ClaimReasons.ClaimReasonId,-1) ClaimReasonId, Claim.ForceCreditInEffect AS ForceCreditInEffect ,
			ClaimTypes.Value ClaimTypeName,
			@WGuid [Guid],
			@UserLoggedIn AS UserLoggedIn,
			@WarehouseUser AS IsWarehouseUser,
			STcEmail AS StoreEmail,
		@StatusesApplicableIds StatusesApplicableIds,
		@ClaimSubReasonId ClaimSubReasonId, 
		@ClaimSubReason ClaimSubReason,
		ISNULL(OutcomeReasonCode,0) OutcomeReasonCode,
		CIO.Value  OutcomeReasonCodeV,
		BUID, BuyerName, BuyerEmailAddress,
		CLcInvoiceNumber ManualInvoiceNumber,
		ISNULL(dc.AllowAcknowledgedBySupplier, 0) AllowAcknowledgedBySupplier
	FROM Claim WITH (NOLOCK)
		INNER JOIN Store WITH (NOLOCK) ON (Claim.CLiStoreID = Store.STID AND Claim.CLiDCID = Store.STiDCID)
		LEFT JOIN Supplier WITH (NOLOCK) ON (Claim.CLiSupplierID = Supplier.SPID)
		LEFT JOIN Spar.dbo.Supplier SupplierWH WITH (NOLOCK) ON (Claim.CLiSupplierID = SupplierWH.SPID)
		INNER JOIN ClaimStatus WITH (NOLOCK) ON (Claim.StatusId = ClaimStatus.Id)
		LEFT JOIN ClaimCategories WITH (NOLOCK) ON (Claim.ClaimCategoryId = ClaimCategories.ClaimCategoryId)
		LEFT JOIN ClaimSubCategory WITH (NOLOCK) ON (Claim.ClaimSubCategoryId = ClaimSubCategory.SubCategoryID)
		LEFT JOIN dbo.WarehouseClaimCategories WITH (NOLOCK) ON (dbo.WarehouseClaimCategories.DCId = dbo.Claim.CLiDCID AND Claim.ClaimCategoryId = WarehouseClaimCategories.CategoryId)
		LEFT JOIN ClaimReasons WITH (NOLOCK) ON (Claim.CLiReasonID = ClaimReasons.ClaimReasonId)
		LEFT JOIN ClaimSubReasons WITH (NOLOCK) ON (@ClaimSubReasonId = ClaimSubReasons.ClaimReasonId)
		INNER JOIN DC with (NOLOCK) ON (claim.CLiDCID = dc.DCID)
		LEFT JOIN SupplierDCLookup WITH (NOLOCK) ON (Supplier.SPcEANNumber = CASE	
				WHEN SupplierDCLookup.DespatchPoint = '' THEN SupplierDCLookup.LocationCode
				ELSE SupplierDCLookup.DespatchPoint END AND SupplierDCLookup.BuEanCode = Claim.CLcDCEAN
				AND SupplierDCLookup.VendorCode = CASE WHEN CLcVendorCode IS NULL THEN SupplierDCLookup.VendorCode ELSE CLcVendorCode END
				/*AND CLcVendorCode = CASE WHEN CLcVendorCode IS NULL THEN NULL ELSE  SupplierDCLookup.VendorCode END*/
				)
		LEFT JOIN Spar.dbo.SupplierDCLookup SupplierDCLookupWH WITH (NOLOCK) ON (CLcSupplierEAN = CASE	
				WHEN SupplierDCLookupWH.DespatchPoint = '' THEN SupplierDCLookupWH.LocationCode
				ELSE SupplierDCLookupWH.DespatchPoint END AND SupplierDCLookupWH.BuEanCode = DC.WarehouseEan
				AND SupplierDCLookupWH.VendorCode = CASE WHEN CLcVendorCode IS NULL THEN SupplierDCLookupWH.VendorCode ELSE CLcVendorCode END
				/*AND CLcVendorCode = CASE WHEN CLcVendorCode IS NULL THEN NULL ELSE  SupplierDCLookupWH.VendorCode END*/
				)
		LEFT JOIN ClaimInvestigationOutcomes CIO on claim.OutcomeReasonCode = CIO.ID
		LEFT JOIN ClaimTypes ON (Claim.TypeId = ClaimTypes.Id)
		LEFT JOIN Buyer ON (Buyer.BUID = Claim.Buyer_Id)
	WHERE Claim.CLID = @ClaimID



