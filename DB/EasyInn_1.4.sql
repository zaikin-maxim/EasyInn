GO
/****** Object:  Table [dbo].[Listing]    Script Date: 28.12.2019 20:40:59 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListingImage]    Script Date: 28.12.2019 20:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListingImage](
	[Id] [int] NOT NULL,
	[FileId] [int] NOT NULL,
	[Comment] [nvarchar](200) NULL,
	[ListingId] [int] NOT NULL,
 CONSTRAINT [PK_ListingImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Partner]    Script Date: 28.12.2019 20:40:59 ******/
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
/****** Object:  Table [dbo].[Reservation]    Script Date: 28.12.2019 20:40:59 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Upsell]    Script Date: 28.12.2019 20:40:59 ******/
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
/****** Object:  Table [dbo].[UpsellStatus]    Script Date: 28.12.2019 20:40:59 ******/
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
/****** Object:  Table [dbo].[UserExtension]    Script Date: 28.12.2019 20:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserExtension](
	[Id] [int] NOT NULL,
	[UserKeyAPI] [nvarchar](50) NOT NULL,
	[UserId] [int] NOT NULL,
	[ContactName] [nvarchar](150) NULL,
	[LogoFileId] [int] NOT NULL,
 CONSTRAINT [PK_UserExtension] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WayThrought]    Script Date: 28.12.2019 20:40:59 ******/
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
ALTER TABLE [dbo].[WayThrought]  WITH CHECK ADD  CONSTRAINT [FK_WayThrought_Listing] FOREIGN KEY([ListingId])
REFERENCES [dbo].[Listing] ([Id])
GO
ALTER TABLE [dbo].[WayThrought] CHECK CONSTRAINT [FK_WayThrought_Listing]
GO
USE [master] 
GO
