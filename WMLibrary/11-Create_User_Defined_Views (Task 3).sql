/* 
create user-defined views
Script Date: March 29, 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher 
*/


/*add a statement that specifies the script runs in the context of the master database */

use WMLibrary;
go

--using the information _shcema
select * from information_schema.views
;
go

-- Q1. create a mailling list of Library members that includes the members' full names and complete address information
if OBJECT_ID ('Persons.MailingListView', 'V') is not null
	drop view Persons.MailingListView
;
go

CREATE VIEW Persons.MailingListView
AS 
	SELECT CONCAT_WS(' ', M.LastName, M.MiddleInital, M.FirstName) as 'Full Name', CONCAT_WS(' ', A.Address, A.City, A.State, A.Zip) as 'Complete Address'
	FROM Persons.Members AS M
	JOIN Persons.Adults AS A
	ON M.MemberID = A.MemberID
;
go

SELECT * FROM Persons.MailingListView;
go


-- Q2. create a bookinfo view to query the ISBN, copyID, on_loan, title, translation, and cover with an ISBN of 1, 500, or 1000. Order the result by ISBN column.
if OBJECT_ID ('Books.BookInfoView', 'V') is not null
	drop view Books.BookInfoView
;
go

CREATE VIEW Books.BookInfoView
AS 
	SELECT TOP (9223372036854775807) T.Title, I.ISBN, I.Language, I.Cover, C.CopyID, C.On_Loan 
	FROM Books.Titles AS T 
	inner join Books.Items AS I
	ON T.TitleID = I.TitleID
	Inner join Books.Copies AS C
	ON I.ISBN = C.ISBN
	where C.ISBN in ('1', '500', '1000')
	order by ISBN
;
go

SELECT * FROM Books.BookInfoView;
go

/* Q3. MemberInfoAndReservationView*/
if object_id('Persons.MemberInfoAndReservationView', 'V') is not null
	drop view Persons.MemberInfoAndReservationView
go

create view Persons.MemberInfoAndReservationView
as
	select TOP (9223372036854775807) M.MemberID, concat_ws(' ',M.FirstName,M.MiddleInital, M.LastName) as 'Full Name', R.ISBN, R.Log_Date
	from Persons.Members as M
		left join records.Reservations as R
			on M.MemberID = R.MemberID
	where M.memberID in (250,341,1675)
	order by MemberID asc
go

SELECT * FROM Persons.MemberInfoAndReservationView;
go


/*  Q4. adultwideView'*/

if object_id('Persons.adultwideView', 'V') is not null
	drop view Persons.adultwideView
go

create view Persons.adultwideView
as 
	select concat_ws(' ',M.FirstName,M.LastName) as 'Full Name',concat_ws(' ',A.address,A.city,A.state,A.zip) as 'Address'
	from Persons.Members as M
		inner join Persons.Adults as A
			on M.MemberID = A.MemberID
go

select *
from Persons.adultwideView;
go


/*  Q5. childwideView */

if object_id('Persons.childwideView', 'V') is not null
	drop view Persons.childwideView
go

create view Persons.childwideView
as 
	select concat_ws(' ',M.FirstName,M.LastName) as 'Full Name',concat_ws(' ',A.address,A.city,A.state,A.zip) as 'Address'
	from Persons.Members as M
		inner join Persons.Juniors as J
			on M.MemberID = J.MemberID
		inner join Persons.Adults as A
			on J.AdultMemberID = A.MemberID
go

select *
from Persons.childwideView
go


-- Q6. create an copywidview that queries the copy, title, and item tables

if OBJECT_ID ('Books.CopywideView', 'V') is not null
	drop view Books.CopywideView
;
go


create view Books.CopywideView
as
	select C.ISBN, C.On_Loan, I.Language, I.Cover, I.Loanable, T.Title, T.Author, T.Synopsis
	from Books.Copies as C
		inner join Books.Items as I
		on C.ISBN = I.ISBN

		inner join Books.Titles as T
		on C.TitleID = T.TitleID
;
go


alter view Books.CopyWideView
as
	select C.ISBN, C.CopyID, C.On_Loan, I.Language, I.Cover, I.Loanable, T.Title, T.Author, T.Synopsis
	from Books.Copies as C
		inner join Books.Items as I
		on C.ISBN = I.ISBN

		inner join Books.Titles as T
		on I.TitleID = T.TitleID

;
go

select * from Books.CopywideView;
go


-- Q7. Create LoanableView that queries CopywideView list complete information about each copy marked as loanable
if OBJECT_ID ('Books.LoanableView', 'V') is not null
	drop view Books.LoanableView
;
go


create view Books.LoanableView
as
	select cv.ISBN, cv.CopyID, cv.Language, cv.Loanable, cv.Title 
	from Books.CopywideView as CV
	where cv.loanable = 1
;
go


select * from Books.LoanableView;
go

-- Q8. create OnshelfView that queries CopywideView list complete information about each copy that is not currently on loan.
if OBJECT_ID ('Books.OnshelfView', 'V') is not null
	drop view Books.OnshelfView
;
go

create view Books.OnshelfView
as
	select ISBN, CopyID as 'Copy ID', on_loan as 'On Loan', Language, Cover, Loanable, Title 
	from Books.CopywideView 
	where loanable = 1 and on_loan = 0
;
go


select * from Books.OnshelfView;
go

-- Q9. OnloanView
if OBJECT_ID ('Records.OnloanView', 'V') is not null
	drop view Records.OnloanView
;
go

create view Records.OnloanView
as
	select M.MemberID as 'Member ID', concat_ws(' ', M.FirstName, M.MiddleInital, M.LastName) as 'Full Name', T.Title as 'Book Title',L.ISBN as 'ISBN number', L.Out_Date as 'Out Date', L.Due_Date as 'Due Date'
	from [Records].[Loans] as L
	inner join [Persons].[Members] as M
	on L.MemberID = M.MemberID
	inner join [Books].[Titles] as T
	on L.titleID = T.TitleID
;
go

select * from Records.OnloanView;
go

-- Q10. OverDueView
if OBJECT_ID ('Records.OverDueView', 'V') is not null
drop view Records.OverDueView
;
go

create view Records.OverDueView
as
	select ODV.[Member ID], ODV.[Full Name], ODV.[Book Title], ODV.[ISBN number], ODV.[Out Date], ODV.[Due Date] 
	from [Records].[OnloanView] as ODV
		inner join [Records].[LoanHist] as LH
		on ODV.[Member ID] = LH.[MemberID]
	where [Due Date] < getdate() and LH.[In_Date] is null
;
go

select * from Records.OverDueView;
go

select * from Records.Loans;
go