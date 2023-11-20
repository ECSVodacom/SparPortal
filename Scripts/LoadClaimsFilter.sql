ALTER PROCEDURE [dbo].[ListFilterDC]
	--declare
	@UserName VARCHAR(100)
	,@FilterName VARCHAR(100) = ''
AS
--SELECT @UserName = 'SPARHEADOFFICE', @FilterName = 'test12345'
SELECT UserName
	,FilterName
	,ISNULL(dc.DCId, - 1) AS DCID
	,ISNULL(DCcName, '-- Select a DC --') AS DCcName
	,ISNULL(ct.Id, - 1) ClaimTypeId
	,ISNULL(ct.[Value], 'All Claim Types') ClaimType
	,ISNULL(cc.ClaimCategoryId, - 1) ClaimCategoryId
	,ISNULL(cc.ClaimCategory, 'All Categories') ClaimCategory
	,ISNULL(csc.SubCategoryId, - 1) SubCategoryId
	,ISNULL(csc.ClaimSubCategoryName, 'All Sub Categories') ClaimSubCategoryName
	,ISNULL(clr.ClaimReasonId, - 1) ClaimReasonId
	,ISNULL(clr.[Value], 'All Reasons') AS ClaimReasonDescription
	,ISNULL(clsr.ClaimSubReasonId, - 1) ClaimSubReasonId
	,ISNULL(clsr.[Description], 'All Claim Sub-Reasons') [Description]
	,ISNULL(br.BUID, 0) BUID
	,ISNULL(br.BuyerName, 'All Buyers') BuyerName
	,ISNULL(sp.SPID, - 1) AS SupplierId
	,ISNULL(sDC.VendorName, 'All suppliers') AS SupplierName
	,ISNULL(ST.STcFormattypeDesc, 'All Formats') StoreType
	,ISNULL(st.STID, - 1) StoreId
	,ISNULL(st.STcName, 'All Stores') AS StoreName
	,ISNULL(clst.Id, - 1) Id
	,ISNULL(clst.[Value], 'All Open Claims < than 30 days') AS [Value]
	,ISNULL(ClaimNumber, '') ClaimNumber
	,ISNULL(ManualClaimNumber, '') ManualClaimNumber
	,ISNULL(DiscountNoteNumber, '') DiscountNoteNumber
	,FromDate
	,ToDate
FROM ClaimsFilter f
LEFT OUTER JOIN DC dc ON dc.DCID = f.DCId
LEFT OUTER JOIN ClaimTypes ct ON F.ClaimTypeId = ct.Id
LEFT OUTER JOIN ClaimCategories cc ON f.ClaimCategoryId = cc.ClaimCategoryId
LEFT OUTER JOIN ClaimSubCategory csc ON f.ClaimSubCategoryId = csc.SubCategoryID
LEFT OUTER JOIN ClaimReasons clr ON f.ClaimReasonId = clr.ClaimReasonId
LEFT OUTER JOIN ClaimSubReasons clsr ON f.ClaimSubReasonId = clsr.ClaimSubReasonId
LEFT OUTER JOIN Buyer br ON f.BuyerId = br.BUID
LEFT OUTER JOIN Supplier sp ON f.SupplierId = sp.SPID
LEFT OUTER JOIN SupplierDCLookup sdc ON sp.SPcEANNumber = sdc.LocationCode
	AND DC.DCcEANNumber = SDC.BuEanCode
LEFT OUTER JOIN store st ON f.StoreId = st.STID
LEFT OUTER JOIN ClaimStatus clst ON f.ClaimStatusId = clst.Id
WHERE username = @UserName
	AND filtername = @FilterName
