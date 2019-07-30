/* Purpose Create My WMLbrary Database
Script Date: April 04 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher */

use master;
go

drop database if exists WMLibrary;
go

create database WMLibrary
on primary
(
	name = 'WMLibrary' ,
	filename =  'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\1-CreateWMLibrary.mdf',
	size = 12MB,
	filegrowth = 4MB,
	maxsize = 100MB
)
log on
(
	name = 'WMLibrary_log' ,
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\1-CreateWMLibrary_log.mdf',
	size = 3MB,
	filegrowth = 10%,
	maxsize = 20MB
)
go

