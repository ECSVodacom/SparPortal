if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[procSearch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[procSearch]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].[procSearch]

	@OrderNumber VARCHAR(100) ='',
	@RecordBand INT =1,
	@Permission INT,
	@ProcID INT,
	@UserType INT

AS

SET NOCOUNT ON

/*

Autohr & Date:

            Chris Kennedy, 13 Feb 2003

Purpose:

            This SP searches for orders according to parameters passed.

Parameters:

            @OrderNumber:   The text to search for
            @SearchType:   
                        1: Order
                        2: Invoice
            @RecordBand:  The band of records to return

ReturnValue
            0:         Success
            -1025:  No records were found in Track and Trace that match your search criteria	

Is RecordSet Retuned:
            If Returnvalue > 0

Nature of RecordSet Returned:
            All the orders that meet the search criteria

*/

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

-- Set ReturnValue = 0
SET @ReturnValue = 0

-- Create the temp table
CREATE TABLE #TmpSearch
(
            AutoID INT IDENTITY(1,1),
            ProcID INT
)

-- Check if this is super administrator that is doing the search
IF @Permission = 2
BEGIN
	IF @UserType = 1
	BEGIN
		INSERT INTO #TmpSearch(ProcID)
			 SELECT TRID FROM TrackTrace WHERE TRcOrderNumber LIKE '%' + @OrderNumber + '%'
	END
END
BEGIN
	IF @UserType = 1
	BEGIN
		INSERT INTO #TmpSearch(ProcID)
			 SELECT TRID FROM TrackTrace WHERE TRcOrderNumber LIKE  '%' + @OrderNumber + '%'  AND TRiBuyerID = @ProcID
	END
	
	
	IF @UserType = 2
	BEGIN
		INSERT INTO #TmpSearch(ProcID)
			SELECT TRID FROM TrackTrace WHERE TRcOrderNumber LIKE  '%' + @OrderNumber + '%'  AND TRiSupplierID = @ProcID	
	END
END


-- Check if any record were found
IF(SELECT COUNT(*) FROM #TmpSearch) = 0
BEGIN
            DROP TABLE #TmpSearch

            SELECT RTcValue AS returnvalue, RTcDescription AS errormessage
            FROM ReturnValue
            WHERE RTcValue = -1002

            RETURN
END

-- Get the default bandsize from the table constants
SET @BandSize = ISNULL((SELECT CSiValue FROM Constants WHERE CScDescription = 'BandSize'),20)

-- Set the RecordFrom
SET @RecordFrom = ((@RecordBand-1)*@Bandsize+1)

-- Get the max records
SET @MaxRecords = (SELECT MAX(AutoID) FROM #TmpSearch)

-- Set the RecordTo
SET @RecordTo = (@RecordFrom+@Bandsize-1)

-- Check if the RecordTo is greater than MaxRecords
IF @RecordTo > @MaxRecords
BEGIN
	SET @RecordTo = @MaxRecords
END

-- Set the recordCount
Set @RecordCount = ((@RecordTo-@RecordFrom+1))

-- Determine if there are previous records
IF @RecordFrom > @BandSize
BEGIN
            Set @ReturnValue = 1
END

-- Determine if the are next records
IF @RecordTo < @MaxRecords
BEGIN
            Set @ReturnValue = 2
END

-- Determine if there are next and previous records
IF (@RecordTo < @MaxRecords) AND (@RecordFrom > @BandSize)
BEGIN
            Set @ReturnValue = 3
END  

-- Return the search results for orders
SELECT @ReturnValue AS returnvalue, @MaxRecords AS MaxRecords, @RecordFrom AS RecordFrom, @RecordTo AS RecordTo, @BandSize AS BandSize, @RecordCount AS RecordCount, 
	TRID AS OrderID, TRcOrderNumber AS OrderNumber, TRdReceivedTime AS ReceiveDate, TRdEDITime AS TransDate,
	TRdMailBoxTime AS MailboxDate, TRdExtractTime AS ExtractDate, TRdFirstConfirmTime AS FirstConfirmDate, TRdSecondConfirmTime AS SecondConfirmDate,
	TRcXMLRef AS XMLRef
FROM #TmpSearch
	INNER JOIN TrackTrace ON TRID = ProcID
WHERE AutoID BETWEEN @RecordFrom AND @RecordTo

RETURN

DROP TABLE #TmpSearch
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

