/* 
Purpose: update data
Script Date: April 08 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher 
*/

use WMLibrary;
go


/*

	2008 --> 2019
	2007 --> 2018
	by adding 11 years
*/

--UPDATE Records.LoanHist
--SET Due_Date = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 200), '2018-12-31');
--go

--select * from Persons.Adults;
--go

UPDATE Persons.Adults
SET ExprDate = DATEADD(YEAR, 11, ExprDate);
go

--select * from Persons.Juniors;
--go

UPDATE Persons.Juniors
SET DateOfBirth = DATEADD(YEAR, 11, DateOfBirth);
go

UPDATE Records.Reservations
SET Log_Date = DATEADD(YEAR, 11, Log_Date);
go

UPDATE Records.Loans
SET Due_Date = DATEADD(YEAR, 11, Due_Date);
go


UPDATE Records.Loans
SET Out_Date = DATEADD(YEAR, 11, Out_Date);
go



UPDATE Records.LoanHist
SET Due_Date = DATEADD(YEAR, 11, Due_Date);
go

UPDATE Records.LoanHist
SET Out_Date = DATEADD(YEAR, 11, Out_Date);
go


UPDATE Records.LoanHist
SET In_Date = DATEADD(YEAR, 11, in_Date);
go

--select * from Records.Loans;
--go

--select * from Records.LoanHist;
--go

--delete from Records.Loans;
--go

