*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 1                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets
    i    /1*5/
    alias(i,j);

Parameters
    c(i)
    /1    42 
     2    44 
     3    45 
     4    47 
     5    47.5/
    Q(i,j);

loop(i, loop(j, Q(i,j) = 100 $ (ord(i) eq ord(j))));

Variables
    x(i)
    f;

loop(i, 
    x.lo(i) = 0;
    x.up(i) = 1);

Equations
    Obj    objective function
    Con    constraint function;

Obj .. 
    f =e= sum(i, c(i)*x(i)) - 0.5*sum(i, x(i)*sum(j, Q(i,j)*x(j)));

Con ..
    20*x('1') + 12*x('2') + 11*x('3') + 7*x('4') + 4*x('5') - 40 =l= 0;

Model
    problem /Obj, Con/;

    x.l('1') = 1;
    x.l('2') = 1;
    x.l('3') = 0;
    x.l('4') = 1;
    x.l('5') = 0;

    solve problem using nlp minimizing f;
    PUT "Min f",f.l:16:10//;
    Loop(i, PUT "x   ",x.l(i):16:10//);
