*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 3                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets
    i    /1*4/
    k    /1*9/
    alias(i,j);

Parameters
    c(i)
    /1    5 
     2    5 
     3    5 
     4    5/
    d(k)
    Q(i,j);

loop(i, loop(j, Q(i,j) = 10 $ (ord(i) eq ord(j))));

loop(k, d(k) = -1);

Variables
    x(i)
    y(k)
    f;

loop(i, 
    x.lo(i) = 0;
    x.up(i) = 1);

loop(k,
    y.lo(k) = 0);
loop(k $ ((ord(k) le 5) or (ord(k) eq 9)),
    y.up(k) = 1);

Equations
    Obj    objective function
    Con1   constraint function 1
    Con2   constraint function 2
    Con3   constraint function 3
    Con4   constraint function 4
    Con5   constraint function 5
    Con6   constraint function 6
    Con7   constraint function 7
    Con8   constraint function 8
    Con9   constraint function 9;

Obj .. 
    f =e= sum(i, c(i)*x(i)) - 0.5*sum(i, x(i)*sum(j, Q(i,j)*x(j))) + sum(k, d(k)*y(k));

Con1 ..
    2*x('1') + 2*x('2') + y('6') + y('7') =l= 10;

Con2 ..
    2*x('1') + 2*x('3') + y('6') + y('8') =l= 10;

Con3 ..
    2*x('2') + 2*x('3') + y('7') + y('8') =l= 10;

Con4 ..
    -8*x('1') + y('6') =l= 0;

Con5 ..
    -8*x('2') + y('7') =l= 0;

Con6 ..
    -8*x('3') + y('8') =l= 0;

Con7 ..
    -2*x('4') - y('1') + y('6') =l= 0;

Con8 ..
    -2*y('2') - y('3') + y('7') =l= 0;

Con9 ..
    -2*y('4') - y('5') + y('8') =l= 0;

Model
    problem /Obj, Con1, Con2, Con3, Con4, Con5, Con6, Con7, Con8, Con9/;

    loop(i, x.l(i) = 1);
    loop(k, y.l(k) = 1 + 2 $ ((ord(k) ge 6) and (ord(k) le 8)));

    solve problem using nlp minimizing f;
    PUT "Min f",f.l:16:10//;
    Loop(i, PUT "x   ",x.l(i):16:10//);
    Loop(k, PUT "y   ",y.l(k):16:10//);
