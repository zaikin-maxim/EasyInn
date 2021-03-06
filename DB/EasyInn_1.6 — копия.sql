CREATE SCHEMA [CCSystem]
GO
/****** Object:  UserDefinedTableType [CCSystem].[PermissionsUDT]    Script Date: 26.02.2020 18:29:59 ******/
CREATE TYPE [CCSystem].[PermissionsUDT] AS TABLE(
	[Id] [int] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[CodeName] [varchar](256) NOT NULL,
	[DisplayName] [nvarchar](256) NULL,
	[Description] [nvarchar](500) NULL,
	[ObjectId] [int] NOT NULL,
	[Guid] [uniqueidentifier] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF),
	UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [CCSystem].[SysObjectsUDT]    Script Date: 26.02.2020 18:30:00 ******/
CREATE TYPE [CCSystem].[SysObjectsUDT] AS TABLE(
	[Id] [int] NOT NULL,
	[ParentId] [int] NOT NULL DEFAULT ((0)),
	[ClassId] [tinyint] NOT NULL,
	[CodeName] [varchar](256) NOT NULL,
	[DisplayName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
	[Guid] [uniqueidentifier] NOT NULL,
	[DbObjectId] [int] NULL,
	[DbFieldId] [int] NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF),
	UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [CCSystem].[SysObjectsUpdateUDT]    Script Date: 26.02.2020 18:30:00 ******/
CREATE TYPE [CCSystem].[SysObjectsUpdateUDT] AS TABLE(
	[Id] [int] NOT NULL,
	[ParentId] [int] NOT NULL DEFAULT ((0)),
	[ClassId] [tinyint] NOT NULL,
	[CodeName] [varchar](256) NOT NULL,
	[DisplayName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
	[Guid] [uniqueidentifier] NOT NULL,
	[DbObjectSchemaName] [sysname] NULL,
	[DbObjectName] [sysname] NULL,
	[DbFieldName] [sysname] NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF),
	UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedFunction [CCSystem].[GetSysFieldId]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CCSystem].[GetSysFieldId](@ObjectCodeName sysname, @FieldCodeName sysname)
RETURNS int
    BEGIN 
        DECLARE @FieldId int

        SELECT @FieldId = f.Id 
        FROM CCSystem.SysObjects o 
        INNER JOIN CCSystem.SysObjects f ON o.Id = f.ParentId  
        WHERE o.CodeName = @ObjectCodeName AND f.CodeName = @FieldCodeName 

        RETURN @FieldId
    END
GO
/****** Object:  UserDefinedFunction [CCSystem].[GetSysObjectId]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CCSystem].[GetSysObjectId](@ObjectCodeName sysname)
RETURNS int
    BEGIN 
        DECLARE @ObjectId int

        SELECT @ObjectId = o.Id
        FROM CCSystem.SysObjects o WHERE o.CodeName = @ObjectCodeName AND o.ClassId IN (1, 2)
        RETURN @ObjectId
    END
GO
/****** Object:  UserDefinedFunction [CCSystem].[HasPermission]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CCSystem].[HasPermission](@userId int, @permissionName varchar(256))
RETURNS bit
AS
BEGIN
IF(EXISTS(SELECT su.Id  
          FROM CCSystem.Users su
          INNER JOIN CCSystem.UserRoles sur ON su.Id = sur.UserId
          INNER JOIN CCSystem.RolePermissions srp ON sur.RoleId = srp.RoleId
          INNER JOIN CCSystem.Permissions sp ON srp.PermissionId = sp.Id
          WHERE su.Id = @userId AND (su.FullAccess = 1 OR sp.CodeName = @permissionName)))
  RETURN 1
RETURN 0
END
GO
/****** Object:  Table [CCSystem].[Roles]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsSystem] [bit] NOT NULL,
	[OwnerUserID] [int] NULL,
	[IsOwnByUser] [bit] NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[UserRoles]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[UserRoles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_RoleUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[Permissions]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[Permissions](
	[Id] [int] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[CodeName] [varchar](256) NOT NULL,
	[DisplayName] [nvarchar](256) NULL,
	[Description] [nvarchar](500) NULL,
	[ObjectId] [int] NOT NULL,
	[Guid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[RolePermissions]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[RolePermissions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
 CONSTRAINT [PK_RolePermission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [CCSystem].[UserPermissionsDisplayView]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [CCSystem].[UserPermissionsDisplayView]
AS
SELECT
t.UserId,
t.PermissionId,
t.PermissionName,
STUFF((SELECT ', ' + r.Name  AS [text()]
            FROM CCSystem.UserRoles ur
            INNER JOIN CCSystem.Roles r ON r.Id = ur.RoleId
            INNER JOIN CCSystem.RolePermissions rp ON rp.RoleId = r.Id
            WHERE ur.UserId = t.UserId AND rp.PermissionId = t.PermissionId
            ORDER BY r.IsOwnByUser DESC, r.Name
            For XML PATH ('')
        ), 1, 2, '') [Roles]
FROM
(SELECT DISTINCT
  ur.UserId,
  rp.PermissionId,
  p.DisplayName AS PermissionName
FROM CCSystem.UserRoles ur
INNER JOIN CCSystem.Roles r ON r.Id = ur.RoleId
INNER JOIN CCSystem.RolePermissions rp ON rp.RoleId = r.Id
INNER JOIN CCSystem.Permissions p ON p.Id = rp.PermissionId) t
GO
/****** Object:  Table [CCSystem].[Users]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountName] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[IsDeactivated] [bit] NOT NULL,
	[IsSystemUser] [bit] NOT NULL,
	[EMail] [nvarchar](100) NULL,
	[FullAccess] [bit] NOT NULL,
	[DeactivationDate] [datetime] NULL,
	[Description] [nvarchar](500) NULL,
	[PasswordHash] [varbinary](50) NULL,
	[IsEmailConfirmed] [bit] NOT NULL,
	[EmailToken] [varchar](50) NULL,
	[IsAnonymous] [bit] NOT NULL,
	[CreateDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_CcUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [CCSystem].[UsersDisplayView]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [CCSystem].[UsersDisplayView]
AS
SELECT 
 u.Id, 
 r.Id AS UserRoleId  
FROM CCSystem.Users u
LEFT JOIN CCSystem.Roles r ON u.Id = r.OwnerUserID
GO
/****** Object:  Table [CCSystem].[Files]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[Files](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [nvarchar](256) NOT NULL,
	[Length] [bigint] NOT NULL,
	[CreateDate] [datetimeoffset](7) NOT NULL,
	[StorageName] [varchar](25) NOT NULL,
	[StorageLink] [nvarchar](500) NOT NULL,
	[FieldId] [int] NULL,
	[SysUserId] [int] NULL,
 CONSTRAINT [PK_CCSystem_Files] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[Info]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[Info](
	[SystemVersion] [varchar](20) NOT NULL,
	[DomainVersion] [varchar](20) NOT NULL,
	[LastInitialization] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_SystemInfo] PRIMARY KEY CLUSTERED 
(
	[SystemVersion] ASC,
	[DomainVersion] ASC,
	[LastInitialization] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[ObjectTypes]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[ObjectTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ObjectTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[Operation]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[Operation](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ActionId] [int] NOT NULL,
	[Request] [nvarchar](4000) NULL,
	[RequestContent] [nvarchar](4000) NULL,
	[OperationResultId] [tinyint] NOT NULL,
	[OperationDetails] [nvarchar](4000) NULL,
 CONSTRAINT [PK_CCSystem_Operation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[OperationLocks]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[OperationLocks](
	[OperationName] [nvarchar](200) NOT NULL,
	[OperationContext] [nvarchar](200) NOT NULL,
	[UserId] [int] NOT NULL,
	[MachineName] [nvarchar](200) NULL,
	[ProcessId] [int] NULL,
	[AquiredTime] [datetime] NOT NULL,
	[ExpirationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_OperationLock] PRIMARY KEY CLUSTERED 
(
	[OperationName] ASC,
	[OperationContext] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[OperationResult]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[OperationResult](
	[Id] [tinyint] NOT NULL,
	[Name] [sysname] NOT NULL,
 CONSTRAINT [PK_CCSystem_OperationResult] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[PermissionTypes]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[PermissionTypes](
	[Id] [tinyint] NOT NULL,
	[CodeName] [varchar](256) NOT NULL,
	[DisplayName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
 CONSTRAINT [PK_PermissionTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[RefreshToken]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[RefreshToken](
	[UserId] [int] NOT NULL,
	[ClientId] [varchar](255) NOT NULL,
	[Token] [varchar](255) NOT NULL,
	[ExpiresUtc] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_RefreshToken] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[ResetPasswordToken]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[ResetPasswordToken](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Token] [varchar](50) NOT NULL,
	[ValidFrom] [datetimeoffset](7) NOT NULL,
	[IsExecuted] [bit] NOT NULL,
 CONSTRAINT [PK_ResetPasswordToken] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[SettingProperties]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[SettingProperties](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsManaged] [bit] NOT NULL,
	[Description] [nvarchar](256) NULL,
	[UIEditorType] [nvarchar](256) NULL,
	[GroupName] [nvarchar](256) NULL,
	[IsOverridable] [bit] NOT NULL,
	[DefaultType] [nvarchar](256) NULL,
 CONSTRAINT [PK_SettingProperties] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[Settings]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[Settings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SettingPropertyId] [int] NOT NULL,
	[UserId] [int] NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[SysObjectClasses]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[SysObjectClasses](
	[Id] [tinyint] NOT NULL,
	[CodeName] [varchar](256) NOT NULL,
	[DisplayName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
 CONSTRAINT [PK_SystemObjectClasses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[SysObjects]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CCSystem].[SysObjects](
	[Id] [int] NOT NULL,
	[ParentId] [int] NOT NULL,
	[ClassId] [tinyint] NOT NULL,
	[CodeName] [varchar](256) NOT NULL,
	[DisplayName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
	[Guid] [uniqueidentifier] NOT NULL,
	[DbObjectId] [int] NULL,
	[DbFieldId] [int] NULL,
 CONSTRAINT [PK_SysObjects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Listing]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Listing](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
	[UsingRools] [nvarchar](200) NULL,
	[UserId] [int] NOT NULL,
	[City] [nvarchar](150) NOT NULL,
	[ApartmentName] [nvarchar](150) NOT NULL,
	[ManagerName] [nvarchar](150) NULL,
	[ManagerPhone] [nvarchar](50) NULL,
	[FirefighterPhone] [nvarchar](50) NULL,
	[PolicePhone] [nvarchar](50) NULL,
	[AmbulancePhone] [nvarchar](50) NULL,
	[WifiName] [nvarchar](50) NULL,
	[WifiPassword] [nvarchar](50) NULL,
	[LockerIntercomCode] [nvarchar](50) NOT NULL,
	[LockerAPIKey] [nvarchar](150) NOT NULL,
	[LockerSharedKey] [nvarchar](150) NOT NULL,
	[LockerAuthId] [int] NOT NULL,
	[PMSApartementId] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[UpsellId] [nvarchar](50) NOT NULL,
	[IsLock] [bit] NOT NULL,
 CONSTRAINT [PK_Listing] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListingImage]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListingImage](
	[Id] [int] NOT NULL,
	[FileId] [int] NULL,
	[Comment] [nvarchar](200) NULL,
	[ListingId] [int] NOT NULL,
 CONSTRAINT [PK_ListingImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Partner]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Partner](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](150) NULL,
 CONSTRAINT [PK_OurPartners] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation](
	[Id] [int] NOT NULL,
	[CheckInDate] [datetime] NOT NULL,
	[CheckOutDate] [datetime] NOT NULL,
	[FirstName] [nvarchar](150) NULL,
	[LastName] [nvarchar](150) NULL,
	[Phone] [nvarchar](50) NULL,
	[Email] [nvarchar](150) NULL,
	[ListingId] [int] NOT NULL,
	[PMSReservationid] [nvarchar](150) NOT NULL,
	[GuestId] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Upsell]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Upsell](
	[ServiceType] [nvarchar](50) NOT NULL,
	[Id] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[UpsellStatusId] [int] NOT NULL,
	[ListingId] [int] NOT NULL,
	[PartnerId] [int] NOT NULL,
 CONSTRAINT [PK_Upsells] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UpsellStatus]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UpsellStatus](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserExtension]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserExtension](
	[Id] [int] NOT NULL,
	[GuestyKeyAPI] [nvarchar](150) NULL,
	[GuestySecret] [nvarchar](150) NULL,
	[NukiToken] [nvarchar](150) NULL,
	[UserId] [int] NOT NULL,
	[ContactName] [nvarchar](150) NULL,
	[LogoFileId] [int] NULL,
 CONSTRAINT [PK_UserExtension] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WayThrought]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WayThrought](
	[Id] [int] NOT NULL,
	[ListingId] [int] NOT NULL,
	[FileId] [int] NOT NULL,
	[Comment] [nvarchar](300) NULL,
 CONSTRAINT [PK_WayThrought] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [CCSystem].[Info] ([SystemVersion], [DomainVersion], [LastInitialization]) VALUES (N'1.0.0.17', N'1.0.0.0', CAST(N'2020-01-15T16:51:14.7600000' AS DateTime2))
INSERT [CCSystem].[OperationResult] ([Id], [Name]) VALUES (1, N'Success')
INSERT [CCSystem].[OperationResult] ([Id], [Name]) VALUES (2, N'Failed')
INSERT [CCSystem].[OperationResult] ([Id], [Name]) VALUES (3, N'Unauthorized')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (2, 1, N'SettingManagement', N'SettingManagement', N'Allows editing of global settings or other users settings', 0, N'b8a7424f-fe88-45ec-a08f-51cd06157b09')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (8, 1, N'ReportManagement', N'ReportManagement', N'Allows editing reports', 0, N'01f6db8d-2cd7-4beb-8fe6-269068e531d4')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (16, 2, N'Admin', N'Admin', NULL, 0, N'8234a241-b56c-49f5-bc35-7d71924ed81c')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (32, 2, N'OperationLock', N'Operation lock management', N'Allows to set lock for operation', 0, N'94ecdda3-eaf7-447e-b104-ff00f075073d')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (64, 2, N'Settings', N'Settings', N'Allow read and edit user settings', 0, N'378e1244-bbae-4f51-82f6-f280ccf9bd26')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (128, 4, N'UpsellStatus_Read', N'UpsellStatus.Read', NULL, 32, N'c872d087-eb8d-4d93-9403-1a4ae9ae7e0e')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (257, 3, N'UpsellStatus_Create', N'UpsellStatus.Create', NULL, 32, N'6c326298-38c5-4685-88cb-b012f7b81f36')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (258, 5, N'UpsellStatus_Update', N'UpsellStatus.Update', NULL, 32, N'ea69ebab-6260-4a76-a72b-82a2472da165')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (260, 6, N'UpsellStatus_Delete', N'UpsellStatus.Delete', NULL, 32, N'3da6e326-4eaf-4ac8-8af0-3857730959b9')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (264, 4, N'SysResetPasswordToken_Read', N'Reset password token.Read', NULL, 38, N'd03bfc22-042c-460c-9e04-0d1190f386c9')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (272, 3, N'SysResetPasswordToken_Create', N'Reset password token.Create', NULL, 38, N'b706bc38-1db9-4750-9613-522ea383a813')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (288, 5, N'SysResetPasswordToken_Update', N'Reset password token.Update', NULL, 38, N'bc8d877b-6f74-44c8-af1f-17915ce8677b')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (320, 6, N'SysResetPasswordToken_Delete', N'Reset password token.Delete', NULL, 38, N'8604b61e-553f-4822-9075-d3e557c13ea2')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (384, 4, N'SysRole_Read', N'Role.Read', NULL, 54, N'df812fa1-bfa3-4978-83ac-f4f5ba955384')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (513, 3, N'SysRole_Create', N'Role.Create', NULL, 54, N'01d43b22-95a1-4d98-aec9-2e948df7e615')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (514, 5, N'SysRole_Update', N'Role.Update', NULL, 54, N'e0b06abe-3f37-4422-81d1-1bc95d224ca0')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (516, 6, N'SysRole_Delete', N'Role.Delete', NULL, 54, N'a30a15e5-dfd1-4596-8507-06e07b56ca7e')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (520, 4, N'Upsell_Read', N'Upsell.Read', NULL, 88, N'29403bc2-c427-4386-919c-7ca7b3d7b67d')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (528, 3, N'Upsell_Create', N'Upsell.Create', NULL, 88, N'ce8a7e74-f46b-4570-be8a-2f3efbfafeac')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (544, 5, N'Upsell_Update', N'Upsell.Update', NULL, 88, N'd2d450aa-6794-4911-b850-23e6cdb6a843')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (576, 6, N'Upsell_Delete', N'Upsell.Delete', NULL, 88, N'31e4a59c-3fce-476d-846b-ea7e218cc767')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (640, 4, N'WayThrought_Read', N'Way throught.Read', NULL, 101, N'e901a5b3-efcb-4b0c-9f65-b13e97a34893')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (769, 3, N'WayThrought_Create', N'Way throught.Create', NULL, 101, N'49a74394-07e1-49c6-891f-a752b6933a45')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (770, 5, N'WayThrought_Update', N'Way throught.Update', NULL, 101, N'91b84f2b-6591-481c-9241-f4b33e867503')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (772, 6, N'WayThrought_Delete', N'Way throught.Delete', NULL, 101, N'6144cafe-5209-4f51-8a31-468095cf5161')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (776, 4, N'Listing_Read', N'Listing.Read', NULL, 110, N'0a6c99a9-2110-4e08-9f46-b7dfd58f8463')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (784, 3, N'Listing_Create', N'Listing.Create', NULL, 110, N'119017dc-b490-4320-b7a5-fc50c624e4ef')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (800, 5, N'Listing_Update', N'Listing.Update', NULL, 110, N'0e74bb61-0ca0-4c4a-8c53-e3c943048efb')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (832, 6, N'Listing_Delete', N'Listing.Delete', NULL, 110, N'597fd9f1-844e-4fed-be0a-87c8f1993fb7')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (896, 4, N'UserExtension_Read', N'User extension.Read', NULL, 147, N'7fef6c98-697a-4bf8-9505-48aa1a010ce0')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1025, 3, N'UserExtension_Create', N'User extension.Create', NULL, 147, N'148e3556-1e4d-44cf-a659-ecab90665263')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1026, 5, N'UserExtension_Update', N'User extension.Update', NULL, 147, N'eebf7162-ff1e-4ad6-b4ae-3f6cd8cf440d')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1028, 6, N'UserExtension_Delete', N'User extension.Delete', NULL, 147, N'820fabf8-0cf1-48b9-af28-b158af47f557')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1032, 4, N'Partner_Read', N'Partner.Read', NULL, 183, N'19124d01-8ba7-4033-867e-7f6c4f41e1a8')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1040, 3, N'Partner_Create', N'Partner.Create', NULL, 183, N'0249e5cd-2a96-42b8-9e93-203cac7e12a9')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1056, 5, N'Partner_Update', N'Partner.Update', NULL, 183, N'5f754775-288b-49a6-8227-73941d17dfcd')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1088, 6, N'Partner_Delete', N'Partner.Delete', NULL, 183, N'69fa1fb5-6280-46ae-bfdf-f067b91a206a')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1152, 4, N'ListingImage_Read', N'Listing image.Read', NULL, 218, N'ab22df9f-5693-41c8-a618-0dc3d46fa87d')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1281, 3, N'ListingImage_Create', N'Listing image.Create', NULL, 218, N'ca727c70-8a1d-46cb-aba9-8ddea385fd0b')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1282, 5, N'ListingImage_Update', N'Listing image.Update', NULL, 218, N'f1ca3c94-8ac0-4232-ab15-1501ae97b090')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1284, 6, N'ListingImage_Delete', N'Listing image.Delete', NULL, 218, N'08aa12f5-9d4e-450a-9530-4b6ea268c2ca')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1288, 4, N'Reservation_Read', N'Reservation.Read', NULL, 231, N'a53049bd-4e0a-4a08-99d1-5e7b054d9ac7')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1296, 3, N'Reservation_Create', N'Reservation.Create', NULL, 231, N'6d4f48e4-3554-45ec-a86e-790983550487')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1312, 5, N'Reservation_Update', N'Reservation.Update', NULL, 231, N'0f2218e5-d6ec-4add-b7ed-df1883571237')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1344, 6, N'Reservation_Delete', N'Reservation.Delete', NULL, 231, N'779dbcfd-dc28-4ae6-8a5a-7baf252d0785')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1408, 4, N'ReservationsQuery_Read', N'ReservationsQuery.Read', NULL, 244, N'ee943aa7-4e2f-4a9c-afa7-34c2f0bb36f5')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1537, 4, N'UpsellQuery_Read', N'UpsellQuery.Read', NULL, 254, N'83bc4277-3bf9-4485-9358-26842d44b19f')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1538, 4, N'WayThroughtQuery_Read', N'WayThroughtQuery.Read', NULL, 264, N'7d6caed2-505a-4be7-b6c4-5746bf2e7a87')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1540, 4, N'ListingQuery_Read', N'ListingQuery.Read', NULL, 270, N'db3c2a65-19ad-41bb-ba3c-43bf0cd06002')
INSERT [CCSystem].[Permissions] ([Id], [Type], [CodeName], [DisplayName], [Description], [ObjectId], [Guid]) VALUES (1544, 4, N'ListingImageQuery_Read', N'ListingImageQuery.Read', NULL, 288, N'38ce89de-6933-44f2-8d39-f9e2f3605b36')
INSERT [CCSystem].[PermissionTypes] ([Id], [CodeName], [DisplayName], [Description]) VALUES (1, N'System', N'System', N'System permission')
INSERT [CCSystem].[PermissionTypes] ([Id], [CodeName], [DisplayName], [Description]) VALUES (2, N'Global', N'Global', N'Global permission')
INSERT [CCSystem].[PermissionTypes] ([Id], [CodeName], [DisplayName], [Description]) VALUES (3, N'Create', N'Create', N'Create entity permission')
INSERT [CCSystem].[PermissionTypes] ([Id], [CodeName], [DisplayName], [Description]) VALUES (4, N'Read', N'Read', N'Read entity\field permission')
INSERT [CCSystem].[PermissionTypes] ([Id], [CodeName], [DisplayName], [Description]) VALUES (5, N'Update', N'Update', N'Update entity\field permission')
INSERT [CCSystem].[PermissionTypes] ([Id], [CodeName], [DisplayName], [Description]) VALUES (6, N'Delete', N'Delete', N'Delete entity permission')
INSERT [CCSystem].[PermissionTypes] ([Id], [CodeName], [DisplayName], [Description]) VALUES (7, N'Execute', N'Execute', N'Execute action permission')
INSERT [CCSystem].[RefreshToken] ([UserId], [ClientId], [Token], [ExpiresUtc]) VALUES (1, N'', N'30ec4a37-10c1-4f13-aa7a-75d054b3aca4', CAST(N'2020-02-21T12:04:25.4660878+00:00' AS DateTimeOffset))
INSERT [CCSystem].[RefreshToken] ([UserId], [ClientId], [Token], [ExpiresUtc]) VALUES (1, N'www', N'ccbec100-d5b2-4342-9236-839f5a798653', CAST(N'2020-02-26T11:58:01.8587471+00:00' AS DateTimeOffset))
SET IDENTITY_INSERT [CCSystem].[Roles] ON 

INSERT [CCSystem].[Roles] ([Id], [Name], [Description], [IsSystem], [OwnerUserID], [IsOwnByUser]) VALUES (-2, N'Anonymous', N'This role would be used for non-authenticated users', 1, -1, 1)
INSERT [CCSystem].[Roles] ([Id], [Name], [Description], [IsSystem], [OwnerUserID], [IsOwnByUser]) VALUES (-1, N'Registered', N'This role would be automatically assigned for each newly created user', 1, NULL, 0)
SET IDENTITY_INSERT [CCSystem].[Roles] OFF
SET IDENTITY_INSERT [CCSystem].[SettingProperties] ON 

INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (1, N'IntegratedSecurity', 0, NULL, NULL, NULL, 0, N'System.Boolean')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (2, N'ExplorerBarStyle', 1, N'Select navigation bar style', N'BusinessFramework.Client.Controls.PropertyGridEx.UIEnumEditor, BusinessFramework.Client', N'Appearance', 1, N'BusinessFramework.Client.Explorer.ExplorerBarStyles, BusinessFramework.Client')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (3, N'ExplorerBarConfiguration', 0, NULL, NULL, NULL, 1, NULL)
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (4, N'AutoRefreshPeriodInHours', 1, N'Period of time in hours in witch application refreshes the data.', NULL, N'System', 1, N'System.Int32')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (5, N'NotifyBeforeRefresh', 1, N'Show notification before auto refresh the data.', NULL, N'System', 1, N'System.Boolean')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (6, N'ApplicationStyle', 1, N'Select a visual style of application.', N'BusinessFramework.Client.Controls.PropertyGridEx.UIAppStyleEditor, BusinessFramework.Client', N'Appearance', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (7, N'RequiredFieldColor', 1, N'Please select control color for required field.', NULL, N'Appearance', 1, N'System.Drawing.Color, System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (8, N'RequiredTabColor', 0, N'Please select tab color if required fields are present on the tab.', NULL, N'Appearance', 1, N'System.Drawing.Color, System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (9, N'InvalidTabColor', 0, N'Please select tab color if invalid fields are present.', NULL, N'Appearance', 1, N'System.Drawing.Color, System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (10, N'LastView', 0, NULL, NULL, NULL, 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (11, N'GridSettingsCollection', 0, N'', NULL, N'', 1, NULL)
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (12, N'SmtpHost', 0, N'Contains the name or IP address of the host used for SMTP transactions.', NULL, N'E-mail Notifier', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (13, N'SmtpUserName', 0, NULL, NULL, N'E-mail Notifier', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (14, N'SmtpUserPassword', 0, NULL, NULL, N'E-mail Notifier', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (15, N'SmtpNotificationsEnabled', 0, N'Indicates whether SMTP e-mail notifier is enabled. If SMTP nitifier is disabled then default email client is used to send mail.', NULL, N'E-mail Notifier', 1, N'System.Boolean')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (16, N'CurrencyFormat', 1, N'Please select currency format to represent currency fields.', N'BusinessFramework.Client.Controls.PropertyGridEx.UICurrencyFormatEditor, BusinessFramework.Client', N'System', 0, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (17, N'HierarchicalColumnChooser', 0, N'Show hierarchical column chooser tab in column chooser dialog.', NULL, N'Appearance', 1, N'System.Boolean')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (18, N'MailRecipients', 0, N'Address collection that contains the recipients of e-mail notifications.', NULL, N'E-mail Notifier', 0, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (19, N'SmtpPort', 0, N'Contains the port to be used on host. Zero indicates that port is ignored.', NULL, N'E-mail Notifier', 0, N'System.Int32')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (20, N'SmtpSenderAddress', 0, N'Smtp Sender Address', NULL, N'E-mail Notifier', 0, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (21, N'NotifyBeforeClose', 1, N'Show notification before close application', NULL, N'System', 1, N'System.Boolean')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (22, N'ReportsPath', 1, N'Please select path to reports. Application would automatically cache reports from this folder. If blank installed reports would be used.', N'System.Windows.Forms.Design.FolderNameEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a', N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (23, N'FakeReportData', 0, N'Fake Report Data', NULL, N'Reporting', 1, N'System.Boolean')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (24, N'ReportSystemReadOnly', 1, N'Can change reporting system 2.0 reports', NULL, N'Reporting', 1, N'System.Boolean')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (25, N'ReportSystemDestinationDirectory', 1, N'Application would save reports result to this folder. If blank reports results would be saved to %USER_DOCUMENTS%\Reports folder.', N'System.Windows.Forms.Design.FolderNameEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a', N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (26, N'ReportOutputDirectory', 0, N'Recent report output directory', NULL, N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (27, N'ReportOutputFile', 0, N'Recent report output ????', NULL, N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (28, N'ReportBookOutputDirectory', 0, NULL, NULL, N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (29, N'ReportBookOutputFile', 0, NULL, NULL, N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (30, N'BookSeparatedReportOutputDirectory', 0, NULL, NULL, N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (31, N'BookSeparatedReportOutputFile', 0, NULL, NULL, N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (32, N'WatermarkReport', 0, N'Watermark for reports.', NULL, N'Reporting', 1, N'System.String')
INSERT [CCSystem].[SettingProperties] ([Id], [Name], [IsManaged], [Description], [UIEditorType], [GroupName], [IsOverridable], [DefaultType]) VALUES (33, N'ReportUseCommonFolderForAllModules', 0, N'One common folder for all modules otherwise each module has own sub folder', NULL, N'Reporting', 0, N'System.Boolean')
SET IDENTITY_INSERT [CCSystem].[SettingProperties] OFF
SET IDENTITY_INSERT [CCSystem].[Settings] ON 

INSERT [CCSystem].[Settings] ([Id], [SettingPropertyId], [UserId], [Value]) VALUES (1, 1, NULL, N'False')
INSERT [CCSystem].[Settings] ([Id], [SettingPropertyId], [UserId], [Value]) VALUES (2, 2, NULL, N'DefaultStyle')
INSERT [CCSystem].[Settings] ([Id], [SettingPropertyId], [UserId], [Value]) VALUES (3, 7, NULL, N'LightBlue')
INSERT [CCSystem].[Settings] ([Id], [SettingPropertyId], [UserId], [Value]) VALUES (4, 16, NULL, N'########0.00')
INSERT [CCSystem].[Settings] ([Id], [SettingPropertyId], [UserId], [Value]) VALUES (5, 24, NULL, N'True')
INSERT [CCSystem].[Settings] ([Id], [SettingPropertyId], [UserId], [Value]) VALUES (6, 33, NULL, N'True')
SET IDENTITY_INSERT [CCSystem].[Settings] OFF
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (0, N'None', N'None', N'None type for null object')
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (1, N'Entity', N'Entity', N'Entity')
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (2, N'Query', N'Query', N'Query')
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (3, N'EntityField', N'EntityField', N'EntityField')
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (4, N'QueryField', N'QueryField', N'QueryField')
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (5, N'Action', N'Action', N'Action')
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (6, N'CreateAction', N'CreateAction', N'Create object''s action')
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (7, N'UpdateAction', N'UpdateAction', N'Update object''s action')
INSERT [CCSystem].[SysObjectClasses] ([Id], [CodeName], [DisplayName], [Description]) VALUES (8, N'DeleteAction', N'DeleteAction', N'Delete object''s action')
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (0, 0, 0, N'null', N'null', N'This is a null object for make strong reference to Premissions table, used for mat to system and global permissions', N'00000000-0000-0000-0000-000000000000', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (1, 0, 1, N'SysUserPermissionsDisplayView', N'User permissions display view', NULL, N'0924437e-d751-4380-8bd6-8fca5146409a', 290100074, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (2, 1, 3, N'UserId', N'User id', NULL, N'ac5d70bd-867d-43ec-91a3-8b3c93177484', 290100074, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (3, 1, 3, N'PermissionId', N'Permission id', NULL, N'ca61bc3c-f8f1-45cb-b554-78a8da9eab6c', 290100074, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (4, 1, 3, N'PermissionName', N'Permission name', NULL, N'59a59936-c905-4a74-b022-ab60c8038e74', 290100074, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (5, 1, 3, N'Roles', N'Roles', NULL, N'fddab7e4-ac05-471f-9693-93223c272eff', 290100074, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (6, 0, 1, N'SysOperation', N'Operation', NULL, N'0ddd840a-7a09-4e9a-8693-9c476d5b9a5f', 2133582639, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (7, 6, 3, N'Id', N'Id', NULL, N'b36aa528-38aa-425a-b9f4-5da16eb79478', 2133582639, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (9, 6, 3, N'ActionId', N'Action id', NULL, N'9ffeb315-0ce4-409b-a81c-6d54704ef4d7', 2133582639, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (10, 6, 3, N'Date', N'Date', NULL, N'cf195591-28b0-4ceb-af58-c0886af4f9b8', 2133582639, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (11, 6, 3, N'OperationDetails', N'Operation details', NULL, N'6fffe411-2d4e-4d0e-9fac-41f3dc7fa865', 2133582639, 8)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (13, 6, 3, N'OperationResultId', N'Operation result id', NULL, N'2629d9af-6167-46e0-adc9-5f271ddf88e8', 2133582639, 7)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (14, 6, 3, N'Request', N'Request', NULL, N'847401e7-208d-4db1-a581-479f030d715f', 2133582639, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (15, 6, 3, N'RequestContent', N'Request content', NULL, N'41c39e8f-6472-43c6-9297-f20ce2bceb5a', 2133582639, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (17, 6, 3, N'UserID', N'User id', NULL, N'f3b8ddb4-88d6-4eb8-83d6-ed23ed8ec924', 2133582639, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (18, 0, 1, N'SysObject', N'Sys object', NULL, N'175f60f6-1c0f-43c8-ac4e-0d6e69c0ba7c', 2005582183, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (19, 18, 3, N'Id', N'Id', NULL, N'5fe9a2ff-3c6d-4999-ae77-0b590f09695d', 2005582183, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (20, 18, 3, N'ClassId', N'ClassId', NULL, N'9f248ad4-2d31-4730-8b41-7dad166b4807', 2005582183, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (21, 18, 3, N'CodeName', N'Code name', NULL, N'241b9c6a-e578-4d05-8b38-c9e3ea2e43d3', 2005582183, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (22, 18, 3, N'DbFieldId', N'Db field id', NULL, N'eca93be4-c6c6-40a6-9e2a-4c3370c070b2', 2005582183, 9)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (23, 18, 3, N'DbObjectId', N'Db object id', NULL, N'9e52bb53-a8bb-4b14-8346-6146d0ffd143', 2005582183, 8)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (24, 18, 3, N'Description', N'Description', NULL, N'e26f8e15-d0bf-4850-adff-dccac2d86b23', 2005582183, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (25, 18, 3, N'DisplayName', N'Display name', NULL, N'1b5a2413-59cc-44dc-bd59-ba4d4e1538f9', 2005582183, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (26, 18, 3, N'Guid', N'Guid', NULL, N'672cbc08-b2a7-468c-b729-e41e9f233ecb', 2005582183, 7)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (27, 18, 3, N'ParentId', N'Parent id', NULL, N'9961e52d-7210-4045-aa8c-3554390d97d6', 2005582183, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (29, 0, 1, N'SysOperationResult', N'Operation result', NULL, N'1a1d3f9f-b40e-4c41-a3bf-a8f13df85a21', 2101582525, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (30, 29, 3, N'Id', N'Id', NULL, N'13de68a7-fa97-41ed-a3a9-082d435a6e22', 2101582525, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (31, 29, 3, N'Name', N'Name', NULL, N'0f4ab9f7-5838-4090-97a7-9f27545a2211', 2101582525, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (32, 0, 1, N'UpsellStatus', N'UpsellStatus', NULL, N'1bae70bd-2ab4-4bf3-9850-9ae0c37fb36c', 741577680, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (33, 0, 6, N'Create', N'Add New ''UpsellStatus''', NULL, N'0bc4056d-c040-4465-b7e8-92578155e874', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (34, 0, 7, N'Update', N'Edit ''UpsellStatus''', NULL, N'5e7cc5b3-a64f-41d0-9aba-518d58555a7c', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (35, 0, 8, N'Delete', N'Delete ''UpsellStatus''', NULL, N'4199e67e-7b55-410f-af84-80ee1c91ac33', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (36, 32, 3, N'Id', N'Id', NULL, N'22b494d4-f456-471b-a9c5-2472744f186c', 741577680, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (37, 32, 3, N'Name', N'Name', NULL, N'e70f032b-aa8f-4f77-9a43-cb956e9cb811', 741577680, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (38, 0, 1, N'SysResetPasswordToken', N'Reset password token', NULL, N'30425086-f7ce-4e28-aee2-03648d3ad2f5', 1509580416, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (39, 0, 6, N'Create', N'Add New ''Reset password token''', NULL, N'a2656f18-0d3e-4efc-b1a0-49eea1d0c22c', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (40, 0, 7, N'Update', N'Edit ''Reset password token''', NULL, N'b29000b3-bdc5-44cc-bf75-f38ba165f969', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (41, 0, 8, N'Delete', N'Delete ''Reset password token''', NULL, N'abac9793-97cb-46f9-971b-c9403e06f21a', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (42, 38, 3, N'Id', N'Id', NULL, N'95846b46-06fc-480a-a1de-e3c3bfb649eb', 1509580416, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (43, 38, 3, N'IsExecuted', N'Is executed', NULL, N'36cd54e5-0e62-4b44-91ac-572fe22b1181', 1509580416, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (45, 38, 3, N'Token', N'Token', NULL, N'adcd4570-1140-4e0d-b466-09bc0bbdaaa9', 1509580416, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (46, 38, 3, N'UserId', N'User id', NULL, N'aa1fa4a7-8af2-4dd0-87a5-f9933415ce14', 1509580416, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (47, 38, 3, N'ValidFrom', N'Valid from', NULL, N'8c734cf1-842e-40b9-9f08-3f40f4317940', 1509580416, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (48, 0, 1, N'SysRefreshToken', N'Refresh token', NULL, N'36b8f62a-c99b-4071-81c7-2891be4d8553', 1573580644, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (49, 48, 3, N'UserId', N'User Id', NULL, N'93752ac9-f5b1-4653-b347-a3ec3d57dd1c', 1573580644, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (50, 48, 3, N'ClientId', N'Client Id', NULL, N'171e1042-fdb1-4dd2-b10c-af6ade726a8e', 1573580644, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (51, 48, 3, N'ExpiresUtc', N'Expires Utc', NULL, N'7f5b59b7-61eb-4ef2-9417-ed44730aa03e', 1573580644, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (53, 48, 3, N'Token', N'Token', NULL, N'd72595a0-87f6-4601-bba7-9200f449f772', 1573580644, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (54, 0, 1, N'SysRole', N'Role', NULL, N'40e54b50-8dc2-4528-baa7-c50b066b3087', 1189579276, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (55, 0, 6, N'Create', N'Add New ''Role''', NULL, N'76f477b1-2dc0-49f9-aaea-e320ed795c84', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (56, 0, 7, N'Update', N'Edit ''Role''', NULL, N'970cb330-488f-4ca6-8f41-023c3b7abd6e', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (57, 0, 8, N'Delete', N'Delete ''Role''', NULL, N'21c3ae60-d8de-434a-bc71-d1cfc90efbfa', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (58, 54, 3, N'Id', N'Id', NULL, N'd49b1b51-b985-4c84-ae53-10d251f75dbf', 1189579276, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (59, 54, 3, N'Description', N'Description', NULL, N'2d766b6d-b328-489c-870f-e505a6050f69', 1189579276, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (60, 54, 3, N'IsOwnByUser', N'Is own by user', NULL, N'f2af1a82-bde5-4dc9-babb-9b44731c39b7', 1189579276, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (61, 54, 3, N'IsSystem', N'Is system', NULL, N'5a64dbd1-cbed-4af9-9d3f-a1443a3fcb34', 1189579276, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (62, 54, 3, N'Name', N'Name', NULL, N'f2a31325-c5d7-4f45-8ca1-2f707ea137b2', 1189579276, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (64, 54, 3, N'OwnerUserID', N'Owner user id', NULL, N'01b939f1-708c-494c-9f9c-93c0dbed0d9c', 1189579276, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (66, 0, 1, N'SysUser', N'User', NULL, N'53ab85c8-079a-44aa-944a-ba3b00c0dd6f', 1077578877, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (67, 66, 3, N'Id', N'Id', NULL, N'4b2191c1-6201-4660-b3e9-a975781b6240', 1077578877, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (68, 66, 3, N'AccountName', N'Account name', NULL, N'de4d438f-6384-41fb-a7fd-b0a1b7535a06', 1077578877, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (69, 66, 3, N'CreateDate', N'Create date', NULL, N'cfdfdf7f-d23d-43fb-aa72-45d1487a485c', 1077578877, 14)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (70, 66, 3, N'DeactivationDate', N'Deactivation date', NULL, N'9d35177b-1b3c-4b10-800c-48898ccbec36', 1077578877, 8)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (71, 66, 3, N'Description', N'Description', NULL, N'c031f1f3-a26e-46e6-92d8-ff347d6df412', 1077578877, 9)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (72, 66, 3, N'DisplayName', N'Display name', NULL, N'b9a16597-b51e-4ca8-9f73-dd6351853897', 1077578877, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (73, 66, 3, N'EMail', N'Email', NULL, N'd98ab191-2478-4cb4-b1e4-2e600448ba6c', 1077578877, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (74, 66, 3, N'EmailToken', N'Email token', NULL, N'f8ddc0c9-5faa-4ab4-bdee-9d9633801b7d', 1077578877, 12)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (75, 66, 3, N'FullAccess', N'Full access', NULL, N'0c01b2f6-73d1-46f4-ae40-7bc483e67a4c', 1077578877, 7)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (76, 66, 3, N'IsAnonymous', N'Is anonymous', NULL, N'c0d73926-3d6f-4722-8792-bb93bc168608', 1077578877, 13)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (77, 66, 3, N'IsDeactivated', N'Deactivated', NULL, N'2b19d582-668d-4dfd-a0e5-d37398b30cb2', 1077578877, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (78, 66, 3, N'IsEmailConfirmed', N'Is email confirmed', NULL, N'83c6f7be-48a3-4e1e-a86e-0b5eea5a8248', 1077578877, 11)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (79, 66, 3, N'IsSystemUser', N'System user', NULL, N'9e978974-4738-49cd-b560-13834bb9bc56', 1077578877, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (80, 66, 3, N'PasswordHash', N'Password hash', NULL, N'fabe1d4b-ad6a-4958-9a50-63c6325eae2d', 1077578877, 10)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (82, 0, 1, N'SysRolePermission', N'Role permission', NULL, N'5dbfac8e-3db8-4621-b2e0-1a5cc450270f', 1445580188, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (83, 82, 3, N'Id', N'Id', NULL, N'7e06009f-543d-42ef-a824-c1b3d285c7af', 1445580188, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (84, 82, 3, N'PermissionId', N'Permission id', NULL, N'56a29158-ecc8-45fd-8154-90e06134d352', 1445580188, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (85, 82, 3, N'RoleId', N'Role id', NULL, N'ca2a180c-5cbf-419d-b12d-574a14641b12', 1445580188, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (88, 0, 1, N'Upsell', N'Upsell', NULL, N'6746dfe3-87a7-44ba-af8b-966521e6b88d', 709577566, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (89, 0, 6, N'Create', N'Add New ''Upsell''', NULL, N'83d56e93-1a07-46f7-ab0d-411ef884b060', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (90, 0, 7, N'Update', N'Edit ''Upsell''', NULL, N'f1043a67-a067-4c7d-9498-f8c88934fc4e', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (91, 0, 8, N'Delete', N'Delete ''Upsell''', NULL, N'b797f582-5ef3-44ca-9623-16cd656d6e4d', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (92, 88, 3, N'Id', N'Id', NULL, N'fd8059c7-d7e8-4d23-bf2d-2ba29dcb4289', 709577566, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (94, 88, 3, N'ListingId', N'ListingId', NULL, N'2f67c6af-8b45-41f3-a54e-d61c40b4a47e', 709577566, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (96, 88, 3, N'PartnerId', N'PartnerId', NULL, N'de9b23a7-88b3-476f-b64c-2daaec84a2d9', 709577566, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (97, 88, 3, N'ServiceType', N'ServiceType', NULL, N'c558bf2a-a676-4c63-a44a-e979ae9241e5', 709577566, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (98, 88, 3, N'Title', N'Title', NULL, N'65c05c0b-8ebd-4626-8f60-a4fc61723d2b', 709577566, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (100, 88, 3, N'UpsellStatusId', N'UpsellStatusId', NULL, N'cd02cfd2-217d-4a90-bd83-fd305e0003bd', 709577566, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (101, 0, 1, N'WayThrought', N'Way throught', NULL, N'6d8ce4ee-8fe0-448a-90cd-92fd8611165d', 805577908, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (102, 0, 6, N'Create', N'Add New ''Way throught''', NULL, N'203517f6-0929-44f5-923b-21da1d49e539', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (103, 0, 7, N'Update', N'Edit ''Way throught''', NULL, N'6871806f-7b4b-400c-9dcb-4861369be9d1', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (104, 0, 8, N'Delete', N'Delete ''Way throught''', NULL, N'1af8964d-5e11-4c40-8e85-7ac77476efdd', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (105, 101, 3, N'Id', N'Id', NULL, N'7849a0fc-6155-4fe7-b8eb-d10a652b78d6', 805577908, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (106, 101, 3, N'Comment', N'Comment', NULL, N'92d88603-0ba9-4574-9bcb-5eb6753c02cc', 805577908, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (107, 101, 3, N'FileId', N'File id', NULL, N'15f954aa-220b-4b19-ab6b-e203be7cb67f', 805577908, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (109, 101, 3, N'ListingId', N'Listing id', NULL, N'd7714849-22ab-4804-829f-1f317672f74d', 805577908, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (110, 0, 1, N'Listing', N'Listing', NULL, N'743ed873-f8d8-4e0f-9403-51426418c7c5', 581577110, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (111, 0, 6, N'Create', N'Add New ''Listing''', NULL, N'7975942a-18af-4fd2-9116-60ad9c91d5c9', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (112, 0, 7, N'Update', N'Edit ''Listing''', NULL, N'893bba99-53ab-4242-ba0a-f12f4382cdb5', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (113, 0, 8, N'Delete', N'Delete ''Listing''', NULL, N'9a615d38-a4c1-439f-a417-cae0c6e56184', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (114, 110, 3, N'Id', N'Id', NULL, N'0268a4a4-a36b-4548-81b9-5b41bb206e65', 581577110, 1)
GO
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (115, 110, 3, N'Address', N'Address', NULL, N'e448f968-85bb-4890-9dab-67aac9300604', 581577110, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (116, 110, 3, N'AmbulancePhone', N'AmbulancePhone', NULL, N'c60a6939-5c46-4565-82f6-f1890d7bfebb', 581577110, 11)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (117, 110, 3, N'ApartmentName', N'ApartmentName', NULL, N'58e6b791-68bf-4b8d-b7c4-a8dd33d0d7e6', 581577110, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (118, 110, 3, N'City', N'City', NULL, N'255b10aa-d847-4aef-abf6-6dbf586e4dcc', 581577110, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (119, 110, 3, N'FirefighterPhone', N'FirefighterPhone', NULL, N'11e27f09-d4dd-4211-8df7-90c4e1391ef5', 581577110, 9)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (120, 110, 3, N'IsActive', N'IsActive', NULL, N'd977a51e-f71e-48a4-ae31-bc3d7cdf7f84', 581577110, 19)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (121, 110, 3, N'IsLock', N'IsLock', NULL, N'59372304-0a46-4a26-9413-19ca96a7fc2a', 581577110, 21)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (122, 110, 3, N'LockerAPIKey', N'LockerAPIKey', NULL, N'03a68a57-1963-4668-b928-875a44ded17b', 581577110, 15)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (123, 110, 3, N'LockerAuthId', N'LockerAuthId', NULL, N'fdd16fed-665f-41a6-a1f0-5395577d7caa', 581577110, 17)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (124, 110, 3, N'LockerIntercomCode', N'LockerIntercomCode', NULL, N'd928fbbe-27d3-4a4c-99b8-58ad6c92a225', 581577110, 14)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (125, 110, 3, N'LockerSharedKey', N'LockerSharedKey', NULL, N'acf99889-b748-423a-8604-ae39ca067e04', 581577110, 16)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (126, 110, 3, N'ManagerName', N'ManagerName', NULL, N'9243824e-cdac-4408-9bea-099ee643ac53', 581577110, 7)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (127, 110, 3, N'ManagerPhone', N'ManagerPhone', NULL, N'69d6d1b6-fcd7-4732-af0e-9e9df1842ebe', 581577110, 8)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (128, 110, 3, N'PMSApartementId', N'PMSApartementId', NULL, N'2201cc69-2a10-4b9e-8376-9fa0239c0391', 581577110, 18)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (129, 110, 3, N'PolicePhone', N'PolicePhone', NULL, N'cbd9da60-54d2-4f6f-b0c5-a04e13c29fb0', 581577110, 10)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (130, 110, 3, N'UpsellId', N'UpsellId', NULL, N'd2e72368-7386-469b-a1e9-bccb1d026d79', 581577110, 20)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (131, 110, 3, N'UserId', N'User id', NULL, N'eb50bb00-4b6a-4c16-9e6d-25b781980e59', 581577110, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (132, 110, 3, N'UsingRools', N'Using rools', NULL, N'0841ee28-856e-4890-a375-e9bbef913194', 581577110, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (133, 110, 3, N'WifiName', N'WifiName', NULL, N'fe1b9665-011d-4387-9819-8bdaa1aa2617', 581577110, 12)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (134, 110, 3, N'WifiPassword', N'WifiPassword', NULL, N'43d2714c-8c71-4aaf-a9de-70d3a4e0c79f', 581577110, 13)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (135, 0, 1, N'SysOperationLock', N'Operation lock', NULL, N'824f15da-0934-47d3-9ef4-34fa733d5a46', 1717581157, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (136, 0, 6, N'Create', N'Add New ''Operation lock''', NULL, N'75b398c2-e396-426f-8e20-1af4a4633bec', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (137, 0, 7, N'Update', N'Edit ''Operation lock''', NULL, N'42244e78-8354-4328-9d47-4a943b6be435', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (138, 0, 8, N'Delete', N'Delete ''Operation lock''', NULL, N'2be824fb-60f8-4918-9eaf-d219e0c8b4eb', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (139, 135, 3, N'OperationName', N'Operation name', NULL, N'fcd6aae4-5793-466e-aaeb-7c9ba9917faa', 1717581157, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (140, 135, 3, N'OperationContext', N'Operation context', NULL, N'72e4c2fd-e316-45f9-a2c5-b78492e8d9a0', 1717581157, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (141, 135, 3, N'AquiredTime', N'Aquired time', NULL, N'9004c650-88d7-45bb-8ff4-1242afe8746c', 1717581157, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (142, 135, 3, N'ExpirationTime', N'Expiration time', NULL, N'c12194e6-99a4-49e3-bb74-25ce6317b80b', 1717581157, 7)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (143, 135, 3, N'MachineName', N'Machine name', NULL, N'06bf5992-c63c-4bef-99d7-3b227ca7b5b3', 1717581157, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (144, 135, 3, N'ProcessId', N'Process id', NULL, N'bf09ed42-9d44-4fb0-97e4-6d0b4d2e2a50', 1717581157, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (146, 135, 3, N'UserId', N'User id', NULL, N'17bf4fcf-899b-4543-b66f-a59198ec9ced', 1717581157, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (147, 0, 1, N'UserExtension', N'User extension', NULL, N'85ec6b36-c658-4dcc-8f91-1f8352ae11e6', 773577794, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (148, 0, 6, N'Create', N'Add New ''User extension''', NULL, N'b14a285c-f60a-412a-9aa9-117585d62128', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (149, 0, 7, N'Update', N'Edit ''User extension''', NULL, N'63da51fc-e19a-4825-a191-b72d8c0633d3', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (150, 0, 8, N'Delete', N'Delete ''User extension''', NULL, N'98f5e739-1fea-43c3-93df-ddf0d710cb51', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (151, 147, 3, N'Id', N'Id', NULL, N'7fe98098-b7bc-459c-aa73-39f6c0911362', 773577794, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (152, 147, 3, N'ContactName', N'ContactName', NULL, N'132c4195-1745-4184-ba02-ae393603d36b', 773577794, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (153, 147, 3, N'LogoFileId', N'LogoFileId', NULL, N'321bdf31-99cd-4853-af94-927b25566ef4', 773577794, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (155, 147, 3, N'UserId', N'User id', NULL, N'9400548c-ce63-405d-9e35-b918ca6a69b9', 773577794, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (156, 147, 3, N'UserKeyAPI', N'Key api', NULL, N'fe324549-5cbf-4067-82b8-445643954f6d', 773577794, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (157, 0, 1, N'SysUserRole', N'User role', NULL, N'860a77f5-1fa4-4153-9e57-3487d5f4b0be', 1237579447, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (158, 157, 3, N'Id', N'Id', NULL, N'7b4a205b-7f45-4bc2-b374-cd2f7df052c7', 1237579447, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (159, 157, 3, N'RoleId', N'Role id', NULL, N'a2680cba-9619-408d-8f80-250ce820baf2', 1237579447, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (162, 157, 3, N'UserId', N'User id', NULL, N'7a9e0ee1-456f-43b3-a7c2-739754f8836f', 1237579447, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (163, 0, 1, N'SysPermission', N'Permission', NULL, N'9f69f4ca-933f-4dbf-9cf3-eaf5424f348a', 1349579846, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (164, 163, 3, N'Id', N'Id', NULL, N'c81cf44d-36ae-4d09-9bdb-fc0d03d11f1b', 1349579846, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (165, 163, 3, N'CodeName', N'Code name', NULL, N'b667420e-2fbd-4a36-ba33-cf2d8c5c0873', 1349579846, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (166, 163, 3, N'Description', N'Description', NULL, N'700ed2f8-6cd3-4e53-808f-c62b3a5e61d9', 1349579846, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (167, 163, 3, N'DisplayName', N'Display name', NULL, N'4093ae80-2030-4b68-9812-1b70267be932', 1349579846, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (168, 163, 3, N'Guid', N'Guid', NULL, N'fbf42e61-1f52-4186-9478-e26f351a6460', 1349579846, 8)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (169, 163, 3, N'ObjectId', N'Object id', NULL, N'2d854575-a073-4930-8290-ecadcb55fa72', 1349579846, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (172, 163, 3, N'Type', N'Type', NULL, N'9523adaa-c160-422b-848d-5a63f9424305', 1349579846, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (173, 0, 1, N'SysSetting', N'Setting', NULL, N'a6c36858-a748-4e75-ae68-627ff406f2f1', 1829581556, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (174, 0, 6, N'Create', N'Add New ''Setting''', NULL, N'63eb4214-4afb-4f76-81c7-e83486174c50', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (175, 0, 7, N'Update', N'Edit ''Setting''', NULL, N'611bd93b-3e37-4c17-9f35-b890fa3745ca', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (176, 0, 8, N'Delete', N'Delete ''Setting''', NULL, N'96a0fded-b672-47c2-8575-78a7ccf49d5a', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (177, 173, 3, N'Id', N'Id', NULL, N'cbba6583-3d02-43d8-905d-ce8708f59128', 1829581556, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (178, 173, 3, N'SettingPropertyId', N'Setting property id', NULL, N'09489571-5adb-4437-af73-cf87dcb69ba0', 1829581556, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (179, 173, 3, N'StringValue', N'StringValue', NULL, N'83f83d8f-74c3-4125-acf1-fac6c0ea5001', 1829581556, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (182, 173, 3, N'UserId', N'User id', NULL, N'53a4f842-9b23-4f1f-b109-0e14193b5de4', 1829581556, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (183, 0, 1, N'Partner', N'Partner', NULL, N'aa2710bf-5cbc-4cb6-8480-5b6db88c41fc', 645577338, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (184, 0, 6, N'Create', N'Add New ''Partner''', NULL, N'f0784d31-3ea8-4f76-a01e-a7204118b09f', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (185, 0, 7, N'Update', N'Edit ''Partner''', NULL, N'c1eb5506-3e9f-4d79-9b95-7e4557c4d66f', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (186, 0, 8, N'Delete', N'Delete ''Partner''', NULL, N'c2b93786-8b17-46fa-95e3-86ea77d0a57b', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (187, 183, 3, N'Id', N'Id', NULL, N'd09a408f-2ff6-471d-b2dd-4feb57c6e10f', 645577338, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (188, 183, 3, N'Name', N'Name', NULL, N'2c34daee-a1a0-4f1b-8a4d-3bc32671b945', 645577338, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (189, 0, 1, N'SysInfo', N'Info', NULL, N'adb93649-d217-488a-af1f-9250307075c5', 933578364, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (190, 189, 3, N'SystemVersion', N'System version', NULL, N'16d06663-0759-4d46-bca7-5fb5276d2a56', 933578364, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (191, 189, 3, N'DomainVersion', N'Domain version', NULL, N'a5631dd1-20fa-49d7-b574-b0b427bab081', 933578364, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (192, 189, 3, N'LastInitialization', N'Last initialization', NULL, N'3b34b003-d306-4727-bd81-f9a91da45864', 933578364, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (193, 0, 1, N'SysObjectType', N'Object type', NULL, N'b2eb3f47-58f5-4c50-ac53-c4d8eddbd793', 1621580815, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (194, 193, 3, N'Id', N'Id', NULL, N'dac6eb13-118e-400d-bd4e-f75b4be6bede', 1621580815, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (195, 193, 3, N'Name', N'Name', NULL, N'7dc31c04-c1ca-4978-9722-b5a8689ab11f', 1621580815, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (196, 0, 1, N'SysObjectClass', N'Object class', NULL, N'b38eae60-7995-422a-8359-6d03a160acf1', 965578478, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (197, 196, 3, N'Id', N'Id', NULL, N'01184e11-4a12-4d63-9a38-edbbba6d9820', 965578478, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (198, 196, 3, N'CodeName', N'Code name', NULL, N'1f9de9d6-b369-4ea9-8e6e-08994b754cc0', 965578478, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (199, 196, 3, N'Description', N'Description', NULL, N'74ad16ae-7065-4da1-8fed-37deb01f6ad0', 965578478, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (200, 196, 3, N'DisplayName', N'Display name', NULL, N'31f8cfb6-0f83-439f-8f55-3407ec083107', 965578478, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (201, 0, 1, N'SysPermissionType', N'Permission type', NULL, N'be8f97d9-7ad6-4d18-93c9-641e3d3b6d04', 1317579732, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (202, 201, 3, N'Id', N'Id', NULL, N'0962ce3a-d301-4d61-8a0d-2166c21d2ba2', 1317579732, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (203, 201, 3, N'CodeName', N'Code name', NULL, N'35c9127f-4d38-4d57-8a37-104eece439ca', 1317579732, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (204, 201, 3, N'Description', N'Description', NULL, N'2636c079-a616-4c3f-af8f-81092655cf37', 1317579732, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (205, 201, 3, N'DisplayName', N'Display name', NULL, N'3d38999d-978d-4598-a8a4-c8b99d864395', 1317579732, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (206, 0, 1, N'SysSettingProperty', N'Setting property', NULL, N'c79724f2-41e0-4bd4-937d-39f344952d66', 1765581328, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (207, 0, 6, N'Create', N'Add New ''Setting property''', NULL, N'71abbaa7-b4d4-48d8-a7f7-01638076e567', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (208, 0, 7, N'Update', N'Edit ''Setting property''', NULL, N'a27d9bf4-5287-4e57-adec-35b26a3a0a7a', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (209, 0, 8, N'Delete', N'Delete ''Setting property''', NULL, N'a1ded6c0-6dfe-46ed-8cc0-d9f6877e7813', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (210, 206, 3, N'Id', N'Id', NULL, N'bc641b4f-0183-4b6d-b68c-6909b68b1be9', 1765581328, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (211, 206, 3, N'DefaultType', N'Default type', NULL, N'9fac3e31-9b33-4faf-84b4-29710091be13', 1765581328, 8)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (212, 206, 3, N'Description', N'Description', NULL, N'2cdb893d-1d8e-495d-b0f3-9356e193d272', 1765581328, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (213, 206, 3, N'GroupName', N'Group name', NULL, N'f841d0a7-5313-41c0-9f35-9add067b8c47', 1765581328, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (214, 206, 3, N'IsManaged', N'Is managed', NULL, N'5d65fcf4-67df-4e56-bd57-605ee402b5a2', 1765581328, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (215, 206, 3, N'IsOverridable', N'Is overridable', NULL, N'088865ea-d510-4926-9686-3ce324514b16', 1765581328, 7)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (216, 206, 3, N'Name', N'Name', NULL, N'57897596-fe0a-41c5-8646-63df2ca13f9a', 1765581328, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (217, 206, 3, N'UIEditorType', N'Ui editor type', NULL, N'02a31653-2d3f-4ce0-9329-296628305c78', 1765581328, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (218, 0, 1, N'ListingImage', N'Listing image', NULL, N'c9d7e194-f06a-4815-b7a6-1226eabb92ab', 613577224, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (219, 0, 6, N'Create', N'Add New ''Listing image''', NULL, N'd53327f4-c2b3-4218-978f-fe0478659bff', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (220, 0, 7, N'Update', N'Edit ''Listing image''', NULL, N'ce93deba-aa54-47a2-ac24-28b7b69e688f', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (221, 0, 8, N'Delete', N'Delete ''Listing image''', NULL, N'd339512b-9da1-4556-a611-55398b486715', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (222, 218, 3, N'Id', N'Id', NULL, N'047983d3-55c0-49f4-b2fb-cfab80806fab', 613577224, 1)
GO
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (223, 218, 3, N'Comment', N'Comment', NULL, N'2b6ee6b2-1e9d-4fd8-b162-9d9f88784528', 613577224, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (224, 218, 3, N'FileId', N'FileId', NULL, N'4716ea9d-0cd9-4911-b8ea-e78e11383ef6', 613577224, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (226, 218, 3, N'ListingId', N'Listing id', NULL, N'9bb0b5f8-0a15-433d-906b-8426172ae433', 613577224, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (227, 0, 1, N'SysUsersDisplayView', N'Users display view', NULL, N'dbca27fb-1313-4b47-9004-5eeab96f6189', 306100131, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (228, 227, 3, N'Id', N'Id', NULL, N'54a7262b-f405-4739-868c-d106342bc4b9', 306100131, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (230, 227, 3, N'UserRoleId', N'User role id', NULL, N'a57bfa2c-e243-43a9-b604-5e00435134a1', 306100131, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (231, 0, 1, N'Reservation', N'Reservation', NULL, N'e3b96ad8-1ffb-4930-90ef-21d36062c1c8', 677577452, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (232, 0, 6, N'Create', N'Add New ''Reservation''', NULL, N'9c982bd4-ac92-4de3-8fd5-2e44cfaaab48', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (233, 0, 7, N'Update', N'Edit ''Reservation''', NULL, N'94f552d3-3db7-487f-bd67-c9d4b6407507', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (234, 0, 8, N'Delete', N'Delete ''Reservation''', NULL, N'969d0944-efd9-4318-bf40-1906761aab1d', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (235, 231, 3, N'Id', N'Id', NULL, N'11306223-e747-45b2-9096-9622f3ff94c0', 677577452, 1)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (236, 231, 3, N'CheckInDate', N'Check in date', NULL, N'03148808-3191-465e-8b4b-817da96b29d2', 677577452, 2)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (237, 231, 3, N'CheckOutDate', N'Check out date', NULL, N'fecfc075-7848-49b0-a7b8-70996ecfaa25', 677577452, 3)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (238, 231, 3, N'Email', N'Email', NULL, N'ac654499-2a8f-4b51-ae1b-5fc2aba62254', 677577452, 7)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (239, 231, 3, N'FirstName', N'First name', NULL, N'ce83f7af-b9de-4a62-9520-553620d96036', 677577452, 4)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (240, 231, 3, N'LastName', N'Last name', NULL, N'77b6275e-7a05-4eb8-b1ed-37449aa8265b', 677577452, 5)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (242, 231, 3, N'ListingId', N'Listing id', NULL, N'ec9c6968-37f6-4344-a06d-2d405313106c', 677577452, 8)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (243, 231, 3, N'Phone', N'Phone', NULL, N'b7d0f884-b31a-428b-b24d-0674ba9bad23', 677577452, 6)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (244, 0, 2, N'ReservationsQuery', N'ReservationsQuery', NULL, N'0f43f84e-e32d-4fbd-a768-757d9812a9cd', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (245, 244, 4, N'Id', N'Id', NULL, N'b1c6833a-d772-48d7-aa8d-ad4263a19f54', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (246, 244, 4, N'CheckInDate', N'CheckInDate', NULL, N'a51acfd3-cdb4-4bd4-9fb8-8dd68a8c8609', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (247, 244, 4, N'CheckOutDate', N'CheckOutDate', NULL, N'e50ad158-ccf9-4ee6-b6ec-bd718adc1065', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (248, 244, 4, N'Email', N'Email', NULL, N'649f6554-d9dc-427a-be34-58ccdfc6c45f', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (249, 244, 4, N'FirstName', N'FirstName', NULL, N'91d064a9-aa84-42bf-a097-905b5fe573dd', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (250, 244, 4, N'LastName', N'LastName', NULL, N'93ada37a-6b20-4703-89d6-708ca77384bb', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (251, 244, 4, N'Listing_UserId', N'Listing_UserId', NULL, N'47b2603e-aa07-476d-906b-261fcf228ae8', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (252, 244, 4, N'ListingId', N'ListingId', NULL, N'b4cc284e-4fae-4af8-947c-73b06e7efb94', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (253, 244, 4, N'Phone', N'Phone', NULL, N'3133d607-bd29-4a38-96e3-b79acafd15fc', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (254, 0, 2, N'UpsellQuery', N'UpsellQuery', NULL, N'56583be7-10f2-4a60-b289-e9d00fb477f5', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (255, 254, 4, N'Id', N'Id', NULL, N'd3a7d53f-0d74-4f93-8538-af9376d4dd49', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (256, 254, 4, N'Listing_UserId', N'Listing_UserId', NULL, N'31844e1a-bb6e-4bb7-a325-36d5397c5e96', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (257, 254, 4, N'ListingId', N'ListingId', NULL, N'80ef0e2c-e887-441c-ab79-44c61e9c95a3', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (258, 254, 4, N'Partner_Name', N'Partner_Name', NULL, N'23844a20-8a41-4153-ad18-f5471151faee', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (259, 254, 4, N'PartnerId', N'PartnerId', NULL, N'37e1eebc-c7df-4090-b1bd-26c966d00683', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (260, 254, 4, N'ServiceType', N'ServiceType', NULL, N'd6403c32-1af3-49f1-aaed-07d3cf0ee583', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (261, 254, 4, N'Title', N'Title', NULL, N'0acff03a-77a4-45b0-8079-009aa3b0ff07', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (262, 254, 4, N'UpsellStatus_Name', N'UpsellStatus_Name', NULL, N'988b3349-7d3e-4a30-98c3-2fbb0de406de', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (263, 254, 4, N'UpsellStatusId', N'UpsellStatusId', NULL, N'db7f4363-e98c-42ee-b97a-a23df18d5f02', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (264, 0, 2, N'WayThroughtQuery', N'WayThroughtQuery', NULL, N'c8705f0d-7f3d-4778-b7f4-3cd0b92ff6d2', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (265, 264, 4, N'Id', N'Id', NULL, N'3f84a3cd-1c60-41b1-bc28-631fe19a9461', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (266, 264, 4, N'Comment', N'Comment', NULL, N'77cf46fb-6fc0-4724-bf40-80b1d8d65cc7', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (267, 264, 4, N'FileId', N'FileId', NULL, N'bb28d2ee-de8c-49e6-b1cb-873bda3b541a', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (268, 264, 4, N'Listing_UserId', N'Listing_UserId', NULL, N'753c5150-0c23-42cd-b5d8-5eee14f29fb1', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (269, 264, 4, N'ListingId', N'ListingId', NULL, N'1b6c13ed-72d9-465d-806e-411b62dce461', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (270, 0, 2, N'ListingQuery', N'ListingQuery', NULL, N'efb92b4c-b9bd-4455-b296-fd4fff1e2ec6', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (271, 270, 4, N'Id', N'Id', NULL, N'aa82d7e0-d302-44df-a8b4-f039becbea39', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (272, 270, 4, N'Address', N'Address', NULL, N'130e84e9-51a3-44e4-8953-8c5784219c4a', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (273, 270, 4, N'AmbulancePhone', N'AmbulancePhone', NULL, N'290c021b-03fc-4fea-aa66-9f6d46873d90', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (274, 270, 4, N'ApartmentName', N'ApartmentName', NULL, N'985a1d40-2669-423c-a4ee-227f85db82ef', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (275, 270, 4, N'City', N'City', NULL, N'90cb5d40-4c80-43c8-b7d1-49d120d7c741', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (276, 270, 4, N'FirefighterPhone', N'FirefighterPhone', NULL, N'ee2cdf59-a19f-495f-9996-92162e2024d8', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (277, 270, 4, N'LockerAPIKey', N'LockerAPIKey', NULL, N'cc754d1b-191b-4d08-a586-20ca7428b105', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (278, 270, 4, N'LockerAuthId', N'LockerAuthId', NULL, N'9ef27f23-50df-4860-9442-c8c9b6fbca43', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (279, 270, 4, N'LockerIntercomCode', N'LockerIntercomCode', NULL, N'8d6f9789-2896-4e2f-89b7-38cbe9def278', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (280, 270, 4, N'LockerSharedKey', N'LockerSharedKey', NULL, N'90c0f598-79f1-4dee-b44a-3cb576613550', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (281, 270, 4, N'ManagerName', N'ManagerName', NULL, N'87cecb85-4d21-436d-afa4-63a6fe68b632', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (282, 270, 4, N'ManagerPhone', N'ManagerPhone', NULL, N'088ed819-6ca6-4f94-aa46-193eef74541c', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (283, 270, 4, N'PolicePhone', N'PolicePhone', NULL, N'627123a3-4f1d-4418-b519-3c7ce700d77d', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (284, 270, 4, N'UserId', N'UserId', NULL, N'4f42f282-c734-4a5f-a795-d26e74c08c74', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (285, 270, 4, N'UsingRools', N'UsingRools', NULL, N'31fe266c-bc4b-415c-ba06-57598da705aa', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (286, 270, 4, N'WifiName', N'WifiName', NULL, N'f4c34b06-e67c-4d4c-8c97-96221d80b613', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (287, 270, 4, N'WifiPassword', N'WifiPassword', NULL, N'50770281-6957-439a-a4d0-4d7e70e9f951', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (288, 0, 2, N'ListingImageQuery', N'ListingImageQuery', NULL, N'fb9f3fc4-50b1-4134-871c-eb7d502e0188', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (289, 288, 4, N'Id', N'Id', NULL, N'c5338571-3cf0-4fff-a39e-b74c22af87ad', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (290, 288, 4, N'Comment', N'Comment', NULL, N'388ce966-c3c7-40b8-bce1-c72ccb2b8692', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (291, 288, 4, N'File_id', N'File_id', NULL, N'de202491-824a-4901-8b54-c6e3ce52463c', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (292, 288, 4, N'Listing_UserId', N'Listing_UserId', NULL, N'67475252-9504-42d8-b6df-d49ef8e175bf', NULL, NULL)
INSERT [CCSystem].[SysObjects] ([Id], [ParentId], [ClassId], [CodeName], [DisplayName], [Description], [Guid], [DbObjectId], [DbFieldId]) VALUES (293, 288, 4, N'ListingId', N'ListingId', NULL, N'7c58543e-f07c-48f0-8030-c590216836d4', NULL, NULL)
SET IDENTITY_INSERT [CCSystem].[UserRoles] ON 

INSERT [CCSystem].[UserRoles] ([Id], [UserId], [RoleId]) VALUES (1, -1, -2)
SET IDENTITY_INSERT [CCSystem].[UserRoles] OFF
SET IDENTITY_INSERT [CCSystem].[Users] ON 

INSERT [CCSystem].[Users] ([Id], [AccountName], [DisplayName], [IsDeactivated], [IsSystemUser], [EMail], [FullAccess], [DeactivationDate], [Description], [PasswordHash], [IsEmailConfirmed], [EmailToken], [IsAnonymous], [CreateDate]) VALUES (-1, N'Anonymous', N'Anonymous', 0, 1, NULL, 0, NULL, NULL, NULL, 0, NULL, 1, CAST(N'2020-01-15T16:51:10.4633333' AS DateTime2))
INSERT [CCSystem].[Users] ([Id], [AccountName], [DisplayName], [IsDeactivated], [IsSystemUser], [EMail], [FullAccess], [DeactivationDate], [Description], [PasswordHash], [IsEmailConfirmed], [EmailToken], [IsAnonymous], [CreateDate]) VALUES (1, N'admin', N'Administrator', 0, 0, NULL, 1, NULL, NULL, 0x66C43EFE5ECFA533D3097BD9FF7C1148E7309E5A, 1, NULL, 0, CAST(N'2020-01-15T16:51:14.7566667' AS DateTime2))
SET IDENTITY_INSERT [CCSystem].[Users] OFF
SET IDENTITY_INSERT [dbo].[Listing] ON 

INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (131, N'Prospekt Medikov, 10 корпус 2, Sankt-Peterburg, Russia, 197022', NULL, 1, N'Sankt-Peterburg', N'Apartment Status by Easy Inn', N'Test', NULL, NULL, NULL, NULL, N'gghjgj', NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5c18e28dc176c50027fcdb40', 1, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (141, N'prospekt Medikov, 10 корпус 6 35, Sankt-Peterburg, 197022, Russia', NULL, 1, N'Sankt-Peterburg', N'Apartments El Petro by Easy Inn', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5c954f7a511193002ce59eba', 0, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (142, N'Smolenskaya Ulitsa, 11 1, Sankt-Peterburg, 196084, Russia', NULL, 1, N'Sankt-Peterburg', N'Apartments Frunzee by Easy Inn', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5cbabf428da1ff00485711b1', 0, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (143, N'Malaya Zelenina Ulitsa, 1/22, Sankt-Peterburg, 197110, Russia', NULL, 1, N'Sankt-Peterburg', N'Apartments Luxury Zelenina by Easy Inn', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5cbabf428da1ff0048571188', 0, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (144, N'Prospekt Medikov 10 корпус 2 34, Sankt-Peterburg, 197022, Russia', NULL, 1, N'Sankt-Peterburg', N'Apartments Medikov by Easy Inn', N'Test', NULL, NULL, NULL, NULL, N'ghfhgf', NULL, N'12345678', N'98765', N'dfghoi0987', 1027, N'5c7fc2eb04743b004c6f5411', 1, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (145, N'Griboyedov channel embankment, 2Б 115, Sankt-Peterburg, 191186, Russia', NULL, 1, N'Sankt-Peterburg', N'Apartments Spas by Easy Inn', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5bd99feb9ede1300cebfc18a', 1, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (146, N'Kamennoostrovsky avenue 73, Sankt-Peterburg, 197022, Russia', NULL, 1, N'Sankt-Peterburg', N'Apartments Stone Island by Easy Inn', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5c987a9b9c3d45003857442a', 1, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (147, N'Kremenchugskaya Ulitsa, 9к1 120, Sankt-Peterburg, 191024, Russia', NULL, 1, N'Sankt-Peterburg', N'Apartments Tzar By Easy Inn', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5cc94524aa87110057944e60', 0, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (148, N'Kremenchugskaya Ulitsa, 9к1, Sankt-Peterburg, 191024, Russia', NULL, 1, N'Sankt-Peterburg', N'Apartments Tzar by Easy Inn', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5b98f4ccadc3f60057bd6c46', 1, N'esdfg', 1)
INSERT [dbo].[Listing] ([Id], [Address], [UsingRools], [UserId], [City], [ApartmentName], [ManagerName], [ManagerPhone], [FirefighterPhone], [PolicePhone], [AmbulancePhone], [WifiName], [WifiPassword], [LockerIntercomCode], [LockerAPIKey], [LockerSharedKey], [LockerAuthId], [PMSApartementId], [IsActive], [UpsellId], [IsLock]) VALUES (150, N'Коломенская улица, Санкт-Петербург, Russia', NULL, 1, N'Санкт-Петербург', N'comfortable Kolomenskaia apartment in the center', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, N'12345678', N'98765', N'dfghoi0987', 0, N'5dc1070edacf0b00710fa8d0', 0, N'esdfg', 1)
SET IDENTITY_INSERT [dbo].[Listing] OFF
INSERT [dbo].[UserExtension] ([Id], [GuestyKeyAPI], [GuestySecret], [NukiToken], [UserId], [ContactName], [LogoFileId]) VALUES (1, N'b0c134f42c451881d65b9aae7bb2f4f1', N'07e9b89fa5010c6d5c8e1751e0694b6a', N'4058abe4849164e2cece7614ad785d2c931a3b118c7213d45da21294e4abd4e4ba551f0b4cf2f367', 1, N'Romhjgcfgg', NULL)
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_Permissions_CodeName]    Script Date: 26.02.2020 18:30:00 ******/
ALTER TABLE [CCSystem].[Permissions] ADD  CONSTRAINT [UK_Permissions_CodeName] UNIQUE NONCLUSTERED 
(
	[CodeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UK_Permissions_Guid]    Script Date: 26.02.2020 18:30:00 ******/
ALTER TABLE [CCSystem].[Permissions] ADD  CONSTRAINT [UK_Permissions_Guid] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_Role_Name_IsOwnByUser]    Script Date: 26.02.2020 18:30:00 ******/
ALTER TABLE [CCSystem].[Roles] ADD  CONSTRAINT [UK_Role_Name_IsOwnByUser] UNIQUE NONCLUSTERED 
(
	[Name] ASC,
	[IsOwnByUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_SettingProperties_Group_Name]    Script Date: 26.02.2020 18:30:00 ******/
ALTER TABLE [CCSystem].[SettingProperties] ADD  CONSTRAINT [UK_SettingProperties_Group_Name] UNIQUE NONCLUSTERED 
(
	[GroupName] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UK_Settings_User_Property]    Script Date: 26.02.2020 18:30:00 ******/
ALTER TABLE [CCSystem].[Settings] ADD  CONSTRAINT [UK_Settings_User_Property] UNIQUE NONCLUSTERED 
(
	[UserId] ASC,
	[SettingPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UK_SysObjects_Guid]    Script Date: 26.02.2020 18:30:00 ******/
ALTER TABLE [CCSystem].[SysObjects] ADD  CONSTRAINT [UK_SysObjects_Guid] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ_RoleUser]    Script Date: 26.02.2020 18:30:00 ******/
ALTER TABLE [CCSystem].[UserRoles] ADD  CONSTRAINT [UQ_RoleUser] UNIQUE NONCLUSTERED 
(
	[RoleId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_CcUsers_AccountName]    Script Date: 26.02.2020 18:30:00 ******/
ALTER TABLE [CCSystem].[Users] ADD  CONSTRAINT [UK_CcUsers_AccountName] UNIQUE NONCLUSTERED 
(
	[AccountName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [CCSystem].[Files] ADD  CONSTRAINT [DF_CCSystem_Files_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [CCSystem].[ResetPasswordToken] ADD  CONSTRAINT [DF_ResetPasswordToken_IsExecuted]  DEFAULT ((0)) FOR [IsExecuted]
GO
ALTER TABLE [CCSystem].[Roles] ADD  CONSTRAINT [DF_Roles_IsSystem]  DEFAULT ((0)) FOR [IsSystem]
GO
ALTER TABLE [CCSystem].[Roles] ADD  CONSTRAINT [DF_Roles_IsOwnByUser]  DEFAULT ((0)) FOR [IsOwnByUser]
GO
ALTER TABLE [CCSystem].[SettingProperties] ADD  CONSTRAINT [DF_SettingProperties_IsOverridable]  DEFAULT ((1)) FOR [IsOverridable]
GO
ALTER TABLE [CCSystem].[Users] ADD  CONSTRAINT [DF_CCSystem_Users_IsDeactivated]  DEFAULT ((0)) FOR [IsDeactivated]
GO
ALTER TABLE [CCSystem].[Users] ADD  CONSTRAINT [DF_Users_IsSystemUser]  DEFAULT ((0)) FOR [IsSystemUser]
GO
ALTER TABLE [CCSystem].[Users] ADD  CONSTRAINT [DF_Users_FullAccess]  DEFAULT ((0)) FOR [FullAccess]
GO
ALTER TABLE [CCSystem].[Users] ADD  CONSTRAINT [DF_Users_IsEmailConfirmed]  DEFAULT ((0)) FOR [IsEmailConfirmed]
GO
ALTER TABLE [CCSystem].[Users] ADD  CONSTRAINT [DF_Users_IsAnonymous]  DEFAULT ((0)) FOR [IsAnonymous]
GO
ALTER TABLE [CCSystem].[Users] ADD  CONSTRAINT [DF_CCSystem_Users_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [CCSystem].[Files]  WITH CHECK ADD  CONSTRAINT [FK_CCSystem_Files_Objects] FOREIGN KEY([FieldId])
REFERENCES [CCSystem].[SysObjects] ([Id])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [CCSystem].[Files] CHECK CONSTRAINT [FK_CCSystem_Files_Objects]
GO
ALTER TABLE [CCSystem].[Operation]  WITH CHECK ADD  CONSTRAINT [FK_CCSystem_Operation_OperationResult] FOREIGN KEY([OperationResultId])
REFERENCES [CCSystem].[OperationResult] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[Operation] CHECK CONSTRAINT [FK_CCSystem_Operation_OperationResult]
GO
ALTER TABLE [CCSystem].[Operation]  WITH CHECK ADD  CONSTRAINT [FK_CCSystem_Operation_SysObjects] FOREIGN KEY([ActionId])
REFERENCES [CCSystem].[SysObjects] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[Operation] CHECK CONSTRAINT [FK_CCSystem_Operation_SysObjects]
GO
ALTER TABLE [CCSystem].[Operation]  WITH CHECK ADD  CONSTRAINT [FK_CCSystem_Operation_Users] FOREIGN KEY([UserID])
REFERENCES [CCSystem].[Users] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[Operation] CHECK CONSTRAINT [FK_CCSystem_Operation_Users]
GO
ALTER TABLE [CCSystem].[OperationLocks]  WITH CHECK ADD  CONSTRAINT [FK_OperationLocks_Users] FOREIGN KEY([UserId])
REFERENCES [CCSystem].[Users] ([Id])
GO
ALTER TABLE [CCSystem].[OperationLocks] CHECK CONSTRAINT [FK_OperationLocks_Users]
GO
ALTER TABLE [CCSystem].[Permissions]  WITH CHECK ADD  CONSTRAINT [FK_CCSystem_Permissions_Objects] FOREIGN KEY([ObjectId])
REFERENCES [CCSystem].[SysObjects] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[Permissions] CHECK CONSTRAINT [FK_CCSystem_Permissions_Objects]
GO
ALTER TABLE [CCSystem].[Permissions]  WITH CHECK ADD  CONSTRAINT [FK_Permissions_PermissionsTypes] FOREIGN KEY([Type])
REFERENCES [CCSystem].[PermissionTypes] ([Id])
GO
ALTER TABLE [CCSystem].[Permissions] CHECK CONSTRAINT [FK_Permissions_PermissionsTypes]
GO
ALTER TABLE [CCSystem].[RefreshToken]  WITH CHECK ADD  CONSTRAINT [FK_RefreshToken_Users] FOREIGN KEY([UserId])
REFERENCES [CCSystem].[Users] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[RefreshToken] CHECK CONSTRAINT [FK_RefreshToken_Users]
GO
ALTER TABLE [CCSystem].[ResetPasswordToken]  WITH CHECK ADD  CONSTRAINT [FK_ResetPasswordToken_Users] FOREIGN KEY([UserId])
REFERENCES [CCSystem].[Users] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[ResetPasswordToken] CHECK CONSTRAINT [FK_ResetPasswordToken_Users]
GO
ALTER TABLE [CCSystem].[RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_RolePermission_Permissions] FOREIGN KEY([PermissionId])
REFERENCES [CCSystem].[Permissions] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[RolePermissions] CHECK CONSTRAINT [FK_RolePermission_Permissions]
GO
ALTER TABLE [CCSystem].[RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_RolePermission_Roles] FOREIGN KEY([RoleId])
REFERENCES [CCSystem].[Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[RolePermissions] CHECK CONSTRAINT [FK_RolePermission_Roles]
GO
ALTER TABLE [CCSystem].[Roles]  WITH CHECK ADD  CONSTRAINT [FK_Roles_Users_Owner] FOREIGN KEY([OwnerUserID])
REFERENCES [CCSystem].[Users] ([Id])
GO
ALTER TABLE [CCSystem].[Roles] CHECK CONSTRAINT [FK_Roles_Users_Owner]
GO
ALTER TABLE [CCSystem].[Settings]  WITH CHECK ADD  CONSTRAINT [FK_Settings_SettingProperties] FOREIGN KEY([SettingPropertyId])
REFERENCES [CCSystem].[SettingProperties] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[Settings] CHECK CONSTRAINT [FK_Settings_SettingProperties]
GO
ALTER TABLE [CCSystem].[Settings]  WITH CHECK ADD  CONSTRAINT [FK_Settings_Users] FOREIGN KEY([UserId])
REFERENCES [CCSystem].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[Settings] CHECK CONSTRAINT [FK_Settings_Users]
GO
ALTER TABLE [CCSystem].[SysObjects]  WITH CHECK ADD  CONSTRAINT [FK_SysObjects_SysObjectClasses] FOREIGN KEY([ClassId])
REFERENCES [CCSystem].[SysObjectClasses] ([Id])
GO
ALTER TABLE [CCSystem].[SysObjects] CHECK CONSTRAINT [FK_SysObjects_SysObjectClasses]
GO
ALTER TABLE [CCSystem].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_RoleUser_Roles] FOREIGN KEY([RoleId])
REFERENCES [CCSystem].[Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[UserRoles] CHECK CONSTRAINT [FK_RoleUser_Roles]
GO
ALTER TABLE [CCSystem].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_RoleUser_Users] FOREIGN KEY([UserId])
REFERENCES [CCSystem].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [CCSystem].[UserRoles] CHECK CONSTRAINT [FK_RoleUser_Users]
GO
ALTER TABLE [dbo].[ListingImage]  WITH CHECK ADD  CONSTRAINT [FK_ListingImage_Listing] FOREIGN KEY([ListingId])
REFERENCES [dbo].[Listing] ([Id])
GO
ALTER TABLE [dbo].[ListingImage] CHECK CONSTRAINT [FK_ListingImage_Listing]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Listing] FOREIGN KEY([ListingId])
REFERENCES [dbo].[Listing] ([Id])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_Listing]
GO
ALTER TABLE [dbo].[Upsell]  WITH CHECK ADD  CONSTRAINT [FK_Upsell_Partner] FOREIGN KEY([PartnerId])
REFERENCES [dbo].[Partner] ([Id])
GO
ALTER TABLE [dbo].[Upsell] CHECK CONSTRAINT [FK_Upsell_Partner]
GO
ALTER TABLE [dbo].[Upsell]  WITH CHECK ADD  CONSTRAINT [FK_Upsells_Listing] FOREIGN KEY([ListingId])
REFERENCES [dbo].[Listing] ([Id])
GO
ALTER TABLE [dbo].[Upsell] CHECK CONSTRAINT [FK_Upsells_Listing]
GO
ALTER TABLE [dbo].[Upsell]  WITH CHECK ADD  CONSTRAINT [FK_Upsells_Status] FOREIGN KEY([UpsellStatusId])
REFERENCES [dbo].[UpsellStatus] ([Id])
GO
ALTER TABLE [dbo].[Upsell] CHECK CONSTRAINT [FK_Upsells_Status]
GO
ALTER TABLE [dbo].[UserExtension]  WITH CHECK ADD  CONSTRAINT [FK_UserExtension_Users] FOREIGN KEY([UserId])
REFERENCES [CCSystem].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserExtension] CHECK CONSTRAINT [FK_UserExtension_Users]
GO
ALTER TABLE [dbo].[WayThrought]  WITH CHECK ADD  CONSTRAINT [FK_WayThrought_Listing] FOREIGN KEY([ListingId])
REFERENCES [dbo].[Listing] ([Id])
GO
ALTER TABLE [dbo].[WayThrought] CHECK CONSTRAINT [FK_WayThrought_Listing]
GO
/****** Object:  StoredProcedure [CCSystem].[AddUserToRole]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[AddUserToRole](@RoleName sysname, @AccountName sysname)
AS
BEGIN

DECLARE @UserId int, @RoleId int, @Checked bit
SET @Checked = 1
SELECT @UserId = Id FROM CCSystem.Users WHERE AccountName = @AccountName
SELECT @RoleId = Id FROM CCSystem.Roles WHERE Name = @RoleName

IF  (@UserId IS NULL)
BEGIN
  PRINT 'Can''t find user '''+@AccountName+''''
  SET @Checked = 0
END

IF  (@RoleId IS NULL)
BEGIN
  PRINT 'Can''t find role '''+@RoleName+''''
  SET @Checked = 0
END

IF (@Checked = 1)
  IF (EXISTS(SELECT * FROM CCSystem.UserRoles WHERE UserId = @UserId AND RoleId = @RoleId))
    PRINT 'Already added: User '''+@AccountName+''' to role '''+@RoleName+''''
  ELSE
   BEGIN
     INSERT INTO CCSystem.UserRoles (RoleId, UserId) VALUES(@RoleId, @UserId)
     PRINT 'Added: user '''+@AccountName+''' to role '''+@RoleName+''''
   END
ELSE
  PRINT 'Failed: Add user '''+@AccountName+''' to role '''+@RoleName+''''
END
GO
/****** Object:  StoredProcedure [CCSystem].[CreateGenericCursor]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Based on http://www.codeproject.com/Articles/489617/CreateplusaplusCursorplususingplusDynamicplusSQLpl
CREATE PROCEDURE [CCSystem].[CreateGenericCursor](@vQuery nvarchar(MAX),@Cursor cursor varying OUTPUT)
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE 
        @vSQL AS nvarchar(max)
    
    SET @vSQL = 'SET @Cursor = CURSOR FORWARD_ONLY STATIC FOR ' + @vQuery + ' OPEN @Cursor;'
    
   
    EXEC sp_executesql
         @vSQL
         ,N'@Cursor cursor output'  
         ,@Cursor OUTPUT;
END 
GO
/****** Object:  StoredProcedure [CCSystem].[GetSyncSecurity]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[GetSyncSecurity] (
   @source_db                    VARCHAR (1000),
   @target_db                    VARCHAR (1000),
   @include_update_roles         BIT= 1,
   @include_update_users         BIT= 1,
   @include_permissions_revoke   BIT= 1,
   @include_permissions_grant    BIT= 1,
   @filePath                     VARCHAR (500)= NULL)
AS
BEGIN
   DECLARE
      @query          NVARCHAR (MAX),
      @part           NVARCHAR (MAX),
      @delete_roles   NVARCHAR (MAX),
      @delete_users   NVARCHAR (MAX)

   SET @query = ''

   EXEC
      CCSystem.SyncRoles @source_db,
      @target_db,
      @include_update_roles,
      @part OUTPUT,
      @delete_roles OUTPUT

   IF (LEN (@part) > 0)
      SET @query =
               @query
             + ISNULL
               (
                    '-------Sync roles-------'
                  + CHAR (13)
                  + CHAR (10)
                  + @part
                  + CHAR (13)
                  + CHAR (10)
                  + CHAR (13)
                  + CHAR (10),
                  '')

   EXEC
      CCSystem.SyncUsers @source_db,
      @target_db,
      @include_update_users,
      @part OUTPUT,
      @delete_users OUTPUT

   IF (LEN (@part) > 0)
      SET @query =
               @query
             + ISNULL
               (
                    '-------Sync users-------'
                  + CHAR (13)
                  + CHAR (10)
                  + @part
                  + CHAR (13)
                  + CHAR (10)
                  + CHAR (13)
                  + CHAR (10),
                  '')

   EXEC CCSystem.SyncUserRoles @source_db, @target_db, @part OUTPUT

   IF (LEN (@part) > 0)
      SET @query =
               @query
             + ISNULL
               (
                    '-------Sync user-role mapping-------'
                  + CHAR (13)
                  + CHAR (10)
                  + @part
                  + CHAR (13)
                  + CHAR (10)
                  + CHAR (13)
                  + CHAR (10),
                  '')

   EXEC
      CCSystem.SyncRolePermissions @source_db,
      @target_db,
      @include_permissions_revoke,
      @include_permissions_grant,
      @part OUTPUT

   IF (LEN (@part) > 0)
      SET @query =
               @query
             + ISNULL
               (
                    '-------Sync role-permission mapping-------'
                  + CHAR (13)
                  + CHAR (10)
                  + @part
                  + CHAR (13)
                  + CHAR (10)
                  + CHAR (13)
                  + CHAR (10),
                  '')

   IF (LEN (@delete_roles) > 0)
      SET @query =
               @query
             + ISNULL
               (
                    '-------Delete roles-------'
                  + CHAR (13)
                  + CHAR (10)
                  + @delete_roles
                  + CHAR (13)
                  + CHAR (10)
                  + CHAR (13)
                  + CHAR (10),
                  '')

   IF (LEN (@delete_users) > 0)
      SET @query =
               @query
             + ISNULL
               (
                    '-------Delete users-------'
                  + CHAR (13)
                  + CHAR (10)
                  + @delete_users
                  + CHAR (13)
                  + CHAR (10)
                  + CHAR (13)
                  + CHAR (10),
                  '')

   IF (LEN (@query) > 0)
      SET @query =
               '-- Sync security from '
             + @source_db
             + ' to '
             + @target_db
             + CHAR (13)
             + CHAR (10)
             + 'SET NOCOUNT ON;'
             + CHAR (13)
             + CHAR (10)
             + @query
   ELSE
      SET @query =
               '-- Security between '
             + @source_db
             + ' and '
             + @target_db
             + ' is equal'


   SELECT @query

   IF (NOT @filePath IS NULL)
      EXEC CCSystem.WriteStringToFile @filePath, @query
END
GO
/****** Object:  StoredProcedure [CCSystem].[GrantPermission]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[GrantPermission] (@RoleName         sysname,
                                           @PermissionName   sysname,
                                           @SkipInfoMsg      BIT= 1)
AS
BEGIN
   DECLARE
      @PermissionId   INT,
      @RoleId         INT,
      @Checked        BIT
   SET @Checked = 1
   SELECT @PermissionId = Id
   FROM CCSystem.Permissions
   WHERE CodeName = @PermissionName
   SELECT @RoleId = Id
   FROM CCSystem.Roles
   WHERE Name = @RoleName

   IF (@PermissionId IS NULL)
      BEGIN
         PRINT 'Can''t find permission ''' + @PermissionName + ''''
         SET @Checked = 0
      END

   IF (@RoleId IS NULL)
      BEGIN
         PRINT 'Can''t find role ''' + @RoleName + ''''
         SET @Checked = 0
      END

   IF (@Checked = 1)
      IF (EXISTS
             (SELECT *
              FROM CCSystem.RolePermissions
              WHERE PermissionId = @PermissionId AND RoleId = @RoleId))
         PRINT   'Already granted: Permission '''
               + @PermissionName
               + ''' to role '''
               + @RoleName
               + ''''
      ELSE
         BEGIN
            INSERT INTO CCSystem.RolePermissions (RoleId, PermissionId)
            VALUES (@RoleId, @PermissionId)

            IF (@SkipInfoMsg = 0)
               PRINT   'Granted: Permission '''
                     + @PermissionName
                     + ''' to role '''
                     + @RoleName
                     + ''''
         END
   ELSE
      PRINT   'Failed: Grant permission '''
            + @PermissionName
            + ''' to role '''
            + @RoleName
            + ''''
END
GO
/****** Object:  StoredProcedure [CCSystem].[RemoveUserFromRole]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[RemoveUserFromRole] (@RoleName      sysname,
                                              @AccountName   sysname)
AS
BEGIN
   DECLARE
      @UserId    INT,
      @RoleId    INT,
      @Checked   BIT
   SET @Checked = 1
   SELECT @UserId = Id
   FROM CCSystem.Users
   WHERE AccountName = @AccountName
   SELECT @RoleId = Id
   FROM CCSystem.Roles
   WHERE Name = @RoleName

   IF (@UserId IS NULL)
      BEGIN
         PRINT 'Can''t find user ''' + @AccountName + ''''
         SET @Checked = 0
      END

   IF (@RoleId IS NULL)
      BEGIN
         PRINT 'Can''t find role ''' + @RoleName + ''''
         SET @Checked = 0
      END

   IF (@Checked = 1)
      IF (NOT EXISTS
             (SELECT *
              FROM CCSystem.UserRoles
              WHERE UserId = @UserId AND RoleId = @RoleId))
         PRINT   'Already removed: User '''
               + @AccountName
               + ''' to role '''
               + @RoleName
               + ''''
      ELSE
         BEGIN
            DELETE FROM CCSystem.UserRoles
            WHERE RoleId = @RoleId AND UserId = @UserId

            PRINT   'Removed: User '''
                  + @AccountName
                  + ''' from role '''
                  + @RoleName
                  + ''''
         END
   ELSE
      PRINT   'Failed: Remove user '''
            + @AccountName
            + ''' from role '''
            + @RoleName
            + ''''
END
GO
/****** Object:  StoredProcedure [CCSystem].[RevokePermission]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[RevokePermission](@RoleName sysname, @PermissionName sysname)
AS
BEGIN

DECLARE @PermissionId int, @RoleId int, @Checked bit
SET @Checked = 1
SELECT @PermissionId = Id FROM CCSystem.Permissions WHERE CodeName = @PermissionName
SELECT @RoleId = Id FROM CCSystem.Roles WHERE Name = @RoleName

IF  (@PermissionId IS NULL)
BEGIN
  PRINT 'Can''t find permission '''+@PermissionName+''''
  SET @Checked = 0
END

IF  (@RoleId IS NULL)
BEGIN
  PRINT 'Can''t find role '''+@RoleName+''''
  SET @Checked = 0
END

IF (@Checked = 1)
  IF (NOT EXISTS(SELECT * FROM CCSystem.RolePermissions WHERE PermissionId = @PermissionId AND RoleId = @RoleId))
    PRINT 'Already revoked: Permission '''+@PermissionName+''' to role '''+@RoleName+''''
  ELSE
   BEGIN
     DELETE FROM CCSystem.RolePermissions WHERe RoleId = @RoleId AND PermissionId = @PermissionId
     PRINT 'Revoked: Permission '''+@PermissionName+''' to role '''+@RoleName+''''
   END
ELSE
  PRINT 'Failed: Revoke permission '''+@PermissionName+''' to role '''+@RoleName+''''
END
GO
/****** Object:  StoredProcedure [CCSystem].[SyncRolePermissions]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[SyncRolePermissions](@source_db VARCHAR(1000), @target_db VARCHAR(1000),
    @include_permissions_revoke BIT, @include_permissions_grant BIT,
    @query NVARCHAR(MAX) OUTPUT)
AS
BEGIN

DECLARE @compare_cursor CURSOR

SET @query = 'SELECT * FROM
(SELECT ISNULL(s.CodeName, t.CodeName) AS CodeName, ISNULL(s.RoleName, t.RoleName) AS RoleName,
       CASE WHEN t.RoleName IS NULL THEN ''Added''
            WHEN s.RoleName IS NULL THEN ''Removed''
            ELSE ''Equal''
       END AS Status
FROM (SELECT p.Guid, p.CodeName, r.Name AS RoleName FROM 
'+ @source_db +'.CCSystem.RolePermissions rp
INNER JOIN '+ @source_db +'.CCSystem.Roles r ON rp.RoleId = r.Id
INNER JOIN '+ @source_db +'.CCSystem.Permissions p ON rp.PermissionId = p.Id) s
 FULL OUTER JOIN 
 (SELECT p.Guid, p.CodeName, r.Name AS RoleName FROM 
'+ @target_db +'.CCSystem.RolePermissions rp
INNER JOIN '+ @target_db +'.CCSystem.Roles r ON rp.RoleId = r.Id
INNER JOIN '+ @target_db +'.CCSystem.Permissions p ON rp.PermissionId = p.Id) t 
  ON s.Guid = t.Guid AND s.RoleName = t.RoleName
) t
WHERE Status != ''Equal'' ORDER BY RoleName, CodeName'

--EXEC sys.sp_sqlexec @query
EXEC [CCSystem].[CreateGenericCursor] @vQuery = @query, @Cursor = @compare_cursor OUTPUT
DECLARE @CodeName sysname, @RoleName VARCHAR(400), @Status VARCHAR(15)
FETCH NEXT FROM @compare_cursor INTO @CodeName, @RoleName, @Status

DECLARE @delScript VARCHAR(MAX), @updateScript VARCHAR(MAX), @insertScript VARCHAR(MAX)
SELECT @delScript = '', @insertScript = ''

WHILE @@FETCH_STATUS = 0
BEGIN

  IF (@Status = 'Removed')
    BEGIN
      SET @delScript = @delScript + 'EXEC CCSystem.RevokePermission ''' + @RoleName + ''', ''' + @CodeName + '''' + CHAR(13) + CHAR(10)
    END
  ELSE IF (@Status = 'Added')
    BEGIN
      SET @insertScript = @insertScript + 'EXEC CCSystem.GrantPermission ''' + @RoleName + ''', ''' + @CodeName + '''' + CHAR(13) + CHAR(10)
    END
  FETCH NEXT FROM @compare_cursor INTO @CodeName, @RoleName, @Status
END

CLOSE @compare_cursor
DEALLOCATE @compare_cursor

SET @query = ''
IF (LEN(@delScript) != 0 AND @include_permissions_revoke = 1)
BEGIN

SET @query = @query + CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Revoke permissions
'+ @delScript

END

IF (LEN(@insertScript) != 0 AND @include_permissions_grant = 1)
BEGIN

SET @query = @query + CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Grant  permissions
'+ @insertScript

END

--PRINT @query

END
GO
/****** Object:  StoredProcedure [CCSystem].[SyncRoles]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[SyncRoles](@source_db VARCHAR(1000), @target_db VARCHAR(1000), @include_update BIT = 1, @query_insert NVARCHAR(MAX) OUTPUT, @query_delete NVARCHAR(MAX) OUTPUT)
AS
BEGIN

DECLARE @query NVARCHAR(MAX)
DECLARE @compare_cursor CURSOR

SET @query = 'SELECT * FROM
(SELECT ISNULL(s.Name, t.Name) AS Name, s.Description,
       CASE WHEN t.Id IS NULL THEN ''Added''
            WHEN s.Id IS NULL THEN ''Removed''
            WHEN s.Name != t.Name OR s.Description != t.Description THEN ''NonEqual''
            ELSE ''Equal''
       END AS Status
FROM '+ @source_db + '.CCSystem.Roles s
FULL OUTER JOIN '+ @target_db + '.CCSystem.Roles t ON s.Name = t.Name) t
WHERE Status != ''Equal'''

IF(@include_update = 1)
 SET @query = @query + ' AND Status != ''NonEqual'''
SET @query = @query + ' ORDER BY Name'

EXEC [CCSystem].[CreateGenericCursor] @vQuery = @query, @Cursor = @compare_cursor OUTPUT
DECLARE @Name VARCHAR(400), @Description VARCHAR(500), @Status VARCHAR(15)
FETCH NEXT FROM @compare_cursor INTO @Name, @Description, @Status

DECLARE @delScript VARCHAR(MAX), @updateScript VARCHAR(MAX), @insertScript VARCHAR(MAX)
SELECT @delScript = '', @updateScript = '', @insertScript = ''

WHILE @@FETCH_STATUS = 0
BEGIN

  IF (@Status = 'Removed')
    BEGIN
      IF (LEN(@delScript) != 0) SET @delScript = @delScript + ' ,' ELSE SET @delScript = @delScript + '  '
      SET @delScript = @delScript + '''' + ISNULL(@Name,'') +'''' + CHAR(13) + CHAR(10)
    END
  ELSE IF (@Status = 'Added')
    BEGIN
      IF (LEN(@insertScript) != 0) SET @insertScript = @insertScript + ' ,' ELSE SET @insertScript = @insertScript + '  '
      SET @insertScript = @insertScript +'(' + N'''' + ISNULL(@Name,'') +''', N'''+ ISNULL(@Description,'') +''')' + CHAR(13)+CHAR(10)
    END
  ELSE IF (@Status = 'NonEqual')
    BEGIN
      SET @updateScript = @updateScript + 'UPDATE CCSystem.Roles SET Description=N'''+ ISNULL(@Description,'') +''' WHERE Name =''' + ISNULL(@Name,'') +'''' + CHAR(13)+CHAR(10)
    END
  FETCH NEXT FROM @compare_cursor INTO @Name, @Description, @Status
END

CLOSE @compare_cursor
DEALLOCATE @compare_cursor

SELECT @query_delete = '', @query_insert = ''
IF (LEN(@delScript) != 0)
BEGIN

SET @query_delete = CHAR(13) + CHAR(10) + 'GO'  + CHAR(13)+CHAR(10) + '-- Delete roles
DELETE FROM CCSystem.Roles
WHERE Name IN ('+ @delScript +')'

END

IF (LEN(@updateScript) != 0)
BEGIN

SET @query_insert = @query_insert + CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Update roles
'+ @updateScript

END

IF (LEN(@insertScript) != 0)
BEGIN

SET @query_insert = @query_insert + CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Insert roles
INSERT INTO CCSystem.Roles(Name, Description)
VALUES
'+ @insertScript

END

IF (@query_insert = '') SET @query_insert = NULL
IF (@query_delete = '') SET @query_delete = NULL

END
GO
/****** Object:  StoredProcedure [CCSystem].[SyncUserRoles]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[SyncUserRoles](@source_db varchar(1000), @target_db varchar(1000), @query nvarchar(max) OUTPUT)
AS
BEGIN

DECLARE @compare_cursor CURSOR
 
SET @query = 'SELECT * FROM
(SELECT ISNULL(s.AccountName, t.AccountName) AS AccountName, ISNULL(s.RoleName, t.RoleName) AS RoleName,
       CASE WHEN t.RoleName IS NULL THEN ''Added''
            WHEN s.RoleName IS NULL THEN ''Removed''
            ELSE ''Equal''
       END AS Status
FROM (SELECT u.AccountName, r.Name AS RoleName FROM 
' + @source_db +'.CCSystem.UserRoles ur 
INNER JOIN ' + @source_db +'.CCSystem.Roles r ON ur.RoleId = r.Id
INNER JOIN ' + @source_db +'.CCSystem.Users u ON ur.UserId = u.Id) s
 FULL OUTER JOIN 
 (SELECT u.AccountName, r.Name AS RoleName FROM 
' + @target_db +'.CCSystem.UserRoles ur 
INNER JOIN ' + @target_db +'.CCSystem.Roles r ON ur.RoleId = r.Id
INNER JOIN ' + @target_db +'.CCSystem.Users u ON ur.UserId = u.Id) t 
  ON s.AccountName = t.AccountName AND s.RoleName = t.RoleName
) t
WHERE Status != ''Equal'' ORDER BY RoleName, AccountName'

--EXEC sys.sp_sqlexec @query
EXEC [CCSystem].[CreateGenericCursor] @vQuery = @query, @Cursor = @compare_cursor OUTPUT
DECLARE @AccountName nvarchar(100), @RoleName varchar(400), @Status varchar(15)
FETCH NEXT FROM @compare_cursor INTO @AccountName, @RoleName, @Status

DECLARE @delScript varchar(MAX), @updateScript varchar(MAX), @insertScript varchar(MAX)
SELECT @delScript = '', @insertScript = ''

WHILE @@FETCH_STATUS = 0   
BEGIN 

  IF (@Status = 'Removed')
    BEGIN
      SET @delScript = @delScript + 'EXEC CCSystem.RemoveUserFromRole N''' + @RoleName + ''', ''' + @AccountName + '''' + CHAR(13) + CHAR(10)
    END
  ELSE IF (@Status = 'Added')
    BEGIN
      SET @insertScript = @insertScript + 'EXEC CCSystem.AddUserToRole N''' + @RoleName + ''', ''' + @AccountName + '''' + CHAR(13) + CHAR(10)
    END
  FETCH NEXT FROM @compare_cursor INTO @AccountName, @RoleName, @Status
END   

CLOSE @compare_cursor   
DEALLOCATE @compare_cursor

SET @query = ''
IF (LEN(@delScript) != 0)
BEGIN

SET @query = @query + CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Remove users from roles
' + @delScript

END

IF (LEN(@insertScript) != 0)
BEGIN

SET @query = @query + CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Add users to roles
' + @insertScript

END

--PRINT @query

END
GO
/****** Object:  StoredProcedure [CCSystem].[SyncUsers]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[SyncUsers](@source_db VARCHAR(1000), @target_db VARCHAR(1000), @include_update BIT = 1, @query_insert NVARCHAR(MAX) OUTPUT, @query_delete NVARCHAR(MAX) OUTPUT)
AS
BEGIN

DECLARE @query NVARCHAR(MAX)
DECLARE @compare_cursor CURSOR

SET @query = 'SELECT * FROM
(SELECT ISNULL(s.AccountName, t.AccountName) AS AccountName 
        ,s.DisplayName, s.IsDeactivated, s.IsSystemUser, s.EMail, s.FullAccess
        ,s.DeactivationDate, s.Description, s.PasswordHash,
       CASE WHEN t.Id IS NULL THEN ''Added''
            WHEN s.Id IS NULL THEN ''Removed''
            WHEN (s.AccountName != t.AccountName 
              OR s.DisplayName != t.DisplayName
              OR s.IsDeactivated != t.IsDeactivated
              OR s.IsSystemUser != t.IsSystemUser
              OR s.EMail != t.EMail
              OR s.FullAccess != t.FullAccess
              OR s.DeactivationDate != t.DeactivationDate
              OR s.Description != t.Description
              OR s.PasswordHash != t.PasswordHash) THEN ''NonEqual''
            ELSE ''Equal''
       END AS Status
FROM '+ @source_db + '.CCSystem.Users s
FULL OUTER JOIN '+ @target_db + '.CCSystem.Users t ON s.AccountName = t.AccountName) t
WHERE Status != ''Equal'''

IF(@include_update = 1)
 SET @query = @query + ' AND Status != ''NonEqual'''

SET @query = @query + ' ORDER BY AccountName'

--EXEC sys.sp_executesql @query
EXEC [CCSystem].[CreateGenericCursor] @vQuery = @query, @Cursor = @compare_cursor OUTPUT

DECLARE @AccountName NVARCHAR(100), @DisplayName NVARCHAR(100)
, @IsDeactivated BIT, @IsSystemUser BIT
, @EMail NVARCHAR(100), @FullAccess BIT, @DeactivationDate DATETIME
, @Description VARCHAR(500), @PasswordHash VARBINARY(50)
, @Status VARCHAR(15)

FETCH NEXT FROM @compare_cursor INTO @AccountName, @DisplayName, @IsDeactivated, @IsSystemUser,
                @EMail, @FullAccess, @DeactivationDate, @Description, @PasswordHash, @Status

DECLARE @delScript VARCHAR(MAX), @updateScript VARCHAR(MAX), @insertScript VARCHAR(MAX)
SELECT @delScript = '', @updateScript = '', @insertScript = ''

WHILE @@FETCH_STATUS = 0
BEGIN

  IF (@Status = 'Removed')
    BEGIN
      IF (LEN(@delScript) != 0) SET @delScript = @delScript + ' ,' ELSE SET @delScript = @delScript + '  '
      SET @delScript = @delScript + 'N''' + @AccountName +'''' + CHAR(13)+CHAR(10)
    END
  ELSE IF (@Status = 'Added')
    BEGIN
      IF (LEN(@insertScript) != 0) SET @insertScript = @insertScript + ' ,' ELSE SET @insertScript = @insertScript + '  '
      SET @insertScript = @insertScript +'(' +
      '  N''' + @AccountName +'''' +
      ', N''' + @DisplayName +'''' +
      ', ' + CONVERT(VARCHAR(1), @IsDeactivated) +
      ', ' + CONVERT(VARCHAR(1), @IsSystemUser) +
      ', N''' + @EMail +'''' +
      ', ' + CONVERT(VARCHAR(1), @FullAccess) +
      ', '+ ISNULL(''''+CONVERT(VARCHAR(20), @DeactivationDate, 126) ++'''', 'NULL') +
      ', '+ ISNULL(''''+@Description+'''', 'NULL') +
      ', '+ ISNULL('0x'+CONVERT(VARCHAR(MAX), @PasswordHash, 2), 'NULL') +
      ')' + CHAR(13)+CHAR(10)

    END
  ELSE IF (@Status = 'NonEqual')
    BEGIN
      SET @updateScript = @updateScript + 'UPDATE CCSystem.Users SET ' +
      'DisplayName= N'''+ @DisplayName +'''' +
      ', IsDeactivated=' + CONVERT(VARCHAR(1), @IsDeactivated) +
      ', IsSystemUser=' + CONVERT(VARCHAR(1), @IsSystemUser) +
      ', EMail=N''' + @EMail +'''' +
      ', FullAccess=' + CONVERT(VARCHAR(1), @FullAccess) +
      ', DeactivationDate='+ ISNULL(''''+CONVERT(VARCHAR(20), @DeactivationDate, 126) ++'''', 'NULL') +
      ', Description='+ ISNULL(''''+@Description+'''', 'NULL') +
      ', PasswordHash=0x'+ CONVERT(VARCHAR(MAX), @PasswordHash, 2)
      +'
WHERE AccountName=N'''+ @AccountName +'''' + CHAR(13)+ CHAR(10)
    END
  FETCH NEXT FROM @compare_cursor INTO @AccountName, @DisplayName, @IsDeactivated, @IsSystemUser,
                @EMail, @FullAccess, @DeactivationDate, @Description, @PasswordHash, @Status
END

CLOSE @compare_cursor
DEALLOCATE @compare_cursor

SELECT @query_insert = '', @query_delete = ''
IF (LEN(@delScript) != 0)
BEGIN

SET @query_delete = CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Delete users
DELETE FROM CCSystem.Users
WHERE AccountName IN ('+ @delScript +')'

END

IF (LEN(@updateScript) != 0)
BEGIN

SET @query_insert = @query_insert + CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Update users
'+ @updateScript

END

IF (LEN(@insertScript) != 0)
BEGIN

SET @query_insert = @query_insert + CHAR(13)+CHAR(10) + 'GO'  + CHAR(13)+CHAR(10)+ '-- Insert users
INSERT INTO CCSystem.Users (AccountName, DisplayName, IsDeactivated, IsSystemUser, EMail, FullAccess, DeactivationDate, Description, PasswordHash)
VALUES
'+ @insertScript

END

IF (@query_insert = '') SET @query_insert = NULL
IF (@query_delete = '') SET @query_delete = NULL

END
GO
/****** Object:  StoredProcedure [CCSystem].[UpdatePermissions]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[UpdatePermissions]
@Permissions CCSystem.PermissionsUDT READONLY
AS
BEGIN
--remove old
DELETE dest
  FROM CCSystem.Permissions AS dest
  WHERE NOT dest.Guid IN (SELECT source.Guid FROM @Permissions AS source)

--update existed permissions
UPDATE dest
  SET dest.Id = source.Id,
      dest.Type = source.Type,
      dest.CodeName = source.CodeName,
      dest.DisplayName = source.DisplayName,
      dest.Description = source.Description,
      dest.ObjectId = source.ObjectId
  FROM CCSystem.Permissions AS dest
  INNER JOIN @Permissions AS source
  ON dest.Guid = source.Guid

--add new
INSERT INTO CCSystem.Permissions
SELECT * FROM @Permissions AS source
  WHERE NOT source.Guid IN (SELECT dest.Guid FROM CCSystem.Permissions AS dest)
END
GO
/****** Object:  StoredProcedure [CCSystem].[UpdateSysObjects]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CCSystem].[UpdateSysObjects]
@ObjectsUpdate CCSystem.SysObjectsUpdateUDT READONLY
AS
BEGIN
DECLARE @Objects CCSystem.SysObjectsUDT

INSERT INTO @Objects
SELECT 
  Id,
	ParentId,
	ClassId,
	CodeName,
	DisplayName,
	Description,
	Guid,
  CONVERT(int, CASE WHEN ClassId IN (1, 3)
    THEN OBJECT_ID(DbObjectSchemaName + '.' + DbObjectName) 
    ELSE NULL 
  END)  AS DbObjectId,
  CONVERT(int, CASE WHEN ClassId IN (3)
    THEN COLUMNPROPERTY(OBJECT_ID(DbObjectSchemaName + '.' + DbObjectName), DbFieldName, 'ColumnId') 
    ELSE NULL 
  END)  AS DbFieldId
FROM @ObjectsUpdate

--Check configuration and database integrity
IF (EXISTS(SELECT * FROM @Objects WHERE (ClassId IN (1, 3) AND DbObjectId IS NULL) OR 
                                        (ClassId IN (3) AND DbFieldId IS NULL)))
BEGIN
  PRINT 'Code Cruiser: Integrity between configuration and database is broken. See message(s) below:';

DECLARE message_cursor CURSOR FOR 

WITH Objects_CTE(Id, ParentId, ClassId,
   ObjectCodeName, PropertyCodeName,
   ObjectDisplayName,PropertyDisplayName,
   DbObjectSchemaName, DbObjectName, DbFieldName)
AS
(
  SELECT 
  o.Id,
  o.ParentId,
  o.ClassId,
  parent_o.CodeName AS ObjectCodeName,
  CASE WHEN o.ClassId = 3
    THEN o.CodeName 
    ELSE NULL 
  END AS PropertyCodeName,
  parent_o.DisplayName AS ObjectDisplayName,
  CASE WHEN o.ClassId = 3
    THEN o.DisplayName 
    ELSE NULL 
  END AS PropertyDisplayName,
	o.DbObjectSchemaName,
  o.DbObjectName, 
  o.DbFieldName
  FROM @ObjectsUpdate o
  INNER JOIN @Objects oo  ON oo.Id = o.Id
  INNER JOIN @ObjectsUpdate parent_o ON parent_o.Id = o.Id AND parent_o.ClassId = 1
  WHERE (o.ClassId IN (1, 3) AND oo.DbObjectId IS NULL) OR (o.ClassId IN (3) AND oo.DbFieldId IS NULL)
)
SELECT 'Can''t create metadata for ' +
CASE WHEN ClassId = 1  
  THEN 'Entity '''+ ObjectCodeName +'''' 
  ELSE 'Field '''+ ObjectCodeName + '.' + PropertyCodeName + '''' 
END
+ ' to ' +
CASE WHEN ClassId = 1  
  THEN 'table '''+ DbObjectSchemaName +'.' + DbObjectName +'''' 
  ELSE 'column '''+ DbObjectSchemaName +'.' + DbObjectName + '.' + DbFieldName + '''' 
END
+ '. Check object for existing and object name is correct.'
FROM Objects_CTE

--SELECT * FROM Objects_CTE

--print to output
DECLARE @message varchar(500)


OPEN message_cursor   
FETCH NEXT FROM message_cursor INTO @message

WHILE @@FETCH_STATUS = 0   
BEGIN   
       PRINT @message
       FETCH NEXT FROM message_cursor INTO @message
END   

CLOSE message_cursor   
DEALLOCATE message_cursor
    
  RAISERROR ('Code Cruiser: Integrity between configuration and database is broken. Please run ''Merge'' from Code Cruiser application and run export again', 16, 1);
END

--remove old
DELETE dest
  FROM CCSystem.SysObjects AS dest
  WHERE ClassId <> 0 
     AND NOT(Id < 0) --Ignore depricated
     AND NOT dest.Guid IN (SELECT source.Guid FROM @Objects AS source)
--TODO: Move to depricated if exists in entry log

--update existed objects
UPDATE dest
  SET dest.Id = source.Id,
      dest.ParentId = source.ParentId,
      dest.ClassId = source.ClassId,
      dest.CodeName = source.CodeName,
      dest.DisplayName = source.DisplayName,
      dest.Description = source.Description,
      dest.DbObjectId = source.DbObjectId,
      dest.DbFieldId = source.DbFieldId
  FROM CCSystem.SysObjects AS dest
  INNER JOIN @Objects AS source
  ON dest.Guid = source.Guid

--add new
INSERT INTO CCSystem.SysObjects
SELECT * FROM @Objects AS source
  WHERE NOT source.Guid IN (SELECT dest.Guid FROM CCSystem.SysObjects AS dest)
END
GO
/****** Object:  StoredProcedure [CCSystem].[WriteStringToFile]    Script Date: 26.02.2020 18:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Copied from https://www.simple-talk.com/sql/t-sql-programming/reading-and-writing-files-in-sql-server-using-t-sql/
CREATE PROCEDURE [CCSystem].[WriteStringToFile] (@path varchar(500), @string nvarchar(max))
AS
BEGIN
DECLARE  @objFileSystem int
        ,@objTextStream int,
		@objErrorObject int,
		@strErrorMessage varchar(1000),
	    @Command varchar(1000),
	    @hr int

set nocount on

select @strErrorMessage='opening the File System Object'
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject', @objFileSystem OUT

if @HR=0 Select @objErrorObject=@objFileSystem , @strErrorMessage='Creating file "'+@Path+'"'
if @HR=0 execute @hr = sp_OAMethod @objFileSystem, 'CreateTextFile', @objTextStream OUT, @Path, 2, True

if @HR=0 Select @objErrorObject=@objTextStream, 
	@strErrorMessage='writing to the file "'+@Path+'"'
if @HR=0 execute @hr = sp_OAMethod  @objTextStream, 'Write', Null, @string

if @HR=0 Select @objErrorObject=@objTextStream, @strErrorMessage='closing the file "'+@Path+'"'
if @HR=0 execute @hr = sp_OAMethod  @objTextStream, 'Close'

if @hr<>0
	begin
	DECLARE @Source varchar(255), @Description Varchar(255), @Helpfile Varchar(255),	@HelpID int
	
	EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
		@source output,@Description output,@Helpfile output,@HelpID output
	Select @strErrorMessage='Error whilst '+coalesce(@strErrorMessage,'doing something')+', '+coalesce(@Description,'')
	raiserror (@strErrorMessage,16,1)
	end
EXECUTE  sp_OADestroy @objTextStream
EXECUTE sp_OADestroy @objFileSystem
END
