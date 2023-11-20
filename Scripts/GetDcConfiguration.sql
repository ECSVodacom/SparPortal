
ALTER PROC [dbo].[GetDcConfiguration] 
	@DCId INT,
	@StoreId INT = 0,
	@IsDCAllowedToUploadForceCredits BIT = 0
AS

DECLARE @IsStoreLive AS BIT = 0
DECLARE @IsStoreAllowedCaptureClaimForSuppliers AS BIT 

IF @StoreId <> 0
	SELECT @IsStoreAllowedCaptureClaimForSuppliers = 
		CASE  
			WHEN STcCalimsforSuppInd = 'Y' OR ClaimCaptureOverrideIndicator = 'Y' THEN '1'
			ELSE '0'
		END,
		@IsStoreLive = STiIsLive
	FROM Store
	WHERE STID = @StoreId 
		--AND STiDCID = @DCId
		
SELECT CASE
		WHEN @IsStoreAllowedCaptureClaimForSuppliers = 1 
			THEN COALESCE(AllowClaimCaptureForSupplier,1) 
		ELSE 
			COALESCE(AllowClaimCaptureForSupplier,0) 
		END AS AllowClaimCaptureForSupplier, 
	COALESCE(AllowClaimCaptureForAdminDC,0) AS AllowClaimCaptureForAdminDC, 
	COALESCE(AllowDCsToMaintainSupplierClaims,0) AS AllowDCsToMaintainSupplierClaims,
	COALESCE(DCEmailAddressForAdminDCClaims,'') AS DCEmailAddressForAdminDCClaims,	
	COALESCE(DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims,'') AS DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims,
	COALESCE(@IsStoreAllowedCaptureClaimForSuppliers,0) AS IsStoreAllowedCaptureClaimForSuppliers,
	COALESCE(@IsStoreLive,0) AS IsStoreLive,
	COALESCE(IsDCAllowedToUploadForceCredits,0) AS IsDCAllowedToUploadForceCredits,
	COALESCE(IsDCToCaptureAdminDCClaims,0) AS IsDCToCaptureAdminDCClaims,
	COALESCE(AllowClaimEmails,0) AS AllowClaimEmails,
	COALESCE(AllowDCManageBuildIt,0) AS AllowDCManageBuildIt,
	ISNULL(AllowDCGenerateForceCredits,0) AS AllowDCGenerateForceCredits,
	COALESCE(IsDCAllowedToChangeClaimNumberOnSchedule,0) IsDCAllowedToChangeClaimNumberOnSchedule,
	IsNUll(WarehouseClaimTollerence,'1.00') WarehouseClaimTollerence, 
	iSnULL(SupplierClaimTollerence,'1.00') SupplierClaimTollerence,
	IsNull(BuilditDcClaimTollerance,'1.00') BuilditDcClaimTollerance,
	isNull(DcVendorClaimTollerance,'1.00')DcVendorClaimTollerance,
	ISNULL(AllowDCGenerateForceCredits,0) AllowDCGenerateForceCredits,
	ISNULL(IsdcAllowedAutoMatchingOfAdminClaim,0) IsdcAllowedAutoMatchingOfAdminClaim,
	ISNULL(ScheduleTolerance,0) ScheduleTolerance,
	ISNULL(AllowAcknowledgedBySupplier,0) AllowAcknowledgedBySupplier
FROM DC
WHERE DCID = @DCId
