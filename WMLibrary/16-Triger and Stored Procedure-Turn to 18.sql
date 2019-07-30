/* Using Trigger and Stored Procedure to transfer junior who turns to 18 to the adults table. 
Script Date: April 07 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher */

use WMLibrary;
go

UPDATE [Persons].[Juniors]
SET [DateOfBirth]= '2001-04-11' where MemberID=102;
go


INSERT INTO [Persons].[Members]([MemberID], [LastName],[FirstName])
values ('99999','aa','bb');
go

INSERT INTO [Persons].[Juniors]([MemberID], [AdultMemberID], [DateOfBirth])
values ('99999','9998','2001-04-11');
go

select ExprDate from [Persons].[Adults] where MemberID=9998

if OBJECT_ID('Persons.AgeTurnTo18SP', 'p') is not null
	drop PROCEDURE Persons.AgeTurnTo18SP
;
go
--PROCEDURE Persons.AgeTurnTo18SP is to check this member's age is greater than 18 or not.
create PROCEDURE Persons.AgeTurnTo18SP  
(
	 @MemberID int,
     @ISBN int = 2,
     @CopyID int = 4 
)
AS
BEGIN

    BEGIN TRY
	    BEGIN TRANSACTION;
		declare
		@Birthday as date
		set @Birthday = (select [DateOfBirth]
		from [Persons].[Juniors]
		where [MemberID] = @MemberID);

		-- Null means this member is not Juniors.
		IF (( @Birthday is not null) AND  (DATEDIFF(YEAR,@Birthday, GETDATE()) >= 18) AND (MONTH(GETDATE())>= MONTH(@Birthday)))
			BEGIN
			print 'Start'
			-- Insert juniors to adult table
			begin
			INSERT INTO [Persons].[Adults]([MemberID],[Address],[City],[State], [Zip], [ExprDate])
			SELECT J.[MemberID],A.[Address],A.[City],A.[State], A.[Zip], A.[ExprDate]
			FROM [Persons].[Juniors] AS J 
			INNER JOIN [Persons].[Adults] AS A
			ON A.[MemberID] = J.[AdultMemberID]
			where J.MemberID =@MemberID;
			print 'Insert successfully!'
			end

			--Delete juniors from junior table
			DELETE FROM [Persons].[Juniors] where [MemberID]=@MemberID;
			print 'This record has been transfered successfully!'
			END

        COMMIT
    END TRY
    BEGIN CATCH
            ROLLBACK
    END CATCH
END;
GO


execute Persons.AgeTurnTo18SP 99999,1,1
GO

select * from [Persons].[Juniors] order by MemberID;
go
select * from [Persons].[Adults] order by MemberID;
go

select MONTH('2001-04-11');
select * from [Records].[Loans] where memberID =1096;
go

delete from [Persons].[Adults] where memberID =99999;


--TRIGGER Records.AgeTurnTo18Tr is for firing the stored procedure 
--Persons.AgeTurnTo18SP when this member borrow or return books.

if OBJECT_ID('Records.AgeTurnTo18Tr', 'Tr') is not null
	drop Trigger Records.AgeTurnTo18Tr
;
go

CREATE TRIGGER Records.AgeTurnTo18Tr
ON  [Records].[Loans] 
AFTER INSERT, DELETE, UPDATE
AS
    declare
	 @MemberID as int,
	 @ISBN as int,
     @CopyID as int
begin
	Select  @MemberID=MemberID, @ISBN=ISBN, @CopyID=CopyID  From Inserted
	EXEC Persons.AgeTurnTo18SP @MemberID, @ISBN, @CopyID
end;


SELECT [ExprDate] FROM [Persons].[Adults] as A
			inner join [Persons].[Juniors] as J
			on J.AdultMemberID = A.MemberID
			WHERE J.[MemberID] =  99999 or A.MemberID =99999
