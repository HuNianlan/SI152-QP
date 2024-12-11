*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 7                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets     
    i    /1*10/
    j    /1*20/;

Parameters
    b(i)
    /1    -5 
     2     2
     3    -1
     4    -3
     5     5
     6     4
     7    -1
     8     0
     9     9
    10    40/
    A(i,j)
    lambda(j)
    alpha(j);

Table A(i,j)
    1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20
1  -3     7     0    -5     1     1     0     2    -1    -1    -9     3     5     0     0     1     7    -7    -4    -6
2   7     0    -5     1     1     0     2    -1    -1    -9     3     5     0     0     1     7    -7    -4    -6    -3
3   0    -5     1     1     0     2    -1    -1    -9     3     5     0     0     1     7    -7    -4    -6    -3     7
4  -5     1     1     0     2    -1    -1    -9     3     5     0     0     1     7    -7    -4    -6    -3     7     0
5   1     1     0     2    -1    -1    -9     3     5     0     0     1     7    -7    -4    -6    -3     7     0    -5
6   1     0     2    -1    -1    -9     3     5     0     0     1     7    -7    -4    -6    -3     7     0    -5     1
7   0     2    -1    -1    -9     3     5     0     0     1     7    -7    -4    -6    -3     7     0    -5     1     1
8   2    -1    -1    -9     3     5     0     0     1     7    -7    -4    -6    -3     7     0    -5     1     1     0
9  -1    -1    -9     3     5     0     0     1     7    -7    -4    -6    -3     7     0    -5     1     1     0     2
10  1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1;

Variables
    x(j)
    f;

Loop(j, 
    x.lo(j) = 0);

Equations
    Obj    objective function
    Con(i) constraint functions;

Obj .. 
    f =e= -0.5*sum(j, lambda(j)*power(x(j)-alpha(j),2));

Con(i) ..
    sum(j, A(i,j)*x(j)) =l= b(i);

*   For case 1
*Loop(j, 
*    lambda(j) = 1;
*    alpha(j) = 2);

*   For case 2
*Loop(j, 
*    lambda(j) = 1;
*    alpha(j) = -5);

*   For case 3
*Loop(j, 
*    lambda(j) = 20;
*    alpha(j) = 0);

*   For case 4
*Loop(j, 
*    lambda(j) = 1;
*    alpha(j) = 8);

*   For case 5
Loop(j, 
    lambda(j) = ord(j);
    alpha(j) = 2);

Model
    problem /Obj, Con/;

*   For cases 1,2,3,4
*    x.l('1') = 0;
*    x.l('2') = 0;
*    x.l('3') = 28.8024;
*    x.l('4') = 0;
*    x.l('5') = 0;
*    x.l('6') = 4.1792;
*    x.l('7') = 0;
*    x.l('8') = 0;
*    x.l('9') = 0;
*    x.l('10') = 0;
*    x.l('11') = 0;
*    x.l('12') = 0;
*    x.l('13') = 0;
*    x.l('14') = 0;
*    x.l('15') = 0.6188;
*    x.l('16') = 4.0933;
*    x.l('17') = 0;
*    x.l('18') = 2.3064;
*    x.l('19') = 0;
*    x.l('20') = 0;

*   For case 5
    x.l('1') = 0;
    x.l('2') = 0;
    x.l('3') = 1.04289;
    x.l('4') = 0;
    x.l('5') = 0;
    x.l('6') = 0;
    x.l('7') = 0;
    x.l('8') = 0;
    x.l('9') = 0;
    x.l('10') = 0;
    x.l('11') = 1.74674;
    x.l('12') = 0;
    x.l('13') = 0.43147;
    x.l('14') = 0;
    x.l('15') = 0;
    x.l('16') = 4.43305;
    x.l('17') = 0;
    x.l('18') = 15.85893;
    x.l('19') = 0;
    x.l('20') = 16.4889;

    solve problem using nlp minimizing f;
    PUT "Min f",f.l:16:10//;
    Loop(j, PUT "x   ",x.l(j):16:10//);


