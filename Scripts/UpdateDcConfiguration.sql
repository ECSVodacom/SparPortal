
ALTER PROC [dbo].[UpdateDcConfiguration] 
	@DCId INT,
	@AllowClaimCaptureForSupplier BIT,
	@AllowClaimCaptureForAdminDC BIT,
	@AllowDCsToMaintainSupplierClaims BIT,
	@DCEmailAddressForAdminDCClaims VARCHAR(1000),
	@DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims VARCHAR(1000),
	@IsDCAllowedToUploadForceCredits INT = -1,
	@IsDCToCaptureAdminDCClaims INT = -1,
	@AllowClaimEmails BIT,
	@AllowDCManageBuildIt BIT,
	@WarehouseClaimTollerence varchar(100),
	@SupplierClaimTollerence varchar(100),
	@BuilditDcClaimTollerence varchar(100),
	@DcVendorClaimTollerance varchar(100),
	@AllowDCGenerateForceCredits BIT,
	@IsDCAllowedToChangeClaimNumberOnSchedule BIT,
	@IsdcAllowedAutoMatchingOfAdminClaim BIT,
	@ScheduleTolerance int,
	@AllowAcknowledgedBySupplier BIT

AS
IF @AllowClaimCaptureForAdminDC = 0 AND @IsDCToCaptureAdminDCClaims = 0
	SET @IsdcAllowedAutoMatchingOfAdminClaim = 0

UPDATE DC SET 
	AllowClaimCaptureForSupplier = @AllowClaimCaptureForSupplier,
	AllowClaimCaptureForAdminDC = @AllowClaimCaptureForAdminDC, 
	AllowDCsToMaintainSupplierClaims = @AllowDCsToMaintainSupplierClaims,
	DCEmailAddressForAdminDCClaims = @DCEmailAddressForAdminDCClaims,	
	DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims = @DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims,
	--Lesley Change reguest 03/08/2020 Petrus/Xander
    IsdcAllowedAutoMatchingOfAdminClaim = @IsdcAllowedAutoMatchingOfAdminClaim ,
	IsDCAllowedToUploadForceCredits = 
		CASE @IsDCAllowedToUploadForceCredits 
			WHEN -1 THEN IsDCAllowedToUploadForceCredits
			ELSE @IsDCAllowedToUploadForceCredits
		END,
	IsDCToCaptureAdminDCClaims =
		CASE @IsDCToCaptureAdminDCClaims
			WHEN -1 THEN IsDCToCaptureAdminDCClaims
			ELSE @IsDCToCaptureAdminDCClaims
		END,
	AllowDCGenerateForceCredits = @AllowDCGenerateForceCredits,
	IsDCAllowedToChangeClaimNumberOnSchedule = @IsDCAllowedToChangeClaimNumberOnSchedule,
	AllowClaimEmails = @AllowClaimEmails,
	AllowDCManageBuildIt = @AllowDCManageBuildIt,
	WarehouseClaimTollerence = @WarehouseClaimTollerence,
	SupplierClaimTollerence = @SupplierClaimTollerence,
	BuilditDcClaimTollerance = @BuilditDcClaimTollerence,
	DcVendorClaimTollerance = @DcVendorClaimTollerance,
	ScheduleTolerance = @ScheduleTolerance,
	AllowAcknowledgedBySupplier = @AllowAcknowledgedBySupplier
WHERE DCID = @DCId

