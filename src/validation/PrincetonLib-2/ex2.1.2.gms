*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 2                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets
    i    /1*5/
    alias(i,j);

Scalars
    d     /-10/;

Parameters
    c(i)
    /1   -10.5 
     2    -7.5
     3    -3.5 
     4    -2.5
     5    -1.5/
    Q(i,j);

loop(i, loop(j, Q(i,j) = 1 $ (ord(i) eq ord(j))));

Variables
    x(i)
    y
    f;

loop(i, 
    x.lo(i) = 0;
    x.up(i) = 1);

y.lo = 0;

Equations
    Obj    objective function
    Con1   constraint function 1
    Con2   constraint function 2;

Obj .. 
    f =e= sum(i, c(i)*x(i)) - 0.5*sum(i, x(i)*sum(j, Q(i,j)*x(j))) + d*y;

Con1 ..
    6*x('1') + 3*x('2') + 3*x('3') + 2*x('4') + x('5') - 6.5 =l= 0;

Con2 ..
    10*x('1') + 10*x('3') + y - 20 =l= 0;

Model
    problem /Obj, Con1, Con2/;

    x.l('1') = 0;
    x.l('2') = 1;
    x.l('3') = 0;
    x.l('4') = 1;
    x.l('5') = 1;
    y.l = 20;
 
    solve problem using nlp minimizing f;
    PUT "Min f",f.l:16:10//;
    Loop(i, PUT "x   ",x.l(i):16:10//);
    PUT "y   ",y.l:16:10//;
