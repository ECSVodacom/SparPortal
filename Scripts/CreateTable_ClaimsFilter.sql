Create Table ClaimsFilter
(
CFID INT identity(1,1),
Username varchar(100),
FilterName varchar(100),
DCId INT,
ClaimTypeId INT,
ClaimCategoryId INT,
ClaimSubCategoryId INT,
ClaimReasonId INT,
ClaimSubReasonId INT,
OutcomeReasonId INT,
BuyerId INT,
SupplierId INT,
StoreFormat varchar(50),
StoreId INT,
ClaimStatusId INT,
ClaimNumber varchar(50),
ManualClaimNumber varchar(50),
DiscountNoteNumber varchar(50),
HasAttachments INT,
FromDate DateTime,
ToDate DateTime
)
GO
