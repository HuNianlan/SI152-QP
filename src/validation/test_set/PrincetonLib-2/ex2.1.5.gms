*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 5                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets     
    i    /1*11/
    j    /1*10/
    alias(j,k);

Parameters
    b(i)
    /1    -4 
     2    22
     3    -6
     4   -23
     5   -12
     6    -3
     7     1
     8    12
     9    15
    10     9
    11    -1/
    cd(j)
    /1   -20
     2   -80
     3   -20
     4   -50
     5   -60
     6   -90
     7     0
     8    10
     9    10
    10    10/
    A(i,j)
    Q(j,k);

Table A(i,j)
    1     2     3     4     5     6     7     8     9    10
1  -2    -6    -1     0    -3    -3    -2    -6    -2    -2
2   6    -5     8    -3     0     1     3     8     9    -3
3  -5     6     5     3     8    -8     9     2     0    -9
4   9     5     0    -9     1    -8     3    -9    -9    -3
5  -8     7    -4    -5    -9     1    -7    -1     3    -2
6  -7    -5    -2     0    -6    -6    -7    -6     7     7
7   1    -3    -3    -4    -1     0    -4     1     6     0
8   1    -2     6     9     0    -7     9    -9    -6     4
9  -4     6     7     2     2     0     6     6    -7     4
10  1     1     1     1     1     1     1     1     1     1
11 -1    -1    -1    -1    -1    -1    -1    -1    -1    -1;

loop(j, loop(k, Q(j,k) = 10 $ ((ord(j) eq ord(k)) and (ord(j) le 7))));

Variables
    z(j)
    f;

Loop(j, 
    z.lo(j) = 0;
    z.up(j) = 1);

Equations
    Obj    objective function
    Con(i) constraint functions;

Obj .. 
    f =e= sum(j, cd(j)*z(j)) - 0.5*sum(j $ (ord(j) le 7), z(j)*sum(k $ (ord(k) le 7), Q(j,k)*z(k)));

Con(i) ..
    sum(j, A(i,j)*z(j)) =l= b(i);

Model
    problem /Obj, Con/;

    z.l('1') = 1;
    z.l('2') = 0.90755;
    z.l('3') = 0;
    z.l('4') = 1;
    z.l('5') = 0.71509;
    z.l('6') = 1;
    z.l('7') = 0;
    z.l('8') = 0.91698;
    z.l('9') = 1;
    z.l('10') = 1;

    solve problem using nlp minimizing f;
    PUT "Min f",f.l:16:10//;
    Loop(j, PUT "z   ",z.l(j):16:10//);
