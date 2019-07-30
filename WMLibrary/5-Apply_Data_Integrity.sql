/* 
Purpose: apply data integrity
Script Date: April 04 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher 
*/

use WMLibrary;
go



/**** Add Constraints for Persons.Adults ****/

-- Foreign key constraints
alter table Persons.Adults
	add constraint fk_Adults_Members foreign key (MemberID) references Persons.Members(MemberID)
;
go

-- default constraints
alter table Persons.Adults
	add constraint df_State default 'WA' for state
;
go

alter table Persons.Adults
	add constraint df_Phone default null for phoneNo
;
go

/**** Add Constraints for Persons.Juniors ****/

-- Foreign key constraints
alter table Persons.Juniors
	add constraint fk_Members_Juniors foreign key (MemberID) references Persons.Members(MemberID)
;
go

alter table Persons.Juniors
	add constraint fk_Adults_Juniors foreign key (AdultMemberID) references Persons.Adults(MemberID)
;
go

/**** Add Constraints for Books.Titles ****/

/**** Add Constraints for Books.Items ****/
-- create unique constraints
alter table Books.Items
	add constraint uq_Items_ISBN unique (ISBN)
;
go

-- Foreign key constraints
alter table Books.Items
	add constraint fk_Items_Titles foreign key (TitleID) references Books.Titles(TitleID)
;
go

/**** Add Constraints for Books.Copies ****/

-- Foreign key constraints

alter table Books.Copies
	add constraint fk_Copies_Items_ISBN foreign key (ISBN) references Books.Items(ISBN)
;
go

alter table Books.Copies
	add constraint fk_Copies_Titles foreign key (TitleID) references Books.Titles(TitleID)
;
go

/**** Add Constraints for Records.Resrvations ****/
-- Foreign key constraints

alter table Records.Reservations
	add constraint fk_Reservations_Items_ISBN foreign key (ISBN) references Books.Items(ISBN)
;
go


alter table Records.Reservations
	add constraint fk_Reservations_Members foreign key (MemberID) references Persons.Members(MemberID)
;
go

/**** Add Constraints for Records.Loans ****/

-- Foreign key constraints

alter table Records.Loans
	add constraint fk_Members_Loans foreign key (MemberID) references Persons.Members(MemberID)
;
go

alter table Records.Loans
	add constraint fk_Loans_Copies foreign key (CopyID, ISBN) references Books.Copies(CopyID,ISBN)
;
go

alter table Records.Loans
	add constraint fk_Loans_Titles foreign key (TitleID) references Books.Titles(TitleID)
go

-- check constraints 
alter table Records.Loans
	add constraint ck_Out_Date_Due_Date check (Out_Date<Due_Date)
;
go

-- create unique constraints
alter table Records.Loans
	add constraint uq_Loans_ISBN_CopyID unique (ISBN, CopyID)


/**** Add Constraints for Records.LoanHist ****/


-- Foreign key constraints

alter table Records.LoanHist
	add constraint fk_LoanHist_Copies foreign key (CopyID, ISBN) references Books.Copies(CopyID, ISBN)
;
go

alter table Records.LoanHist
	add constraint fk_LoanHist_Titles foreign key (TitleID) references Books.Titles(TitleID)
;
go

alter table Records.LoanHist
	add constraint fk_LoanHist_Members foreign key (MemberID) references Persons.Members(MemberID)
;
go

