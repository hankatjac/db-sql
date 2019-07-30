/* 
Manipulat data
Script Date: March 29, 2019
Developed by: Hang
*/


--swithch to northwind database
use WMLibrary;
go 



-- Q1 How many loans did the library do last year?
select * from Records.Loans;
go

select count(LoanID) as 'Number of loans from last year'
from Records.Loans
where Out_Date between '2018-01-01'  and '2018-12-31'
;
go 


-- Q2 What percentage of the membership borrowed at least one book?

select COUNT(x.memberID) as 'the number of membership borrowed at least one book' , count(m.MemberID) as 'number of membership', (count(x.MemberID)*100.0/count(m.MemberID)) as 'Percentage'
from 
(
	select COUNT(L.loanID) as y, L.MemberID as 'MemberID'
	from Records.Loans as L
	group by L.MemberID
	having COUNT(L.loanID) > = 1
	
) as x
	right join Persons.Members as m
		on x.MemberID = m.MemberID
;
go

-- Q3 What was the greatest number of books borrowed by any one individual?
select max(y.[number of loans]) as 'the greatest number of books borrowed'
from
(
	select COUNT(L.loanID) as 'number of loans', L.MemberID
	from Records.Loans as L
	group by L.MemberID
) as  y
;	
go

-- Q4. what percentage of the books was loaned out at least once last year
select count(x.once) as 'number of books loaned out at least once' ,  count(c.ISBN) as 'number of books', (count(x.once)*100.0/count(c.ISBN)) as 'percentage'
from 
(
	select count(L.LoanID) as 'once', L.ISBN
	from Records.Loans as L
	where L.Out_Date between '2018-01-01'  and '2018-12-31'
	group by L.ISBN
	having COUNT(L.loanID) > = 1
) as x 
	right join Books.Copies as C
	on x.ISBN = C.ISBN
;
go

 -- Q5. What percentage of all loans eventually becomes overdue?
select DATEDIFF(DAY, Due_Date, In_Date)
from Records.LoanHist
where In_Date > Due_Date
;
go

select count(x.LoanHistID) as 'Loan Overdue', count(y.LoanHistID) as 'Total Loans', count(x.LoanHistID)*100.0/count(y.LoanHistID) as 'Percentage of Loans that are over due'
from
(
	select LoanHistID 
	from Records.LoanHist 
	where In_Date > Due_Date
) as x
	
	right join

(	
	select LoanHistID
	from Records.LoanHist 
) as y


on x.LoanHistID  = y.LoanHistID 
;
go


--Q6 What is the average length of a loan?
select sum(datediff(day,out_date, in_date)) as 'Total days of all loans', count(loanHistID) as 'number of loans', sum(datediff(day,out_date, in_date))/ count(loanHistID) as 'average length of a loan in days'
from  Records.LoanHist;
;
go


-- Q7. What are the library peak for loans?
select * from Records.LoanHist;
go

select count(LoanHistID) as Peak, OutYear = DATEPART(YEAR, Out_Date), OutMonth = DATEPART(MONTH, Out_Date)
from Records.LoanHist  
group by DATEPART(YEAR, out_Date), DATEPART(MONTH, Out_Date)
having count(LoanHistID) = 
(
	select max(x.TotalCount)
		from
		(
			select  count(LoanHistID) as TotalCount ,  OutYear = DATEPART(YEAR, Out_Date), OutMonth = DATEPART(MONTH, Out_Date)
			from   Records.LoanHist 
			group by DATEPART(YEAR, out_Date), DATEPART(MONTH, Out_Date)
		) as x
) 
;
go
