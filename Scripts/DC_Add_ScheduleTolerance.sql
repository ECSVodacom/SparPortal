USE SparDS

ALTER TABLE DC ADD AllowAcknowledgedBySupplier BIT

ALTER TABLE DC ADD ScheduleTolerance [numeric](12, 2) NULL
GO