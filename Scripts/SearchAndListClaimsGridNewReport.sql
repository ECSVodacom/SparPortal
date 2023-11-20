
ALTER PROC [dbo].[SearchAndListClaimsGridNewReport]
	@DCId INT = '-1',
	@SupplierId INT = '-1',
	@VendorCode VARCHAR(50) = '-1',
	@StoreId INT = '-1',
	@ClaimStatusId INT = '-1',
	@ClaimReasonId INT = -1,
	@FromDate VARCHAR(50) = '',
	@ToDate VARCHAR(50) = '',
	@IsHistoryYN VARCHAR(2) = 'N',
	@PageNumber AS INT = 1,
	@PageSize AS INT = 100,
	@ClaimTypeId AS INT = 0,
	@ClaimNumber AS VARCHAR(20) = '',
	@ManualClaimNumber AS VARCHAR(30) = '',
	@ClaimCategoryId AS INT = '-1',
	@CreditNoteNumber AS VARCHAR(30) = '',
	@ClaimsOlderThanInMonths AS INT = 0,
	@UserName AS NVARCHAR(20) = '',
	@ToStatusId AS INT=0,
	@CreateBatch AS BIT=0,
	@AddClaimIds AS NVARCHAR(MAX) = '' ,
	@ClaimSubCategoryId AS INT = 0,
	@ClaimSubReasonId AS INT = 0,
	@StoreFormat AS NVARCHAR(50) = '',
	@IncludeAllDataInd AS BIT = 0,
	@BatchUploadId AS INT = 0 ,
	@OutcomeReasonId AS INT = 0,
	@BuyerId AS INT =0,
	@DoCreditNoteCheck AS BIT = 0
AS

SET NOCOUNT ON ;

IF @DCId = 0 
	SET @DCId = -1

IF @VendorCode IS NULL
	SET @VendorCode = '-1'

IF @FromDate <> '' AND @ToDate <> '' 
BEGIN
	SET @FromDate = SUBSTRING(@FromDate,7,4) + '/' + SUBSTRING(@FromDate,4,2) + '/' + LEFT(@FromDate,2) 
	SET @ToDate  = SUBSTRING(@ToDate,7,4) + '/' + SUBSTRING(@ToDate,4,2) + '/' + LEFT(@ToDate,2) 
END

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
IF @CreateBatch = -1
SET @ClaimStatusId = 0


CREATE TABLE #TmpSearch
(
	AutoID INT IDENTITY(1,1),
    ClaimID INT,
	DCcName varchar(50),
    SupplierName VARCHAR(500),
	STcName varchar(200),
	ClaimStatus varchar(100),
	ClaimReason varchar(100),
	CNcCreditNoteNumber varchar(50),
	CNmTotCostIncl money,
	ClaimStatusId int,
	IsForceCredit bit,
	STcFormatTypeDesc varchar(100),
	ClaimCategory varchar(50),
	DCCategoryName varchar(50),
	ClaimSubCategory varchar(50),
	IsOpenOrClosed bit,
	VendorName varchar(500),
	VendorCode varchar(50),
	OutcomeReasonValue varchar(50),
	Authorised bit,
	UpliftRef varchar(50),
	ClaimSubReason NVARCHAR(50)
)


SET @WhereClause = 
		'	SELECT DISTINCT CLID,DCcName,
				CASE TypeId 
					WHEN 5 THEN SupplierWH.SPcName
					ELSE Supplier.SPcName
				END SPcName,
				Store.STcName,ClaimStatus.Value,ClaimReasons.value,
				CNcCreditNoteNumber,CNmTotCostIncl,ClaimStatus.Id, CreditNote.IsForceCredit,Store.STcFormatTypeDesc,
				ClaimCategory,DCCategoryName,
				ClaimSubCategoryName, 
				IsOpenOrClosed,
				CASE TypeId 
					WHEN 5 THEN ISNULL(SupplierDCLookupWH.VendorName,' + CHAR(39) + CHAR(39) +')
					ELSE ISNULL(SupplierDCLookup.VendorName,' + CHAR(39) + CHAR(39) +')
				END VendorName,
				CASE TypeId 
					WHEN 5 THEN ISNULL(SupplierDCLookupWH.VendorCode,' + CHAR(39) + CHAR(39) +')
					ELSE ISNULL(SupplierDCLookup.VendorCode,' + CHAR(39) + CHAR(39) +')
				END VendorCode,
				ClaimInvestigationOutcomes.Value AS OutcomeReasonValue,
				AuthorisedByRep AS Authorised,
				UpliftRef,
				ClaimSubReasons.[Description]  ClaimSubReason
				
			FROM Claim WITH (NOLOCK)
				INNER JOIN DC WITH (NOLOCK) ON (Claim.CLiDCID = DC.DCID)
				LEFT JOIN CreditNote WITH (NOLOCK) ON (Claim.CLiCNID  = CreditNote.CNID)
				INNER JOIN ClaimStatus WITH (NOLOCK) ON (Claim.StatusId = ClaimStatus.Id )
				LEFT JOIN ClaimsBatchUpdateDetail ON (ClaimsBatchUpdateDetail.ClaimId = Claim.CLID)
				LEFT JOIN ClaimReasons WITH (NOLOCK) ON (Claim.CLiReasonID = ClaimReasons.ClaimReasonId )
				LEFT JOIN ClaimCategories WITH (NOLOCK) ON (Claim.ClaimCategoryId = ClaimCategories.ClaimCategoryId)
				LEFT JOIN ClaimSubReasons WITH (NOLOCK) ON (ClaimSubReasons.ClaimSubReasonId = Claim.CliSubReasonId)
				LEFT JOIN ClaimSubCategory WITH (NOLOCK) ON (Claim.ClaimSubCategoryId = ClaimSubCategory.SubCategoryID)
				LEFT JOIN dbo.WarehouseClaimCategories WITH (NOLOCK) ON (dbo.WarehouseClaimCategories.DCId = dbo.DC.DCID AND Claim.ClaimCategoryId = WarehouseClaimCategories.CategoryId)
				LEFT JOIN Supplier WITH (NOLOCK) ON (Supplier.SPID = Claim.CLiSupplierID)
				LEFT JOIN SupplierDCLookup WITH (NOLOCK) ON (Supplier.SPcEANNumber = 
					CASE WHEN SupplierDCLookup.DespatchPoint = ' + CHAR(39) + CHAR(39) +' THEN SupplierDCLookup.LocationCode ELSE SupplierDCLookup.DespatchPoint END 
				AND BuEanCode = CLcDCEAN )	
				INNER JOIN Store WITH (NOLOCK) ON (Store.STID = Claim.CLiStoreID)
				LEFT JOIN ClaimInvestigationOutcomes on claim.OutcomeReasonCode = ClaimInvestigationOutcomes.ID
				LEFT JOIN Spar.dbo.Supplier SupplierWH WITH (NOLOCK) ON (SupplierWH.SPID = Claim.CLiSupplierID)
				LEFT JOIN Spar.dbo.SupplierDCLookup SupplierDCLookupWH WITH (NOLOCK) 
					ON (Claim.CLcSupplierEan = CASE WHEN SupplierDCLookupWH.DespatchPoint = ' + CHAR(39) + CHAR(39) +' THEN 
				SupplierDCLookupWH.LocationCode ELSE SupplierDCLookupWH.DespatchPoint END 
			AND SupplierDCLookupWH.BuEanCode = CASE TypeId WHEN 5 THEN  WarehouseEan ELSE NULL END  
				AND CLcVendorCode = 
					CASE TypeId WHEN 5 THEN 
						CASE ' + CHAR(39) + @VendorCode  + CHAR(39) + ' 
							WHEN ' + CHAR(39) + '-1' + CHAR(39) + ' THEN SupplierDCLookupWH.VendorCode 
							ELSE ' + CHAR(39) + @VendorCode  + CHAR(39) + ' 
						END
					ELSE SupplierDCLookupWH.VendorCode
					END
				) 
		'
SET @StoreFormat = LTRIM(RTRIM(@StoreFormat))
--IF @StoreFormat <> '' 
--BEGIN 
--	SET @WhereClause = @WhereClause + ' INNER JOIN Store ON (Claim.CLiStoreID = Store.STID)  '
--END 
											
IF ((@DCId <> '-1') OR (@SupplierId <> '-1') OR (@StoreId <> '-1') OR (@ClaimStatusId <> '-1')  OR (@ClaimStatusId <> '-2')  OR (@ClaimStatusId <> '-3') OR (@ClaimReasonId <> '-1')  OR (@FromDate <> '')OR (@ToDate <> ''))
BEGIN	
	SET @WhereClause = @WhereClause + ' WHERE '
END






IF @DCId <> '-1'
BEGIN
	SET @WhereClause = @WhereClause + 'CLiDCID = ' + CONVERT(VARCHAR(50),@DCId)
	SET @DelCount = @DelCount + 1
END

IF @SupplierId <> '-1' AND @ClaimTypeId NOT IN (5)
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'Supplier.SPID = ' + CONVERT(VARCHAR(50),@SupplierID)	
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND Supplier.SPID = ' + CONVERT(VARCHAR(50),@SupplierID)		
			SET @DelCount = @DelCount + 1
		END
END


IF @SupplierId <> '-1' AND @ClaimTypeId IN (5)
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'SupplierWH.SPID = ' + CONVERT(VARCHAR(50),@SupplierID)	
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND SupplierWH.SPID = ' + CONVERT(VARCHAR(50),@SupplierID)		
			SET @DelCount = @DelCount + 1
		END
END





IF @StoreId <> '-1'
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'CLiStoreID = ' + CONVERT(VARCHAR(50),@StoreId)	
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND CLiStoreID = ' + CONVERT(VARCHAR(50),@StoreId)		
			SET @DelCount = @DelCount + 1
		END
END

IF @StoreFormat <> ''
BEGIN
	

	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'LTRIM(RTRIM(ISNULL(Store.STcFormattypeDesc,'+ CHAR(39) + 'Unknown' + CHAR(39) + '))) = ' + CHAR(39) + @StoreFormat + CHAR(39) 
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND LTRIM(RTRIM(ISNULL(Store.STcFormattypeDesc,'+ CHAR(39) + 'Unknown' + CHAR(39) + '))) = ' + CHAR(39) + @StoreFormat + CHAR(39) 
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
			Print 'A'
			Print @ClaimStatusId
			print @delcount
			--SET @WhereClause = @WhereClause + 'StatusId IN (1,3,4,6,7,8,9,14,15,18,19,11,12)'	
			SET @WhereClause = @WhereClause + 'IsOpenOrClosed = 1'	
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
		Print 'b'
		Print @ClaimStatusId
		print @delcount
			--SET @WhereClause = @WhereClause + ' AND StatusId IN (1,3,4,6,7,8,9,14,15,18,19,11,12)'
			SET @WhereClause = @WhereClause + ' AND IsOpenOrClosed = 1'	
			SET @DelCount = @DelCount + 1
		END
	END
	
	--select * from claimstatus
	--	-2,All disputed claims
	IF @ClaimStatusId = '-2'
	BEGIN
		IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'Claim.StatusId IN (8,9)'	
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND Claim.StatusId IN (8,9)'
			SET @DelCount = @DelCount + 1
		END
	END
	
	
	--	-3,All closed claims
	IF @ClaimStatusId IN ('-3','-6','-8')
	BEGIN
		IF @DelCount = 0
		BEGIN
		
		
			--SET @WhereClause = @WhereClause + 'StatusId IN (5,10,13,16)'	
			SET @WhereClause = @WhereClause + 'IsOpenOrClosed = 0'
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			--SET @WhereClause = @WhereClause + ' AND StatusId IN (5,10,13,16)'
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
			SET @WhereClause = @WhereClause + 'Claim.ClaimCategoryId = ' + CONVERT(VARCHAR(50),@ClaimCategoryId)	
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND Claim.ClaimCategoryId = ' + CONVERT(VARCHAR(50),@ClaimCategoryId)		
			SET @DelCount = @DelCount + 1
		END

END

IF (@ClaimStatusId NOT IN ('-8','-1','-2','-3','-4','-5','-6','20','21','-7','0', '-9', '-10', '-11'))
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'Claim.StatusId = ' + CONVERT(VARCHAR(50),@ClaimStatusId)	
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND Claim.StatusId = ' + CONVERT(VARCHAR(50),@ClaimStatusId)		
			SET @DelCount = @DelCount + 1
		END
END


IF @OutcomeReasonId <> 0
BEGIN
	IF @DelCount = 0
		SET @WhereClause = @WhereClause + 'Claim.OutcomeReasonCode=' + CONVERT(VARCHAR(50),@OutcomeReasonId)
	ELSE
		SET @WhereClause = @WhereClause + ' AND Claim.OutcomeReasonCode=' + CONVERT(VARCHAR(50),@OutcomeReasonId)

	SET @DelCount = @DelCount + 1
END

IF (@ClaimStatusId = '21') 
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'ForceCreditInEffect = 1 AND Claim.StatusId NOT IN (26)' 
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND ForceCreditInEffect = 1 AND Claim.StatusId NOT IN (26)'
			SET @DelCount = @DelCount + 1
		END
END

IF (@ClaimStatusId = '-7')
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'AssignedToHistory = ' + CHAR(39) + 'Y'  + CHAR(39) 
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND AssignedToHistory = ' + CHAR(39) + 'Y'  + CHAR(39) 
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
IF @DoCreditNoteCheck = 0
BEGIN
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
END
ELSE
BEGIN
    IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + '((CNcCreditNoteNumber LIKE ' + CHAR(39) + '%' + @CreditNoteNumber + '%' + CHAR(39) 
		SET @WhereClause = @WhereClause + ' AND LEN(CNcCreditNoteNumber) > 0 ) '
		SET @WhereClause = @WhereClause + ' OR (ProFormaCreditNoteNumber LIKE ' + CHAR(39) + '%' + @CreditNoteNumber + '%' + CHAR(39)
		SET @WhereClause = @WhereClause + ' AND LEN(ProFormaCreditNoteNumber) > 0 ))'
		SET @DelCount = @DelCount + 1      
	END      
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + 'AND ((CNcCreditNoteNumber LIKE ' + CHAR(39) + '%' + @CreditNoteNumber + '%' + CHAR(39) 
		SET @WhereClause = @WhereClause + ' AND LEN(CNcCreditNoteNumber) > 0 ) '
		SET @WhereClause = @WhereClause + ' OR (ProFormaCreditNoteNumber LIKE ' + CHAR(39) + '%' + @CreditNoteNumber + '%' + CHAR(39)
		SET @WhereClause = @WhereClause + ' AND LEN(ProFormaCreditNoteNumber) > 0 ))'
		SET @DelCount = @DelCount + 1      
	END      
END

IF @ClaimTypeId = -1
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + 'TypeId IN (1,3) '
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND TypeId IN (1,3) '
			SET @DelCount = @DelCount + 1
		END
END
ELSE
	IF @ClaimTypeId <> 0
	BEGIN
		IF @DelCount = 0
			BEGIN
				SET @WhereClause = @WhereClause + 'TypeId = ' + CONVERT(VARCHAR(50),@ClaimTypeId)
				SET @DelCount = @DelCount + 1
			END
			ELSE
			BEGIN
				SET @WhereClause = @WhereClause + ' AND TypeId = ' + CONVERT(VARCHAR(50),@ClaimTypeId)
				SET @DelCount = @DelCount + 1
			END
	END
	
	
IF @ClaimSubCategoryId <> -1
BEGIN
	IF @DelCount = 0
		SET @WhereClause = @WhereClause + 'Claim.ClaimSubCategoryId=' + CONVERT(VARCHAR(50),@ClaimSubCategoryId)
	ELSE
		SET @WhereClause = @WhereClause + ' AND Claim.ClaimSubCategoryId=' + CONVERT(VARCHAR(50),@ClaimSubCategoryId)

	SET @DelCount = @DelCount + 1
END

IF @ClaimReasonId <> -1
BEGIN
    DECLARE @GroupPricing BIT
	SET @GroupPricing = 0

	IF (SELECT ReasonCode FROM ClaimReasons WHERE ClaimReasonId = @ClaimReasonId) = 'PD'
		SET @GroupPricing = 1

	IF @DelCount = 0
		BEGIN
			IF @GroupPricing = 0
				SET @WhereClause = @WhereClause + 'CLiReasonId = ' + CONVERT(VARCHAR(50),@ClaimReasonId)	
			ELSE
				SET @WhereClause = @WhereClause + 'ReasonCode IN (''DD'',''PD'',''DR'',''RB'',''TD'',''DU'') ' 

			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			IF @GroupPricing = 0
				SET @WhereClause = @WhereClause + ' AND CLiReasonId = '  + CONVERT(VARCHAR(50),@ClaimReasonId)
			ELSE
				SET @WhereClause = @WhereClause + ' AND ReasonCode IN (''DD'',''PD'',''DR'',''RB'',''TD'',''DU'') ' 	
			
			SET @DelCount = @DelCount + 1
		END
END



IF @ClaimSubReasonId <> 0
BEGIN
	IF @DelCount = 0
		SET @WhereClause = @WhereClause + 'Claim.CliSubReasonId = ' + CONVERT(VARCHAR(50),@ClaimSubReasonId)
	ELSE
		SET @WhereClause = @WhereClause + ' AND Claim.CliSubReasonId  = ' + CONVERT(VARCHAR(50),@ClaimSubReasonId)

	SET @DelCount = @DelCount + 1
END

-- Claims > 30 days
IF @ClaimStatusId IN ('-6','-5') AND @FromDate = ''
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + ' CONVERT(VARCHAR(50), CLdReceivedDate,111) < ' + CHAR(39) + CONVERT(VARCHAR(50),DATEADD (DD,-30,GETDATE()),111) + CHAR(39) 
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND CONVERT(VARCHAR(50), CLdReceivedDate,111) < ' + CHAR(39) + CONVERT(VARCHAR(50),DATEADD (DD,-30,GETDATE()),111) + CHAR(39) 
			SET @DelCount = @DelCount + 1
		END
END
-- Claims < 30 days
ELSE IF @ClaimStatusId IN ('-1','-3') AND @FromDate = ''
BEGIN
	IF @DelCount = 0
		BEGIN
			SET @WhereClause = @WhereClause + ' CONVERT(VARCHAR(50), CLdReceivedDate,111) BETWEEN ' +  CHAR(39) +  CONVERT(VARCHAR(50),DATEADD (DD,-30,GETDATE()),111) + CHAR(39)  + ' AND ' + CHAR(39) + CONVERT(VARCHAR(50),GETDATE(),111) + CHAR(39)
			SET @DelCount = @DelCount + 1
		END
		ELSE
		BEGIN
			SET @WhereClause = @WhereClause + ' AND CONVERT(VARCHAR(50), CLdReceivedDate,111) BETWEEN ' +  CHAR(39) +  CONVERT(VARCHAR(50),DATEADD (DD,-30,GETDATE()),111) + CHAR(39)  + ' AND ' + CHAR(39) + CONVERT(VARCHAR(50),GETDATE(),111) + CHAR(39)
			SET @DelCount = @DelCount + 1
		END
END
ELSE
	IF @FromDate <> ''
	BEGIN
		IF @DelCount = 0
			BEGIN
				SET @WhereClause = @WhereClause + 'CONVERT(VARCHAR(50), CLdReceivedDate,111) BETWEEN '  + CHAR(39) + CONVERT(VARCHAR(50),@FromDate)	+ CHAR(39) + ' AND ' +  CHAR(39) +  CONVERT(VARCHAR(50),@ToDate) + CHAR(39) 
				SET @DelCount = @DelCount + 1
			END
			ELSE
			BEGIN
				SET @WhereClause = @WhereClause + ' AND CONVERT(VARCHAR(50), CLdReceivedDate,111) BETWEEN ' + CHAR(39) + CONVERT(VARCHAR(50),@FromDate)	+  CHAR(39) + ' AND ' + CHAR(39) + CONVERT(VARCHAR(50),@ToDate) + CHAR(39) 
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


IF @BuyerId <> 0
BEGIN
    IF @DelCount = 0
	BEGIN
		SET @WhereClause = @WhereClause + ' Buyer_Id=' + CAST(@BuyerId AS varchar(10))
		SET @DelCount = @DelCount + 1
	END
	ELSE
	BEGIN
		SET @WhereClause = @WhereClause + ' AND Buyer_Id=' + CAST(@BuyerId AS varchar(10))
		SET @DelCount = @DelCount + 1
	END
END



DECLARE @MessageToUser NVARCHAR(250)

DECLARE @XML xml = N'<r><![CDATA[' + REPLACE(@AddClaimIds, '|', ']]></r><r><![CDATA[') + ']]></r>'
DECLARE @ClaimIdsTable TABLE(
	ClaimId INT NOT NULL)
INSERT INTO @ClaimIdsTable (ClaimId)
SELECT RTRIM(LTRIM(T.c.value('.', 'NVARCHAR(128)')))
FROM @xml.nodes('//r') T(c)

IF @CreateBatch = 1
BEGIN
	IF @BatchUploadId <> 0
		UPDATE ClaimsBatchUpdateDetail SET IsConfirmed = 1
			WHERE ClaimsBatchUpdate_Id = @BatchUploadId
		AND ClaimId IN (SELECT ClaimId FROM @ClaimIdsTable)
	ELSE
		IF (SELECT COUNT(*) FROM Claim WITH (NOLOCK)
		WHERE CLID IN (SELECT ClaimId FROM @ClaimIdsTable) AND
			((ForceCreditInEffect = 1 AND @ToStatusId <> 13) OR
			(COALESCE(ForceCreditInEffect,0) = 0 AND @ToStatusId <> 26) OR
			(ForceCreditInEffect = 1 AND @ToStatusId <> 12 AND StatusId NOT IN (26))
			) 
		) > 0
		BEGIN
			INSERT INTO ClaimsBatchUpdate (UserName, DateRequested, ToStatusId, BatchStatusId, BatchGuid)
				VALUES (@UserName, GETDATE(), @ToStatusId, 1, NEWID())
			DECLARE @ClaimsBatchUpdate_Id INT = SCOPE_IDENTITY()

			INSERT INTO ClaimsBatchUpdateDetail (ClaimsBatchUpdate_Id, ClaimId, FromStatusId, StatusId)
			SELECT @ClaimsBatchUpdate_Id, ClaimId, StatusId, 1
				FROM Claim WITH (NOLOCK)
			LEFT JOIN @ClaimIdsTable ON (ClaimId = CLID)
			WHERE CLID IN (SELECT ClaimId FROM @ClaimIdsTable) AND
				((ForceCreditInEffect = 1 AND @ToStatusId <> 13) OR
				(COALESCE(ForceCreditInEffect,0) = 0 AND @ToStatusId <> 26) OR
				(ForceCreditInEffect = 1 AND @ToStatusId <> 12 ) 
			) 
		
			SET @MessageToUser = 'New batch ' +  CAST(@ClaimsBatchUpdate_Id AS NVARCHAR) + ' created'
		END
	
	ELSE
		BEGIN
			IF @ToStatusId = 26
				SET @MessageToUser = 
					'No batch created - Status "Permanent Force Credit" could not be applied to claims already force credited';
			ELSE
			IF @ToStatusId = 13
				SET @MessageToUser = 
					'No batch created - Status "Rejected by DC" could not be applied to claims with a force credit in effect';
			ELSE
			IF @ToStatusId = 12
				SET @MessageToUser = 
					'No batch created - Status "DC Force Credit Reversed" could not be applied to claims where Force Credit In Effect is set to "N"';

		END
END;


IF @AddClaimIds <> ''
	SET @WhereClause = @WhereClause + ' AND CLID IN (' + REPLACE(SUBSTRING(@AddClaimIds,2,LEN(@AddClaimIds)-2),'||',',') + ')'

--PRINT @WhereClause
INSERT INTO #TmpSearch(ClaimID,DCcName,
    SupplierName,
	STcName,
	ClaimStatus ,
	ClaimReason ,
	CNcCreditNoteNumber ,
	CNmTotCostIncl ,
	ClaimStatusId ,
	IsForceCredit ,
	STcFormatTypeDesc ,
	ClaimCategory ,
	DCCategoryName,
	ClaimSubCategory ,
	IsOpenOrClosed ,
	VendorName ,
	VendorCode, 
	OutcomeReasonValue,
	Authorised,
	UpliftRef,
	ClaimSubReason
	 )	
	EXEC(@WhereClause)


DECLARE @TotalRecords INT = @@ROWCOUNT

PRINT @IncludeAllDataInd
PRINT @WhereClause
IF @IncludeAllDataInd = 1
BEGIN
	SET @PageNumber = 1
	SET @PageSize = @TotalRecords
	Declare @Row bigint = 1
	

	SELECT distinct @Row as RowNumber, ISNULL( CLdReceivedDate,'')   AS ReceivedDateU, ISNULL( LastUpdated,'') AS LastUpdatedU,
		ClaimID AS CLID, DCcName,  REPLACE(SupplierName,';','') AS SPcName,
		STcName, CLcClaimNumber, 
		CONVERT(nvarchar(15),CLdReceivedDate,106) + ' <br/>[' + CONVERT(nvarchar(15),CLdReceivedDate,108) + ']'  AS CLdReceivedDate,
		ClaimStatus, 
		CONVERT(nvarchar(15),LastUpdated,106) + ' <br/>[' + CONVERT(nvarchar(15),LastUpdated,108) + ']'  AS LastUpdated,
		CLcClaimType,ClaimReason ,  
		CONVERT(nvarchar(15),CLdInvoiceDate,106) AS CLdInvoiceDate,
		tmp.CNcCreditNoteNumber AS CreditNoteNumber, ROUND(tmp.CNmTotCostIncl,2) AS CreditNoteAmount,
		CLiInvoiceID, REPLACE((REPLACE(CLcInvoiceNumber,CHAR(13) + CHAR(10),' ')),',',' ') CLcInvoiceNumber,
		ClaimStatusId , REPLACE(ProFormaCreditNoteNumber, ',',' ')
		ProFormaCreditNoteNumber, ROUND(ProFormaCreditAmount,2) AS ProFormaCreditAmount,
		CLiCNID, tmp.IsForceCredit CreditNoteIsForceCredit,STcFormatTypeDesc,
		CASE WHEN tmp.DCCategoryName IS NULL THEN tmp.ClaimCategory  ELSE tmp.DCCategoryName END AS ClaimCategory,
		ISNULL(ClaimSubCategory,'') AS ClaimSubCategoryName,
		CLcManualClaimNum AS ManualClaimNumber,
		IsOpenOrClosed, COALESCE(ForceCreditInEffect,0) AS ForceCreditInEffect,
		ISNULL(REPLACE(VendorName,',',''),'-') VendorName, ISNULL(VendorCode,'-') VendorCode,  CLmAmount AS ClaimAmount, 
		CLmVat AS  ClaimAmountVat, (CLmAmount - CLmVat) AS  ClaimAmountExclusive, 
		REPLACE(REPLACE(REPLACE(CLcNarratives,CHAR(13),' '),',',' ') ,CHAR(10),' ') Narrative,
		REPLACE(REPLACE(REPLACE(AuditLog_Comments,CHAR(13),' '),',',' ') ,CHAR(10),' ') Comment,
		@TotalRecords AS TotalRecords, @PageSize AS PageSize, @AddClaimIds ClaimIdsAdded, @MessageToUser MessageToUser,
		0 NewClaimStatus,
		OutcomeReasonValue,  ISNULL(Authorised,0) Authorised, tmp.UpliftRef, ClaimSubReason,
		BuyerName, BuyerEmailAddress
	FROM  #TmpSearch tmp inner join Claim clm on clm.CLID = tmp.ClaimID
			LEFT JOIN Buyer WITH (NOLOCK) ON (Buyer.BUID = CASE  @BuyerId WHEN  0 THEN Buyer_Id ELSE @BuyerId END)
			
END
ELSE
BEGIN
	WITH ClaimsRN AS
	(
		SELECT distinct ROW_NUMBER() OVER(ORDER BY CLdReceivedDate DESC, DCcName, SupplierName, STcName, CLcClaimNumber) AS RowNumber, 
			ISNULL( CLdReceivedDate,'')   AS ReceivedDateU, ISNULL( LastUpdated,'') AS LastUpdatedU,
			ClaimID	 AS CLID, DCcName, REPLACE(SupplierName,';','') AS SPcName,
			 STcName, CLcClaimNumber, 
			CONVERT(nvarchar(15),CLdReceivedDate,106) + ' <br/>[' + CONVERT(nvarchar(15),CLdReceivedDate,108) + ']'  AS CLdReceivedDate,
			ClaimStatus, 
			CONVERT(nvarchar(15),LastUpdated,106) + ' <br/>[' + CONVERT(nvarchar(15), LastUpdated,108) + ']'  AS LastUpdated,
			CLcClaimType, ClaimReason,  
			CONVERT(nvarchar(15),CLdInvoiceDate,106) AS CLdInvoiceDate,
			tmp.CNcCreditNoteNumber AS CreditNoteNumber, ROUND(tmp.CNmTotCostIncl,2) AS CreditNoteAmount,
			CLiInvoiceID, CLcInvoiceNumber,
			 ClaimStatusId,
			ProFormaCreditNoteNumber, ROUND(ProFormaCreditAmount,2) AS ProFormaCreditAmount,
			CLiCNID,  tmp.IsForceCredit CreditNoteIsForceCredit, STcFormatTypeDesc,
			 CASE WHEN tmp.DCCategoryName IS NULL THEN tmp.ClaimCategory  ELSE tmp.DCCategoryName END AS ClaimCategory,
			ISNULL(ClaimSubCategory,'') AS ClaimSubCategoryName,
			 CLcManualClaimNum AS ManualClaimNumber,IsOpenOrClosed, COALESCE(ForceCreditInEffect,0) AS ForceCreditInEffect,
			ISNULL(REPLACE(VendorName,',',''),'-') VendorName, ISNULL(VendorCode,'-') VendorCode, CLmAmount AS ClaimAmount, CLmVat AS  ClaimAmountVat, (CLmAmount - CLmVat) AS  ClaimAmountExclusive, 
			REPLACE(REPLACE(REPLACE(CLcNarratives,CHAR(13),' '),',',' ') ,CHAR(10),' ') Narrative,
			REPLACE(REPLACE(REPLACE(AuditLog_Comments,CHAR(13),' '),',',' ') ,CHAR(10),' ') Comment,
				 0 NewClaimStatus,
				OutcomeReasonValue, ISNULL(Authorised,0) Authorised, tmp.UpliftRef, ClaimSubReason,
				BuyerName, BuyerEmailAddress
		FROM  #TmpSearch tmp inner join Claim clm on clm.CLID = tmp.ClaimID
				LEFT JOIN Buyer WITH (NOLOCK) ON (Buyer.BUID = CASE  @BuyerId WHEN  0 THEN Buyer_Id ELSE @BuyerId END)
	)
	SELECT * , @TotalRecords AS TotalRecords, @PageSize AS PageSize, @AddClaimIds ClaimIdsAdded, @MessageToUser MessageToUser
		FROM ClaimsRN
	WHERE (RowNumber BETWEEN (@PageNumber)
		AND (@PageNumber + @PageSize))
	ORDER BY RowNumber

END

