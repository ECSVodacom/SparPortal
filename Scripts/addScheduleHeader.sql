
ALTER PROCEDURE [dbo].[addScheduleHeader] @FileName VARCHAR(150)
	,@Size INT
	,@DCID INT
	,@CreateDate DATETIME = NULL
	,@ValidateDate DATETIME = NULL
	,@ReleaseDate DATETIME = NULL
	,@EditDate DATETIME = NULL
	,@Total NUMERIC(12, 4) = 0
	,@NumberOfDoc NUMERIC(12, 4) = 0
	,@StatusID INT = 0
	,@SupplierID INT
	,@UserID INT
	,@IsForceCredit BIT = 0
	,@IsRewardsNumeric BIT = 0
	,@IsStampsNumeric BIT = 0
	,@IsAdmin BIT = 0
AS
SET NOCOUNT ON

DECLARE @ScheduleTolerance NUMERIC(10, 2)

SELECT @ScheduleTolerance = ScheduleTolerance
FROM DC
WHERE DCID = @DCID

BEGIN TRANSACTION

IF @Total > @ScheduleTolerance
BEGIN
	SET @StatusID = 36
END

-- Insert the new record
INSERT INTO Schedule_Header (SHcFileName,SHiSize,SHiDCID,SHiSupplierID,SHdCreateDate,SHdValidateDate,SHdReleaseDate,SHdEditDate,SHnTotal,SHnNumberOfDoc
	,SHiStatusID,SHiUserID,IsForceCredit,IsReward,IsStamps,IsAdmin
	)
VALUES (@FileName,@Size,@DCID,@SupplierID,GETDATE(),@ValidateDate,@ReleaseDate,@EditDate,@Total,@NumberOfDoc,@StatusID,@UserID,@IsForceCredit
,@IsRewardsNumeric,@IsStampsNumeric,@IsAdmin
	)

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRANSACTION

	SELECT - 1 AS returnvalue

	RETURN
END

COMMIT TRANSACTION

SELECT 0 AS returnvalue
	,@@IDENTITY AS newHeadID

RETURN
