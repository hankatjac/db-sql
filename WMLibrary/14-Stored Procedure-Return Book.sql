/* Using stored procedure to return a book 
Script Date: April 07 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher */

use WMLibrary;
go

UPDATE [Persons].[Adults]
SET [ExprDate] = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 120), '2019-12-31');
go


UPDATE [Records].[LoanHist]
SET Due_Date = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 30), '2019-3-31');
go

if OBJECT_ID('Records.ReturnBookSP', 'p') is not null
	drop PROCEDURE Records.ReturnBookSP
;
go

/* Using stored procedure to return a book */
create PROCEDURE Records.ReturnBookSP  
(
     @ISBN int = 1,
     @CopyID int = 1, 
	 @TotalFine as money out
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE
		@MemberID as int
		SET @MemberID = (SELECT [MemberID] 
		FROM [Records].[Loans]
		WHERE (ISBN = @ISBN AND CopyID = @CopyID)) 
		print concat('@member:',convert(varchar(10), @MemberID))

		-- Make sure the member card is available.
		IF ((SELECT [ExprDate] FROM [Persons].[Adults] as A
			inner join [Persons].[Juniors] as J
			on J.AdultMemberID = A.MemberID
			WHERE J.[MemberID] =  @MemberID or A.MemberID =@MemberID)> GETDATE())
			BEGIN
			-- 0 means the book has already returned, and it might be a mistake.
			-- Then need to insert a record from loanhist table
				IF ( (SELECT COUNT(*) FROM [Records].[Loans]
					WHERE (ISBN = @ISBN AND CopyID = @CopyID))=0
					)
					BEGIN
					INSERT INTO [Records].[Loans]
					([LoanID],[ISBN],[CopyID],[titleID],[MemberID],[Out_Date],[Due_Date])
					SELECT TOP 1 2001, [ISBN],[CopyID],[titleID],[MemberID],GETDATE(), DATEADD(DAY, 14, getdate())
					FROM [Records].[LoanHist] AS LH
					WHERE (ISBN = @ISBN AND CopyID = @CopyID)
					ORDER BY [Out_Date] DESC

					print 'insert a fake record to loan table.'
					END
		
				--The book is in the loan table, Then insert the record into LoanHist table
				begin
				INSERT INTO [Records].[LoanHist]
				  (
				   [ISBN],[CopyID],[Out_Date],[titleID],[MemberID],[Due_Date],[In_Date],[Fine_Assessed]
				  )
				SELECT [ISBN],[CopyID],[Out_Date],[titleID],[MemberID],[Due_Date], GETDATE(), Records.FineAssessedFn([Due_Date])
				FROM [Records].[Loans]
				WHERE (ISBN = @ISBN AND CopyID = @CopyID);
				print 'Inserted into LoanHist table a record'
				end

				--Delete the record from the Loan Table
				begin
				DELETE FROM [Records].[Loans] 
					WHERE (ISBN = @ISBN AND CopyID = @CopyID);
				print 'Deleted a record from loan table'
				end
			
				--Change the state of this book to not on_load
				begin
				UPDATE [Books].[Copies]
				SET On_Loan = 0
				WHERE (ISBN = @ISBN AND CopyID = @CopyID);
				print 'changed the copy book status'
				end

				----Update the state of this book (Loanable) to 1 in item table if loanable is 0.
				begin
				If ((select Loanable from [Books].[Items] where ISBN =@ISBN)= 0)
					begin
					update [Books].[Items]	set loanable = 1
					print 'This book can be loaned again.'
					end
				end

				-- Calculate the total fine fee for the member
				begin
				SET @TotalFine =
				(	SELECT sum([Fine_Assessed]) as 'Total Fine Fee'
					FROM [Records].[LoanHist] 
					GROUP BY [MemberID]
					HAVING [MemberID] = @MemberID
				)
				end
			print 'Returned a book successfully!'
			END
		else
			print 'Sorry, this card is expired, please to renew this card.'
        COMMIT
    END TRY
    BEGIN CATCH
              ROLLBACK  -- rollback to MySavePoint
    END CATCH
END;
GO




-- testing Records.ReturnBookSP

-- Declare the variable to receive the output value of the procedure.  
DECLARE @TotalFine as money;  
-- Execute the procedure specifying a last name for the input parameter  
-- and saving the output value in the variable @SalesYTDBySalesPerson  
EXECUTE Records.ReturnBookSP 1, 1, @TotalFine OUTPUT;  
-- Display the value returned by the procedure.  
PRINT 'Total Fine fee is ' +   
    convert(varchar(10),@TotalFine);  
GO


SELECT * 
		FROM [Records].[Loans]
		WHERE (ISBN = 60 AND CopyID = 6)

		SELECT * 
		FROM [Records].[Loans]WHERE [MemberID] = 2223

SELECT * FROM [Records].[LoanHist] WHERE [MemberID] = 2223;


SELECT * FROM [Records].[Loans] WHERE (ISBN = 60 AND CopyID = 6);
go	

SELECT * FROM [Records].[LoanHist] WHERE (ISBN = 60 AND CopyID = 6);
go	

SELECT * FROM [Books].[Copies] WHERE (ISBN = 60 AND CopyID = 6);
go

select * from [Books].[Items] WHERE ISBN = 60
