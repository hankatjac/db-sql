/* 
Purpose: Alter Tables
Script Date: April 04 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher 
*/

use WMLibrary;
go


alter table Persons.Members
	add JoinDate date null
go

alter table Persons.Members
	add ExprDate date null
go

select *
from Persons.members
go

-- Create DimDate dimension table
CREATE TABLE RandomDates
(
	DateID int identity(1, 1) NOT NULL ,
	RandomDate date NOT NULL,
	CONSTRAINT pk_RandomDates PRIMARY KEY CLUSTERED (DateID asc)
)
GO


-- Populate JoinDate and ExpDate Values 

create procedure Persons.addUpdateDatesSP
as
declare @loop as int
set @loop = 1
while @loop < 10000
set @loop += 1
begin
UPDATE Persons.Members
SET JoinDate = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), '2018-01-01')

update Persons.Members
set ExprDate= dateadd(year, 1, JoinDate)
end
go

execute Persons.addUpdateDatesSP
go

select *
from Persons.Members
;
go

