/* 
Purpose: Create index
Script Date: April 08 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher 
*/

use WMLibrary;
go



SELECT * from Records.LoanHist;
go
-- create indexes for Persons.Members

create nonclustered index nci_LastName on Persons.Members(LastName);
go	



-- create indexes for Persons.Juniors

create nonclustered index nci_AdultMemberID on Persons.Juniors(AdultMemberID);
go
-- create indexes for Books.Titles


create nonclustered index nci_Title on Books.Titles(Title);
go

create nonclustered index nci_Author on Books.Titles(Author);
go

-- create indexes for Books.Items


create unique nonclustered index u_nci_ISBN on Books.Items(ISBN);
go


-- create indexes for Books.Copies
create nonclustered index nci_ISBN on Books.Copies(ISBN);
go

create nonclustered index nci_CopyID on Books.Copies(CopyID);
go

create nonclustered index nci_TitleID on Books.Copies(TitleID);
go

-- create indexes for Records.Reservations
create nonclustered index nci_ISBN on Records.Reservations(ISBN);
go

create nonclustered index nci_MemberID on Records.Reservations(MemberID);
go

create nonclustered index nci_LogDate on Records.Reservations(Log_Date);
go

-- create indexes for Records.Loans
create nonclustered index nci_ISBN on Records.Loans(ISBN);
go

create nonclustered index nci_CopyID on Records.Loans(CopyID);
go

create nonclustered index nci_TitleID on Records.Loans(TitleID);
go

create nonclustered index nci_MemberID on Records.Loans(MemberID);
go

create nonclustered index nci_OutDate on Records.Loans(Out_Date);
go

create nonclustered index nci_DueDate on Records.Loans(Due_Date);
go

-- create indexes for Records.LoanHist
create nonclustered index nci_ISBN on Records.LoanHist(ISBN);
go

create nonclustered index nci_CopyID on Records.LoanHist(CopyID);
go

create nonclustered index nci_OutDate on Records.LoanHist(Out_Date);
go

create nonclustered index nci_TitleID on Records.LoanHist(TitleID);
go

create nonclustered index nci_MemberID on Records.LoanHist(MemberID);
go

create nonclustered index nci_DueDate on Records.LoanHist(Due_Date);
go
