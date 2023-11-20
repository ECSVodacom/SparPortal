USE [SparDS]
GO
/****** Object:  StoredProcedure [dbo].[listClaimFilter]    Script Date: 2023/11/20 13:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[listClaimFilter] 
@UserName VARCHAR(100) 
AS

SELECT 0 CFID, @UserName UserName
	,'Standard' FilterName
	,0 DCID
	,0 ClaimTypeId
	,0 ClaimCategoryId
	,0 ClaimSubCategoryId
	,0 ClaimReasonId
	,0 ClaimSubReasonId
	,0 OutcomeReasonId
	,0 BuyerId
	,0 SupplierId
	,'' StoreFormat
	,0 StoreId
	,0 ClaimStatusId
	,'' ClaimNumber
	,'' ManualClaimNumber
	, '' DiscountNoteNumber
	,'' HasAttachments
	, '' FromDate
	,'' ToDate
	UNION ALL
SELECT [CFID], [UserName]
	,[FilterName]
	,[DCID]
	,[ClaimTypeId]
	,[ClaimCategoryId]
	,[ClaimSubCategoryId]
	,[ClaimReasonId]
	,[ClaimSubReasonId]
	,[OutcomeReasonId]
	,[BuyerId]
	,[SupplierId]
	,[StoreFormat]
	,[StoreId]
	,[ClaimStatusId]
	,[ClaimNumber]
	,[ManualClaimNumber]
	,[DiscountNoteNumber]
	,[HasAttachments]
	,[FromDate]
	,[ToDate]
FROM ClaimsFilter
WHERE Username = @UserName 
