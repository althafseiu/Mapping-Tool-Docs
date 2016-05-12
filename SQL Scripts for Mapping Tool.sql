-- Mapping Tool Tables ,Types,Stored Procedures
-- Use DataBase TestDataBase
-- There are three tables created to host the Mapping Tool Data
--The Table names are ColumnMapping,MemberTypeTranslation and VAN_PreferredColumns
--There are Three Types used in realtion to the Mapping Tool ,the  type names are dbo.CustColType,dbo.MemTypeTranType and dbo.VANPreferredColType
 --There are three Procedures used in the Mapping Tool ie.dbo.PreferredCol,dbo.UpdateColumnMapping,dbo.UpdateMemberType


--Tables
-------------------------------------------------------------------------------------------------------------
--TestDatabase.dbo.ColumnMapping,TestDatabase.dbo.MemberTypeTranslation and TestDatabase.dbo.VAN_PreferredColumns

--Types
----------------------------------------------------------------------
USE [TestDataBase]
GO

/****** Object:  UserDefinedTableType [dbo].[CustColType]    Script Date: 5/12/2016 10:03:14 AM ******/
CREATE TYPE [dbo].[CustColType] AS TABLE(
	[ID] [nvarchar](500) NULL,
	[Localno] [nvarchar](500) NULL,
	[HeaderName] [nvarchar](500) NULL,
	[Columnmapping] [nvarchar](500) NULL
)
GO

USE [TestDataBase]
GO

/****** Object:  UserDefinedTableType [dbo].[MemTypeTranType]    Script Date: 5/12/2016 10:17:18 AM ******/
CREATE TYPE [dbo].[MemTypeTranType] AS TABLE(
	[ID] [nvarchar](500) NULL,
	[Localno] [nvarchar](500) NULL,
	[OrigMemberType] [nvarchar](max) NULL,
	[OrigMemSubType] [nvarchar](max) NULL,
	[MemberTypeVAN] [nvarchar](max) NULL,
	[MemberStatusVAN] [nvarchar](max) NULL
)
GO

USE [TestDataBase]
GO

/****** Object:  UserDefinedTableType [dbo].[VANPreferredColType]    Script Date: 5/12/2016 10:17:33 AM ******/
CREATE TYPE [dbo].[VANPreferredColType] AS TABLE(
	[Localno] [nvarchar](500) NULL,
	[NamePreferred] [nvarchar](500) NULL,
	[AddrPreferred] [nvarchar](500) NULL,
	[PhonePreferred] [nvarchar](500) NULL
)
GO



--Stored Procedures
-------------------------------------------------------------------------------------------------------
USE [TestDataBase]
GO

/****** Object:  StoredProcedure [dbo].[PreferredCol]    Script Date: 5/12/2016 9:55:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Drop Procedure [UpdateMemberType]

CREATE PROCEDURE [dbo].[PreferredCol]
      @tblPrefType VANPreferredColType  READONLY
AS
BEGIN
      SET NOCOUNT ON;
 
      MERGE INTO VAN_PreferredColumns c1
      USING @tblPrefType c2
      ON c1.Localno=c2.Localno 
      WHEN MATCHED THEN
      UPDATE SET --c1.Localno= c2.Localno,
                 c1.NamePreferred = c2.NamePreferred
				,c1.AdddressPreferred = c2.AddrPreferred
				,c1.PhonePreferred = c2.PhonePreferred
				
      WHEN NOT MATCHED THEN
      INSERT (Localno,NamePreferred,AdddressPreferred,PhonePreferred) 
	  VALUES(c2.Localno, c2.NamePreferred, c2.AddrPreferred,c2.PhonePreferred);
      
  
END

GO



--------------------------------------------------------------------------------------------------------------------

USE [TestDataBase]
GO

/****** Object:  StoredProcedure [dbo].[UpdateColumnMapping]    Script Date: 5/12/2016 9:56:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateColumnMapping]
      @tblCustomers CustColType  READONLY
AS
BEGIN
      SET NOCOUNT ON;
 
      MERGE INTO ColumnMapping c1
      USING @tblCustomers c2
      ON c1.Localno=c2.Localno and c1.headername = c2.Headername
      WHEN MATCHED THEN
      UPDATE SET c1.HeaderName = c2.HeaderName
            ,c1.ColumnMapping = c2.Columnmapping,
            c1.Id = c2.Id
      WHEN NOT MATCHED THEN
      INSERT (ID,Localno,HeaderName,Columnmapping) VALUES(c2.ID,c2.Localno, c2.HeaderName, c2.Columnmapping);
      
      

END

GO


-------------------------------------------------------------------------------------------------------------


Create PROCEDURE [dbo].[UpdateMemberType]
      @tblMemType [MemTypeTranType]  READONLY
AS
BEGIN
      SET NOCOUNT ON;
 
      MERGE INTO MembertypeTranslation c1
      USING @tblMemType c2
      ON c1.Localno=c2.Localno and c1.OrigMemberType = c2.[OrigMemberType] and c1.OrigMemberStatus = c2.[OrigMemSubType] --and c1.id= c2.id
      WHEN MATCHED THEN
      UPDATE SET c1.Localno= c2.Localno,
                 c1.OrigMemberType = c2.OrigMemberType
				,c1.[OrigMemberStatus] = c2.[OrigMemSubType]
				,c1.MemberTypeVAN = c2.[MemberTypeVAN]
				,c1.MemberStatusVAN = c2.MemberStatusVAN
            ,c1.Id = c2.Id
      WHEN NOT MATCHED THEN
      INSERT (ID,Localno,OrigMemberType,OrigMemberStatus,MemberTypeVAN,MemberStatusVAN) VALUES(c2.id,c2.Localno, c2.OrigMemberType, c2.[OrigMemSubType],c2.MemberTypeVAN,c2.MemberStatusVAN);
      

END

GO

