USE [SparDS]
GO
/****** Object:  StoredProcedure [dbo].[Claims_Batch_Update]    Script Date: 2023/10/23 11:56:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Claims_Batch_Update]
--DECLARE
@ClaimNumber VARCHAR(50),
@FromStatus Varchar(100),
@ToStatus Varchar(100),
@DcId int
AS

DECLARE @StatusId VARCHAR(10)

SELECT @StatusId = Id from ClaimStatus where @ToStatus = [Value]

--DECLARE @StatusId INT = 16
DECLARE @Comments VARCHAR(50) = '' /* The service request number and any other comments */

DECLARE @CurrentStatusId INT
DECLARE @NewStatusId INT
DECLARE @ErrorCode INT = 0
DECLARE @ResponseMessage NVARCHAR(250)

DECLARE @ClaimId INT
DECLARE @ClaimStoreId INT 
DECLARE @ClaimSupplierId INT
DECLARE @StoreId INT
DECLARE @StoreCode NVARCHAR(10) 

IF @ErrorCode <> -1 
BEGIN
----print 'Current Status is Null'
	SELECT @CurrentStatusId = Id FROM ClaimStatus WHERE Value = @FromStatus
	IF @CurrentStatusId IS NULL 
		SELECT @ErrorCode = -1, @ResponseMessage = @ClaimNumber + ' - current claim status is invalid  '
END

IF @ErrorCode <> -1 
BEGIN
----print 'New Status is Null'
	SELECT @NewStatusId = Id FROM ClaimStatus WHERE Value = @ToStatus
	IF @NewStatusId IS NULL 
		SELECT @ErrorCode = -1, @ResponseMessage = @ClaimNumber + ' - new claim status is invalid  ' 
END

IF @ErrorCode <> -1 
BEGIN
	SELECT @StoreId=STID 
		FROM Store WITH (NOLOCK)
	WHERE STcCode = dbo.GetStoreNumber(@ClaimNumber)
			AND STiDCID = @DcId
			AND STiIsLive = 1
	
	----print 'Store is null'
	IF @StoreId IS NULL
		SELECT @ErrorCode = -1, @ResponseMessage = 
			@ClaimNumber + ' - store not found.<br/>Either the store is not live or is not for the correct DC  '
END

IF @ErrorCode <> -1 
BEGIN
	SELECT @ClaimId = CLID 
		FROM Claim WITH (NOLOCK) 
	WHERE CLcClaimNumber = LTRIM(RTRIM(@ClaimNumber))
		AND CLiStoreID = @StoreId
		AND CLiDCID = @DcId

	IF @ClaimId IS NULL
		SELECT @ErrorCode = -1, @ResponseMessage = 
			@ClaimNumber + ' - claim not found.<br/>Confirm claim exists for selected DC, Supplier and Store  '
----print 'here'
END

-----------
IF @ErrorCode <> -1 
BEGIN
	SELECT @CurrentStatusId = StatusId 
		FROM Claim WITH (NOLOCK) 
	WHERE CLcClaimNumber = LTRIM(RTRIM(@ClaimNumber))
		AND CLiStoreID = @StoreId
		AND CLiDCID = @DcId

	IF @CurrentStatusId = @StatusId
		SELECT @ErrorCode = -1, @ResponseMessage = 
			@ClaimNumber + ' - New claim status cannot be the same as previous claim status.  '
----print 'here'
END

------------

IF @ErrorCode = -1 /* Reject batch */
BEGIN
	SELECT @ErrorCode ErrorCode, @ResponseMessage ResponseMessage
END
ELSE
BEGIN
/* Add entry log */
SELECT 0 ErrorCode, @ClaimNumber + ' - validated | ' ResponseMessage, @ClaimId ClaimId, @NewStatusId NewClaimStatusId

INSERT INTO ClaimsAuditLog (ClaimId, ClaimStatusId, StatusChangedDate, SupplierComments, ActionTaken, StatusChangedByUserName)
SELECT CLID , @StatusId, GETDATE(),  @Comments,'S','SYSTEM USER' FROM Claim WHERE CLcClaimNumber IN 
(@ClaimNumber)


UPDATE Claim SET StatusId = @StatusId 
WHERE CLcClaimNumber IN (@ClaimNumber)
AND StatusId <> @StatusId


END

