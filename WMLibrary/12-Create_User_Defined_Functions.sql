/* 
	rollback Transaction
	Script Date: March 29, 2019
	Developed by: Hang
*/


--swithch to northwind database
use WMLibrary;
go 

--UPDATE Records.LoanHist
--SET Due_Date = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 15), In_Date);
--go



-- This function to calculate Fine assessed when a book return date is greater than due date
if OBJECT_ID('Records.FineAssessedFn', 'Fn') is not null
	drop function Records.FineAssessedFn
;
go

create function Records.FineAssessedFn
( @Due_Date as date, @In_Date as date )

returns money

as begin
		declare @FinAssessed as money
		if @Due_Date < @In_Date
			begin
				SET @FinAssessed= 0.05*ABS(datediff(DAY, @Due_Date, @In_Date))
			end
		else SET @FinAssessed= 0;
		
		return @FinAssessed
		
	end
;
go


-- testing fuction Records.FineAssessedFn

update Records.LoanHist
set Fine_Assessed = Records.FineAssessedFn(Due_Date, In_Date)
from Records.LoanHist 
;
go


select Due_Date, In_Date, Fine_Assessed
from Records.LoanHist
where Fine_Assessed != 0
;

go


-- this function to calculate Percentage of Loans that are over due
if OBJECT_ID('Records.PercentOfOverDueFN', 'Fn') is not null
	drop function Records.PercentOfOverDueFN
;
go

create function Records.PercentOfOverDueFN
()
returns real
as
begin
	declare @a as real
	declare @b as real
	declare @c as real
	set @a =
	(
		select count(LoanHistID) 
		from Records.LoanHist
	)
	set @b = 
	(
		select count(LoanHistID)
		from Records.LoanHist
		where in_date > Due_Date
	)
	set @c = ( @b/@a )*100
	return @c
end
go

-- testing function Percentage of Loans that are over due
select Records.PercentOfOverDueFN() as 'Percentage of Loans that are over due'
go

-- this function to calculate Average length of loans

if OBJECT_ID('Persons.getAverageLengthFN', 'Fn') is not null
	drop function Persons.getAverageLengthFN
;
go


create function Persons.getAverageLengthFN
()
returns real
as
begin
	declare @avg as real
	select @avg = sum(datediff(day,out_date, in_date)) / count(loanHistID)
	from Records.LoanHist
	return @avg
end
go

-- testing function Average length of loans
select  Persons.getAverageLengthFN() as 'Average length of loans'
go


