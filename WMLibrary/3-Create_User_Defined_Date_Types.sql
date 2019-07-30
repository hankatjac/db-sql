/* Purpose Create My WMLbrary User Defined Data
Script Date: April 04 2019
Developed By: Aaron Graham, Wu Guo, Hang Ruan, Aleksander Uher */

use WMLibrary
go

create type myLastName
from varchar(30) not null;
go

create type myFirstName
from varchar(30) not null;
go

create type myAddress 
from varchar(40) not null;
go

create type myCity
from varchar(30) not null;
go

create type myState
from char(2) not null;
go

create type myPhone
from varchar(16) null;
go

create type myZip
from varchar (16) not null;
go