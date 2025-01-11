*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 4                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets     
    i    /1*5/
    j    /1*6/;

Parameters
    b(i)
    /1    16 
     2    -1
     3    24
     4    12
     5     3/
    A(i,j);

Table A(i,j)
    1     2     3     4     5     6
1   1     2     8     1     3     5
2  -8    -4    -2     2     4    -1
3   2    0.5   0.2   -3    -1    -4
4  0.2    2    0.1   -4     2     2
5 -0.1  -0.5    2     5    -5     3;

Variables
    z(j)
    f;

Loop(j, z.lo(j) = 0);
z.up('1') = 1;
z.up('4') = 1;
z.up('5') = 1;
z.up('6') = 2;

Equations
    Obj    objective function
    Con(i) constraint functions;

Obj .. 
    f =e= 6.5*z('1') - 0.5*z('1')*z('1') - z('2') - 2*z('3') - 3*z('4') - 2*z('5') - z('6');

Con(i) ..
    sum(j, A(i,j)*z(j)) =l= b(i);

Model
    problem /Obj, Con/;

    z.l('1') = 0;
    z.l('2') = 6;
    z.l('3') = 0;
    z.l('4') = 1;
    z.l('5') = 1;
    z.l('6') = 0;

    solve problem using nlp minimizing f;
    PUT "Min f",f.l:16:10//;
    Loop(j, PUT "z   ",z.l(j):16:10//);
