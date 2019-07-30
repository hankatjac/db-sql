/* 
create user defined Trigger
Script Date: March 29, 2019
Developed by: Hang
*/

use WMLibrary;
go 


--trigger 1. display a message when anyone  adds or modify the data in the customers table 
DROP TRIGGER IF EXISTS Records.NotifyReservationsTr;
go

create trigger Records.NotifyReservationsTr
on Records.Reservations
after insert, update, delete
as
	raiserror ('Reservation table was modified', 10, 1) 
;
go

--------------------------------------------------------------------------------------------------
--TRIGGER2: create trigger to check a member reserved more than 4 books when insert a member data in table reservation

DROP TRIGGER IF EXISTS Records.checkMemberLoanTr;
go


create trigger Records.checkMemberLoanTr
on  Records.Reservations 
for insert
as
	begin
		-- declare variable
		declare 
		@MemberID as int,
		@ReservationID  as int,
		@ISBN as int	
		select @MemberID = MemberID, @ReservationID = ReservationID, @ISBN = ISBN from inserted
		-- making decision
		if 
			(
				select count(*) 
				from Records.Reservations 
				where MemberID = @MemberID
			)  > 4

			begin
				raiserror ('This member has reserved more than 4 books. He(she) cannot loan more.', 10, 1)
				delete from Records.Reservations where ReservationID=@ReservationID
			end

		else
			if 
			(
				select count(CopyID)
				from Books.Copies
				where ISBN = @ISBN
				and
				On_Loan = 0
			)   = 0

				begin
					raiserror ('This book is on loan.', 10, 1)
					delete from Records.Reservations where ReservationID=@ReservationID
				end
	end
;
go

-- test trigger Records.checkMemberLoanTr
select * from Records.Reservations;
go

select * from Books.Copies
where ISBN = 5
;
go

update books.copies
set On_Loan = 1
where ISBN = 5
;
go

insert into Records.Reservations
values (2161, 5, 9963, '2008-01-05 23:18:00.000', NULL)
;
go

delete from Records.Reservations
where ReservationID = 2161
;
go

---------------------------------------------------------------------------------------
--Trigger3: create trigger to change loanable status in item table when all the copies are not available for loan
DROP TRIGGER IF EXISTS Books.LoanableStatusTr;
go


Create trigger Books.LoanableStatusTr
on  Books.Copies
after insert, update, delete
as
	begin	
	if update(On_Loan) 
		begin
			update Books.Items
			set Loanable = 0 
			where ISBN in
			(
				select ISBN
				from Books.Copies 
				where On_Loan = 0
				group by ISBN
				having count(CopyID) = 0
			)
		end
	end
;
go

-------------------------------------------------------------------------------------------
--Trigger4: create trigger to check a member can renew books not more than 2 times
DROP TRIGGER IF EXISTS Records.checkRenewTr;
go

create trigger Records.checkRenewTr
on  Records.Loans
for insert,update, delete
as
	begin
		if update(Due_Date) 
		begin
		-- making decision
			select Due_Date, Out_Date
			from Records.Loans 
			where DATEDIFF(DAY, Due_Date, Out_Date) > 28
			begin
				raiserror ('This member has renewed 2 times. He(she) cannot renew again.', 10, 1)
			end
		end
	end
;
go

