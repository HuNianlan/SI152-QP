*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 6                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets     
    i    /1*5/
    j    /1*10/
    alias(j,k);

Parameters
    b(i)
    /1    -4 
     2    22
     3    -6
     4   -23
     5   -12/
    c(j)
    /1    48
     2    42
     3    48
     4    45
     5    44
     6    41
     7    47
     8    42
     9    45
    10    46/
    A(i,j)
    Q(j,k);

Table A(i,j)
    1     2     3     4     5     6     7     8     9    10
1  -2    -6    -1     0    -3    -3    -2    -6    -2    -2
2   6    -5     8    -3     0     1     3     8     9    -3
3  -5     6     5     3     8    -8     9     2     0    -9
4   9     5     0    -9     1    -8     3    -9    -9    -3
5  -8     7    -4    -5    -9     1    -7    -1     3    -2;

loop(j, loop(k, Q(j,k) = 100 $ (ord(j) eq ord(k))));

Variables
    x(j)
    f;

Loop(j, 
    x.lo(j) = 0;
    x.up(j) = 1);

Equations
    Obj    objective function
    Con(i) constraint functions;

Obj .. 
    f =e= sum(j, c(j)*x(j)) - 0.5*sum(j, x(j)*sum(k, Q(j,k)*x(k)));

Con(i) ..
    sum(j, A(i,j)*x(j)) =l= b(i);

Model
    problem /Obj, Con/;

    x.l('1') = 1;
    x.l('2') = 0;
    x.l('3') = 0;
    x.l('4') = 1;
    x.l('5') = 1;
    x.l('6') = 1;
    x.l('7') = 0;
    x.l('8') = 1;
    x.l('9') = 1;
    x.l('10') = 1;

    solve problem using nlp minimizing f;
    PUT "Min f",f.l:16:10//;
    Loop(j, PUT "x   ",x.l(j):16:10//);

