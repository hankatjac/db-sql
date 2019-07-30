/* 
Purpose: bulk insert data
Script Date: April 07 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher 
*/

use WMLibrary
go

/*Bulk insert data into Sales.Customers table */


bulk insert Persons.Members
from 'D:\member_data.txt'
with
(
	FirstRow = 1,
	RowTerminator = '\n',
	FieldTerminator = '\t'
);
go


select * from Persons.Members;
go

--dbcc checkident('Persons.Members', reseed,0);
--go


bulk insert Persons.Adults
from 'D:\adult_data.txt'
with
(
	FirstRow = 1,
	RowTerminator = '\n',
	FieldTerminator = '\t'
);
go

select * from Persons.Adults;
go


bulk insert Persons.Juniors
from 'D:\juvenile_data.txt'
with
(
	FirstRow = 1,
	RowTerminator = '\n',
	FieldTerminator = '\t'
);
go

select * from Persons.Juniors;
go

bulk insert Books.Titles
from 'D:\title_data.txt'
with
(
	FirstRow = 1,
	RowTerminator = '\n',
	FieldTerminator = '\t'
);
go

select * from Books.Titles;
go



bulk insert Books.Copies
from 'D:\Rita\Johnabbott study\rita\DB\populate Library database\copy_data.txt'
with
(
	FirstRow = 1,
	RowTerminator = '\n',
	FieldTerminator = '\t'
);
go

select * from Books.Copies;
go


bulk insert Records.LoanHist
from 'D:\loanhist_data.txt'
with
(
	FirstRow = 1,
	RowTerminator = '\n',
	FieldTerminator = '\t'
);
go


select * from Records.LoanHist;
go


bulk insert books.items
from 'D:\item_data.txt'
with
(
	FirstRow =1,
	RowTerminator ='\n',
	FieldTerminator = '\t'
);
go

select * from books.items;
go

bulk insert Records.Reservations
from 'D:\reservation_data.txt'
with
(
	FirstRow = 1,
	RowTerminator ='\n',
	FieldTerminator = '\t'
);
go


select * from Records.Reservations;
go

bulk insert Records.loans
from 'D:\loan_data.txt'
with
(
	FirstRow = 1,
	RowTerminator ='\n',
	FieldTerminator = '\t'
);
go


select * from Records.loans;
go
