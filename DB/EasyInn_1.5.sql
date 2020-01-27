USE [master]
GO
/****** Object:  Database [EasyInn]    Script Date: 27.01.2020 22:45:31 ******/
CREATE DATABASE [EasyInn]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EasyInn', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EasyInn.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'EasyInn_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EasyInn_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [EasyInn] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EasyInn].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EasyInn] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [EasyInn] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [EasyInn] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [EasyInn] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [EasyInn] SET ARITHABORT OFF 
GO
ALTER DATABASE [EasyInn] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [EasyInn] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [EasyInn] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [EasyInn] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [EasyInn] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [EasyInn] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [EasyInn] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [EasyInn] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [EasyInn] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [EasyInn] SET  DISABLE_BROKER 
GO
ALTER DATABASE [EasyInn] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [EasyInn] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [EasyInn] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [EasyInn] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [EasyInn] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [EasyInn] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [EasyInn] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [EasyInn] SET RECOVERY FULL 
GO
ALTER DATABASE [EasyInn] SET  MULTI_USER 
GO
ALTER DATABASE [EasyInn] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [EasyInn] SET DB_CHAINING OFF 
GO
ALTER DATABASE [EasyInn] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [EasyInn] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [EasyInn] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'EasyInn', N'ON'
GO
ALTER DATABASE [EasyInn] SET QUERY_STORE = OFF
GO
USE [EasyInn]
GO
/****** Object:  Schema [CCSystem]    Script Date: 27.01.2020 22:45:32 ******/
CREATE SCHEMA [CCSystem]
GO
/****** Object:  UserDefinedTableType [CCSystem].[PermissionsUDT]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  UserDefinedTableType [CCSystem].[SysObjectsUDT]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  UserDefinedTableType [CCSystem].[SysObjectsUpdateUDT]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  UserDefinedFunction [CCSystem].[GetSysFieldId]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  UserDefinedFunction [CCSystem].[GetSysObjectId]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  UserDefinedFunction [CCSystem].[HasPermission]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  Table [CCSystem].[Roles]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Role_Name_IsOwnByUser] UNIQUE NONCLUSTERED 
(
	[Name] ASC,
	[IsOwnByUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[UserRoles]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_RoleUser] UNIQUE NONCLUSTERED 
(
	[RoleId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[Permissions]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Permissions_CodeName] UNIQUE NONCLUSTERED 
(
	[CodeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Permissions_Guid] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[RolePermissions]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [CCSystem].[UserPermissionsDisplayView]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  Table [CCSystem].[Users]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_CcUsers_AccountName] UNIQUE NONCLUSTERED 
(
	[AccountName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [CCSystem].[UsersDisplayView]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  Table [CCSystem].[Files]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[Info]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[ObjectTypes]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[Operation]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[OperationLocks]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[OperationResult]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[PermissionTypes]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[RefreshToken]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[ResetPasswordToken]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[SettingProperties]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_SettingProperties_Group_Name] UNIQUE NONCLUSTERED 
(
	[GroupName] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[Settings]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Settings_User_Property] UNIQUE NONCLUSTERED 
(
	[UserId] ASC,
	[SettingPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[SysObjectClasses]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CCSystem].[SysObjects]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_SysObjects_Guid] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Listing]    Script Date: 27.01.2020 22:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Listing](
	[Id] [int] NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
	[UsingRools] [nvarchar](200) NULL,
	[UserId] [int] NOT NULL,
	[City] [nvarchar](150) NOT NULL,
	[ApartmentName] [nvarchar](150) NOT NULL,
	[ManagerName] [nvarchar](150) NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListingImage]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Partner]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation]    Script Date: 27.01.2020 22:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation](
	[Id] [int] NOT NULL,
	[CheckInDate] [datetime] NOT NULL,
	[CheckOutDate] [datetime] NOT NULL,
	[FirstName] [nvarchar](150) NOT NULL,
	[LastName] [nvarchar](150) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](150) NULL,
	[ListingId] [int] NOT NULL,
 CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Upsell]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UpsellStatus]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserExtension]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WayThrought]    Script Date: 27.01.2020 22:45:32 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
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
/****** Object:  StoredProcedure [CCSystem].[AddUserToRole]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[CreateGenericCursor]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[GetSyncSecurity]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[GrantPermission]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[RemoveUserFromRole]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[RevokePermission]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[SyncRolePermissions]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[SyncRoles]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[SyncUserRoles]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[SyncUsers]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[UpdatePermissions]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[UpdateSysObjects]    Script Date: 27.01.2020 22:45:32 ******/
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
/****** Object:  StoredProcedure [CCSystem].[WriteStringToFile]    Script Date: 27.01.2020 22:45:32 ******/
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
GO
USE [master]
GO
ALTER DATABASE [EasyInn] SET  READ_WRITE 
GO
