# basics
select from x1
x1
count salespeople
count select from salespeople

# selects
select from salespeople where name=`frank
count select from salespeople where name=`frank
select from salespeople where name in`frank`bob

count select from salespeople where name in`frank`bob
select from salespeople where name in`frank
select from salespeople where name in`frank`bob,bonus>0
select from salespeople where name in`frank`bob,bonus >0
select from salespeople where name in`frank`bob,bonus> 0
select from salespeople where name in`frank`bob,bonus > 0
select from salespeople where name in`frank`bob, bonus>0
select from salespeople where name in`frank`bob,bonus>200
count select from salespeople where name in`frank`bob,bonus>200
select from salespeople where name in`frank,bonus>200
select from salespeople where name =`frank,bonus>200
select from salespeople where name=`frank,bonus<100
select from salespeople where name=`frank, bonus<100, bonus>0
select from salespeople where seniority>4,seniority<7
select from salespeople where seniority<7,seniority>4
select from salespeople where seniority>4,seniority>7
select from salespeople where seniority>7,seniority<4
select from salespeople where seniority>6,seniority>3,seniority<>11
select from salespeople where name=`frank,title=`am

# column ops
#select sum bonus from salespeople
select max bonus from salespeople
#select a:sum bonus from salespeople
select a:max bonus from salespeople
#select bonus:sum bonus from salespeople
select bonus:min bonus from salespeople
#select bonus:sum bonus, bonus1:max bonus from salespeople
#select sum bonus, max bonus from salespeople
#select a:sum bonus + max bonus from salespeople

# not expected to work yet:
#meta salespeople
#key exec title from salespeople
#key exec name from salespeople
#key exec seniority from salespeople
#key exec notes from salespeople

exec name from salespeople
#exec from salespeople
select name from salespeople where bonus >= 200,notes=`fff
exec name from salespeople where bonus >= 200,notes=`fff


#select distinct title from salespeople
count distinct salespeople
distinct salespeople
#select distinct name, x: sum bonus from salespeople
#select distinct name, x: sum bonus by name from salespeople
#select distinct name, x: sum bonus by title from salespeople
#select distinct name, title from salespeople 
#select distinct name by title from salespeople 
#select distinct title by name from salespeople 
#select distinct title from salespeople

select from salespeople where name=`frank,title=`am
select notes from salespeople where name=`frank,title=`am
select bonus from salespeople where name=`frank,title=`am
select bonus from salespeople where name=`frank

#select name, sum bonus from salespeople
#select name, a: sum bonus from salespeople
#select name by bonus from salespeople
#select bonus by name from salespeople
#select bonus: sum bonus by name from salespeople
#select bonus: sum bonus by title from salespeople
select bonus: count bonus by name from salespeople
#select name by bonus from salespeople
#select name, bonus by bonus from salespeople

select x: count bonus by name from salespeople where name=`emma
select x: count bonus by name from salespeople where name in `emma`hilary`bob
select x: count bonus by title from salespeople where name in `emma`hilary`bob
#select x: sum bonus by title from salespeople where name in `emma`hilary`bob
#select x: sum bonus by title from salespeople where name in `emma`hilary`bob, bonus < 100

#select bonus: sum bonus by name from salespeople where name in `emma`hilary`bob

select x: count bonus by name from salespeople where bonus > 100



jtable lj ktable

select from jtable lj ktable

##select from ktable lj jtable
###fails as expected

select col1 from jtable lj ktable
select col1,k1 from jtable lj ktable
select from jtable lj ktable where k1 > 2
select from jtable lj ktable where col2 > 20
select from jtable lj ktable where col2 > 20,col2<30

select from bookauthor
select numfansinmillions from bookauthor where book=`forwhomthebelltolls
#select author,book.language from bookauthor
#select author,book.language from bookauthor where numfansinmillions< 30
#select from bookauthor lj book

##select from book lj bookauthor 
##fails as expected - extra (())

select author,language from bookauthor lj book
#select author.author,language from bookauthor lj book
#select author,book.language from bookauthor lj book
#select author,book.language from bookauthor
select from bookauthor lj book where author=`king
#########select from bookauthor lj book where author in(`king,`lazere)
#########select from bookauthor lj book where author in(`bacon,`king,`lazere)

select from bookauthor lj book where author in(`king`lazere)

select from bookauthor lj book where author in(`king)
select from bookauthor lj book where author in`king`lazere
select from bookauthor lj book where author in(`lazere)
select from bookauthor lj book where language in(`french)
select from bookauthor lj book where language in(`english), author=`king
select from bookauthor lj book where language in(`english), author in(`king)
select from bookauthor lj book where (language=`french) or (author=`king)
select from bookauthor lj book where (language in(`french)) or (author in(`king))
#select by numprintings from bookauthor lj book where (language=`french) or (author=`king)
#select by author from bookauthor lj book
#select count author by author from bookauthor lj book

select books:count author by author from bookauthor lj book

#select books:count author, fans:sum numfansinmillions by author from bookauthor lj book

#select books:count author, sum numfansinmillions by author from bookauthor lj book

#select books:count author, fans:sum numfansinmillions by author from bookauthor lj book

select author,language from bookauthor lj book


jtable lj ktable
jtable ij ktable
select from jtable ij ktable where col2 > 20
(select from jtable where k1>1)  lj (select from ktable)
(select from jtable) lj (select from ktable)
select from jtable lj (select from ktable)
select from jtable lj select from ktable
select from jtable ij select from ktable


jtable lj ktable

select from jtable lj ktable

##select from ktable lj jtable
##fails as expected

select col1 from jtable lj ktable
select col1,k1 from jtable lj ktable
select from jtable lj ktable where k1 > 2
select from jtable lj ktable where col2 > 20
select from jtable lj ktable where col2 > 20,col2<30


### MISSING TABLES?  

#select name from x1 uj x2

select name from x1 lj x2




## both broke queries
##select personality,x2.parent from x1
##select x1.personality,x2.parent from x1

#x1 uj x2

#select name from x1 uj x2

#x1 uj x2


select from x1 lj x2



#select x1.personality,x2.parent from x1 join x2 using(name,name)
## both fail?



# minor issues?
select min k2 from jtable
select min k2 + k1 from jtable

#select k2 > k1 from jtable
#	known issue
#select k2 > 4 from jtable
# known issue

select z: k2 > 4 from jtable

`k2 xasc ktable
`k2`k1 xasc ktable

#`k1 xasc ktable
# ???

`k1`k2 xasc ktable


`k2`col2`k1 xasc ktable
`col2`k1 xasc ktable


#exec k2 from `k2 xasc ktable
# known bug

exec k2 from ktable


#exec k2 from `k2 xasc ktable
#known bug

#zoo: exec k2 from ktable
# need to do zoo h "exec k2 from ktable"

3#a
3# select from a where af2 > 99
#3# select from a where af2 > 99, af9=`peep
3# select from a where af2 > 83

#endendend    # if you want to end early

select count i from a
#select max i from a

2
#2+3
4





