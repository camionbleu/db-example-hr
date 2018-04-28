USE [master]
GO

IF  EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'hr')
DROP DATABASE [hr]
GO

CREATE DATABASE [hr]
GO
USE [hr]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
The hr (human resources) database will comprise two tables: tblDepartments and tblEmployees.
*/
CREATE TABLE [dbo].[tblDepartments](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nchar](30) NOT NULL,
 CONSTRAINT [PK_tblDepartments] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[tblEmployees](
	[EmployeeId] [int] IDENTITY(1,1) NOT NULL,
	[ManagerId] [int] NULL,
	[DepartmentId] [int] NULL,
	[FName] [nchar](30) NOT NULL,
	[LName] [nchar](30) NOT NULL,
	[Title] [nchar](30) NULL,
 CONSTRAINT [PK_tblEmployees] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*
Insert some data into tblDepartments. Allow the identity column values to be inserted while we set up this sample data.
*/
SET IDENTITY_INSERT [dbo].[tblDepartments] ON 
GO
INSERT [dbo].[tblDepartments] ([DepartmentId], [DepartmentName]) VALUES (1, N'Sales')
GO
INSERT [dbo].[tblDepartments] ([DepartmentId], [DepartmentName]) VALUES (2, N'Marketing')
GO
INSERT [dbo].[tblDepartments] ([DepartmentId], [DepartmentName]) VALUES (3, N'Engineering')
GO
SET IDENTITY_INSERT [dbo].[tblDepartments] OFF
GO

/*
Insert some data into tblEmployees. Again, allow the identity column values to be inserted.
*/
SET IDENTITY_INSERT [dbo].[tblEmployees] ON 
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (1, 3, 3, N'Eric', N'Ealing', N'Engineer')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (2, 3, 3, N'Elizabeth', N'Entwistle', N'Senior Engineer')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (3, 4, 3, N'Ella', N'Elton', N'Engineering Manager')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (4, NULL, NULL, N'Pat', N'Pinkerton', N'President')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (5, 7, 2, N'Michael', N'Meacher', N'Marketing Assistant')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (6, 7, 2, N'Mary', N'Mulholland', N'Marketing Guru')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (7, 4, 2, N'Marc', N'Moore', N'Marketing Manager')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (8, 10, 1, N'Sam', N'Smith', N'Sales Representative')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (9, 10, 1, N'Simon', N'Standage', N'Sales Representative')
GO
INSERT [dbo].[tblEmployees] ([EmployeeId], [ManagerId], [DepartmentId], [FName], [LName], [Title]) VALUES (10, 4, 1, N'Sal', N'Sinden', N'Sales Manager')
GO
SET IDENTITY_INSERT [dbo].[tblEmployees] OFF
GO

/*
Set up referential integrity for our tables.
*/
ALTER TABLE [dbo].[tblEmployees]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployees_tblDepartments] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[tblDepartments] ([DepartmentId])
GO
ALTER TABLE [dbo].[tblEmployees] CHECK CONSTRAINT [FK_tblEmployees_tblDepartments]
GO
ALTER TABLE [dbo].[tblEmployees]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployees_tblEmployees] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[tblEmployees] ([EmployeeId])
GO
ALTER TABLE [dbo].[tblEmployees] CHECK CONSTRAINT [FK_tblEmployees_tblEmployees]
GO
USE [master]
GO
ALTER DATABASE [hr] SET  READ_WRITE 
GO

/*
Select from the two tables just to check that our data looks OK. The data is arranged into a hierarchy with 
Pat Pinkerton at the top (Pat has no manager, and no department).
The three departmental managers (all of whom report to Pat Pinkerton) are: 
Ella Elton (Engineering), Marc Moore (Marketing), and Sal Sinden (Sales).
Everyone else reports to one of the departmental managers.
*/
USE [hr]
SELECT e1.FName, e1.LName, e2.FName AS ManagerFName, e2.LName AS ManagerLName, e1.Title, d.DepartmentName
FROM tblEmployees e1
LEFT JOIN tblEmployees e2
ON e1.ManagerId = e2.EmployeeId
LEFT JOIN tblDepartments d
ON e1.DepartmentId = d.DepartmentId
ORDER BY d.DepartmentName, e1.FName, e1.LName
