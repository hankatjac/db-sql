/* 
Purpose Create My WMLbrary Database Tables
Script Date: April 04 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher 
*/

use WMLibrary;
go


/* Creates table for Person.Members */

drop table if exists Persons.Members;
go

create table Persons.Members
(
	MemberID int not null,
	LastName myLastName,
	FirstName myFirstName,
	MiddleInital char(1) null,
	photograph varchar(max) null
	constraint pk_Members primary key clustered (MemberID asc)
);
go


/* Creates table for Person.Adults */
drop table if exists Persons.Adults;
go

create table Persons.Adults
(
	MemberID int not null,
	Address myAddress,
	City myCity,
	State myState,
	Zip myZip,
	PhoneNo myPhone,
	--JoinDate date not null,
	ExprDate date not null,
	-- DateOfBirth date not null
	constraint pk_Adults primary key clustered (MemberID asc)
);
go



/* Creates table for Person.Juniors */
drop table if exists Persons.Juniors;
go

create table Persons.Juniors
(
	MemberID int not null,
	AdultMemberID int not null,
	DateOfBirth date not null,
	constraint pk_Juniors primary key clustered (MemberID asc)
);
go

/* Creates table for Records.Reservations */
drop table if exists Records.Reservations;
go

create table Records.Reservations
(
	ReservationID int not null,
	ISBN int not null,
	MemberID int not null, 
	Log_Date date not null, 
	Remarks varchar(300)
	constraint pk_Reservations primary key clustered (ReservationID)
)
;
go


/* Creates table for Records.Loans */
drop table if exists Records.Loans;
go


create table Records.Loans
(
	LoanID int not null,
	ISBN int not null,
	CopyID int not null,
	titleID int not null,
	MemberID int not null, 
	Out_Date date not null,
	Due_Date date not null,
	constraint pk_Loans primary key clustered (LoanID asc)

);;
go

/* Creates table for Records.LoansHist */
drop table if exists Records.LoanHist;
go

create table Records.LoanHist
(
	LoanHistID int not null,
	ISBN int not null,
	CopyID int not null,
	Out_Date date not null,
	titleID int not null,
	MemberID int not null, 
	Due_Date date not null,
	In_Date date not null, 
	Fine_Assessed decimal(6,2) null,
	Fine_Paid decimal(6,2) null,
	Fine_Waived decimal(6,2) null,
	remarks nvarchar(40) null
	constraint pk_LoansHist primary key clustered (LoanHistID asc)
);
go


/* Creates table for Books.Titles */
drop table if exists Books.Titles;
go

create table Books.Titles
(
	TitleID int not null,
	Title varchar(80) not null,
	Author varchar(30) not null,
	Synopsis varchar(max) not null
	constraint pk_Titles primary key clustered (TitleID asc)
);
go

/* Creates table for Books.Items */
drop table if exists Books.Items;
go

create table Books.Items
(
	ItemID int not null,
	ISBN int not null,
	TitleID int not null,
	Language varchar(30) not null,
	Cover varchar(15) not null,
	Loanable bit not null,
	constraint pk_Items primary key clustered (ItemID asc)
);
go


/* Creates table for Books.Copies */
drop table if exists Books.Copies;
go

create table Books.Copies
(
	ISBN int not null,
	CopyID int not null,
	TitleID int not null,
	On_Loan bit not null
	constraint pk_Copies primary key clustered (CopyID asc,ISBN asc)
);
go