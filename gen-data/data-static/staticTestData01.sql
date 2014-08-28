drop table jtable;
create table jtable
    (
    ordcol  bigint,
    k1      bigint,
    k2      bigint
    );

insert into jtable values
    (1, 1, 2),
    (2, 1, 4),
    (3, 1, 3),
    (4, 1, 4),
    (5, 1, 6),
    (6, 2, 7),
    (7, 2, 9),
    (8, 5, 8);


drop table ktable;
create table ktable
    (
    ordcol  bigint,
    k1      bigint,
    k2      bigint,
    col1    bigint,
    col2    bigint
    );
-- grant select on ktable to public;
--drop index ktable_keys;
create index ktable_keys on ktable(k1, k2);
insert into ktable values
    (1, 1, 2, 10, 20),
    (2, 1, 4, 10, 40),
    (3, 3, 3, 10, 30),
    (4, 1, 21, 11, 40),
    (5, 3, 2, 11, 50),
    (6, 11, 2, 11, 60);



drop table mytable;
create table mytable
    (
    ordcol  bigint,
    k1      bigint,
    k2      bigint
    );

insert into mytable values
    (1, 2,4),
    (2, 3,9),
    (3, 4,16),
    (4, 5,25);



drop table x1;
create table x1(ordcol bigint,name varchar,personality varchar,tested bigint);
insert into x1(ordcol,name,personality,tested) values 
(1,'abe','innane',1),
(2,'brian','silly',1),
(3,'carl','silly',2),
(4,'dara','dumb',1),
(5,'emily','innane',3),
(6,'ingrid','silly',3),
(7,'phoebe','silly',3);
--drop index x1_keys;
create index x1_keys on x1(name);

drop table x2;
create table x2(ordcol bigint,name varchar,parent varchar,rating bigint);
insert into x2(ordcol,name,parent,rating) values 
(1,'abe','xavier',3),
(2,'brian','zoey',1),
(3,'carl','zoey',2),
(4,'dara','yvonne',3),
(5,'emily','wyatt',3),
(6,'frank','zoey',3);
--drop index x2_keys;
create index x2_keys on x2(name);


drop table x3;
create table x3(ordcol bigint,name varchar,pet varchar,rating bigint);
insert into x3(ordcol,name,pet,rating) values 
(1,'abe','mouse',1),
(2,'brian','lizard',1),
(3,'brian','cat',3),
(4,'carl','mouse',2),
(5,'dara','lizard',2),
(6,'dara','moose',2),
(7,'emily','dog',3);


drop table x4;
create table x4(ordcol bigint,name varchar,pet varchar,rating bigint);
insert into x4(ordcol,name,pet,rating) values 
(1,'abe','mouse',1),
(2,'brian','lizard',1),
(3,'brian','cat',3),
(4,'carl','mouse',2),
(5,'dara','lizard',2),
(6,'dara','moose',2),
(7,'emily','dog',3);
--drop index x4_keys;
create index x4_keys on x4(name, pet, rating);




drop table author;
create table author
	(
		ordcol			bigint,
		author			varchar,
		address			varchar,
		area        varchar
	);
insert into author values
	(1, 'king',			'maine',			'horror'),    
	(2, 'hemingway','expat',			'suffering'),
	(3, 'flaubert',	'france',			'psychology'),
	(4, 'lazere',		'mamaroneck',	'journalism'),
	(5, 'shasha',		'newyork',		'puzzles');   


drop table book;
create table book  
	(  	
	ordcol				bigint,
	book					varchar,
	language 			varchar,
	numprintings  bigint
	);
insert into book values 
	(1,'forwhomthebelltolls',	'english',3),
	(2,'oldmanandthesea',			'english',5),         
	(3,'shining',							'english',4),        
	(4,'secretwindow',				'english',2),	
	(5,'clouds',							'english',2),
	(6,'madambovary',					'french' ,8),           
	(7,'salambo',							'french' ,9),           
	(8,'outoftheirminds',			'english',2);

--drop index book_keys;
create index book_keys on book(book);


drop table bookauthor;
create table bookauthor
	(
	ordcol						 bigint,
	author             varchar,
	book               varchar,
	numfansinmillions  bigint
	);
--drop index bookauthor_keys;
--create index bookauthor_keys on bookauthor(author,book);
insert into bookauthor values
	(1,'hemingway','forwhomthebelltolls',20),
	(2,'hemingway','oldmanandthesea',20),
	(3,'king','shining',50),
	(4,'king','secretwindow',50),
	(5,'king','clouds',30),
	(6,'flaubert','madambovary',60),
	(7,'flaubert','salambo',30),
	(8,'shasha','outoftheirminds',2),
	(9,'lazere','outoftheirminds',2);


drop table aaa;
create table aaa
	(
	ordcol				bigint,
	x             int,
	y             bigint
	);
insert into aaa values
	(1,2,16),
	(2,5,25),
	(3,7,49);

drop table bbb;
create table bbb
	(
	ordcol				bigint,
	x             bigint,
	y             int
	);
insert into bbb values
	(1,5,125),
	(2,4,16);



