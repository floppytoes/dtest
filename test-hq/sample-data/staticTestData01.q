jtable:([]k1:();k2:())
`jtable insert (1,2)
`jtable insert (1,4)
`jtable insert (1,3)
`jtable insert (1,4)
`jtable insert (1,6)
`jtable insert (2,7)
`jtable insert (2,9)
`jtable insert (5,8)

ktable:([k1:();k2:()];col1:();col2:())
`ktable insert (1, 2, 10, 20)
`ktable insert (1, 4, 10, 40)
`ktable insert (3, 3, 10, 30)
`ktable insert (1, 21, 11, 40)
`ktable insert (3, 2, 11, 50)
`ktable insert (11, 2, 11, 60)

mytable:([]k1:();k2:())
`mytable insert (2,4)
`mytable insert (3,9)
`mytable insert (4,16)
`mytable insert (5,25)


x1:([name:()];personality:(); tested:())
`x1 insert(`$"abe";`$"innane";1)
`x1 insert(`$"brian";`$"silly";1)
`x1 insert(`$"carl";`$"silly";2)
`x1 insert(`$"dara";`$"dumb";1)
`x1 insert(`$"emily";`$"innane";3)
`x1 insert(`$"ingrid";`$"silly";3)
`x1 insert(`$"phoebe";`$"silly";3)
"rows in x1: ", string count x1


x2:([name:()]parent:();rating:())
`x2 insert(`$"abe";`$"xavier";3)
`x2 insert(`$"brian";`$"zoey";1)
`x2 insert(`$"carl";`$"zoey";2)
`x2 insert(`$"dara";`$"yvonne";3)
`x2 insert(`$"emily";`$"wyatt";3)
`x2 insert(`$"frank";`$"zoey";3)
"rows in x2: ", string count x2


x3:([]name:();pet:();rating:())
`x3 insert(`$"abe";`$"mouse";1)
`x3 insert(`$"brian";`$"lizard";1)
`x3 insert(`$"brian";`$"cat";3)
`x3 insert(`$"carl";`$"mouse";2)
`x3 insert(`$"dara";`$"lizard";2)
`x3 insert(`$"dara";`$"moose";2)
`x3 insert(`$"emily";`$"dog";3)
"rows in x3: ", string count x3


x4:([name:();pet:()]rating:())
`x4 insert(`$"abe";`$"mouse";1)
`x4 insert(`$"brian";`$"lizard";1)
`x4 insert(`$"brian";`$"cat";3)
`x4 insert(`$"carl";`$"mouse";2)
`x4 insert(`$"dara";`$"lizard";2)
`x4 insert(`$"dara";`$"moose";2)
`x4 insert(`$"emily";`$"dog";3)
"rows in x4: ", string count x4

author:([author:`king`hemingway`flaubert`lazere`shasha] address: `maine`expat`france`mamaroneck`newyork; area: `horror`suffering`psychology`journalism`puzzles)

book:([book:`forwhomthebelltolls`oldmanandthesea`shining`secretwindow`clouds`madambovary`salambo`outoftheirminds] language: `english`english`english`english`english`french`french`english; numprintings: 3 5 4 2 2 8 9 2)

bookauthor:([] author:`author$`hemingway`hemingway`king`king`king`flaubert`flaubert`shasha`lazere;  book:`book$`forwhomthebelltolls`oldmanandthesea`shining`secretwindow`clouds`madambovary`salambo`outoftheirminds`outoftheirminds; numfansinmillions: 20 20 50 50 30 60 30 2 2) 



aaa:([]x:0#0Ni;y:0#0Nj)
bbb:([]x:0#0Nj;y:0#0Ni)
`aaa insert(2;16)
`aaa insert(5;25)
`aaa insert(7;49)
`bbb insert(5;125)
`bbb insert(4;16)


