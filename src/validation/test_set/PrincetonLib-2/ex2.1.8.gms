*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 8                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets     
    i    /1*6/
    j    /1*4/;

Parameters
    a(i)
    /1     8 
     2    24
     3    20
     4    24
     5    16
     6    12/
    b(j)
    /1    29 
     2    41
     3    13
     4    21/
    C(i,j)
    D(i,j);

Table C(i,j)
    1     2     3     4
1  300   270   460   800
2  740   600   540   380
3  300   490   380   760
4  430   250   390   600
5  210   830   470   680
6  360   290   400   310;

Table D(i,j)
    1     2     3     4
1  -7    -4    -6    -8
2 -12    -9   -14    -7 
3 -13   -12    -8    -4
4  -7    -9   -16    -8
5  -4   -10   -21   -13
6 -17    -9    -8    -4;


Variables
    x(i,j)
    f;

Loop(i, Loop(j, 
    x.lo(i,j) = 0;
    x.up(i,j) = 100));

Equations
    Obj     objective function
    Cona(i) constraint functions
    Conb(j) constraint functions;

Obj .. 
    f =e= sum(i, sum(j, C(i,j)*x(i,j) + D(i,j)*x(i,j)*x(i,j))); 

Cona(i) ..
    sum(j, x(i,j)) =e= a(i);

Conb(j) ..
    sum(i, x(i,j)) =e= b(j);

Model
    problem /Obj, Cona, Conb/;

    Loop(i, Loop(j, x.l(i,j) = 0));
    x.l('1','1') = 6;
    x.l('1','2') = 2;
    x.l('2','2') = 3;
    x.l('2','4') = 21;
    x.l('3','1') = 20;
    x.l('4','1') = 24;
    x.l('5','1') = 3;
    x.l('5','3') = 13;
    x.l('6','2') = 12;

    solve problem using nlp minimizing f;
    PUT "Min f",f.l:16:10//;
    Loop(i, Loop(j, PUT "x   ",x.l(i,j):16:10//));

