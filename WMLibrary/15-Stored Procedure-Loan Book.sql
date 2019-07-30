/* Using stored procedure to loan a book to customer 
Script Date: April 07 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher */

use WMLibrary;
go

select * from [Records].[Loans];
go


select * from Books.copies;
go


select in_date, due_date
from Records.LoanHist

UPDATE Records.Loans
SET Due_Date = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 120), '2019-12-31');
go

UPDATE Records.Loans
SET Out_Date = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 120), '2018-12-31');
go

UPDATE Records.Loans
SET Due_Date = DATEADD(DAY, 14, Out_Date);
go


if OBJECT_ID('Records.LoanBookSP', 'p') is not null
	drop PROCEDURE Records.LoanBookSP
;
go

--create a procedure, MasterInsertUpdateDelete_LoansSP, that masters insert, update, delete options for the Loan table, and updates the Due_date = Out_Date + 14
create PROCEDURE Records.LoanBookSP  
(  
@MemberID int,
@ISBN int,  
@CopyID int
)  
AS  
BEGIN 
    BEGIN TRY 
		BEGIN TRANSACTION;

		-- Make sure the member is available to borrow a book
		IF ((SELECT [ExprDate] FROM [Persons].[Adults] as A
			inner join [Persons].[Juniors] as J
			on J.AdultMemberID = A.MemberID
			WHERE J.[MemberID] =  @MemberID or A.MemberID =@MemberID)> GETDATE())
			begin
				--Only 25 books can be loaned for each member
				IF ( (select count(*) as 'Number of MemberID' 
				from [Records].[Loans]
				where MemberID =@MemberID) < 6)
				begin
				print 'Member < 25'
				--Only loanable book can be loaned by members
					if ((select On_Loan from [Books].[Copies]
						where CopyID = @CopyID and ISBN = @ISBN) = 0)
						begin
							begin
							print 'This book is available to loan'
							-- Insert a loan record into loan table with due_Date 14 days after the current date.
							DECLARE @titleID int
							SET @titleID = (select titleID from [Books].[Copies]
							where CopyID = @CopyID and ISBN = @ISBN)
							insert into [Records].[Loans] ([LoanID],ISBN, CopyID,titleID,MemberID, Out_Date, Due_Date) values(2000, @ISBN, @CopyID, @TitleID, @MemberID, getdate(), DATEADD(DAY, 14, getdate())) ;
							print 'Insert into loan table succefully'
							end

							begin
							--Change the state of this copy book (on_loan) in copy table to 1 
							update [Books].[Copies]
							set [Books].[Copies].On_Loan = 1
							where [Books].[Copies].CopyID = @CopyID and [Books].[Copies].ISBN = @ISBN;
							print 'Update the loan table succefully'
							end

							--check all the state of this book (on_loan) in copy table 
							DECLARE @SumOfOnLoan int
							SET @SumOfOnLoan = (select (SUM(CAST(on_loan AS INT))) from [Books].[Copies]
							where ISBN = @ISBN)
					

							--Update the state of this book (Loanable) to 0 in item table if all the copied is on loaned.
							begin
							If ((select count(ISBN) from [Books].[Copies])= @SumOfOnLoan)
								begin
								update [Books].[Items]	set loanable = 0
								print ' There is no copy which can be loaned for this book.'
								end
							else
								print 'This book has been loaned successfully'
							end
						end
					else
						print 'Sorry, this book has already loaned.'  
					end
				else
					print 'Sorry, this member has already borrowed 25 books.'
			end
		else
			print 'Sorry, this card is expired, please to renew this card.'
		COMMIT
	END TRY
		 BEGIN CATCH
            ROLLBACK
    END CATCH
END  


--testing insert a loan record
execute Records.LoanBookSP 99999,1,1
go


select count(*) 
		from [Records].[Loans]
		group by MemberID
		having MemberID= 23

select count(*) as 'Number of MemberID' 
		from [Records].[Loans]
		where MemberID =2223

select * from Books.copies;
go

select * from [Records].[Loans] order by LoanID
go

select * from [Books].[Items] order by itemID
go

select on_loan from [Books].[Copies]
						where ISBN = 1

select (SUM(CAST(on_loan AS INT))) from [Books].[Copies]
					where ISBN = 1