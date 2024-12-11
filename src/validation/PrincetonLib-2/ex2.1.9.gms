*--------------------------------------------------------------*
* Quadratic Programming - Test Problem 9                       *
*--------------------------------------------------------------*
File  
    res  / results / ;
Put res ;

Sets     
    i    /1*10/;

Variables
    x(i)
    f;

Loop(i, 
    x.lo(i) = 0);

Equations
    Obj  objective function
    Con  constraint functions;

Obj .. 
    f =e= sum(i $ (ord(i) le 9), x(i)*x(i+1)) 
        + sum(i $ (ord(i) le 8), x(i)*x(i+2))
        + x('1')*x('9') + x('1')*x('10') + x('2')*x('10') + x('1')*x('5') + x('4')*x('7');

Con ..
    sum(i, x(i)) =e= 1;

Model
    problem /Obj, Con/;

    x.l('1') = 0;
    x.l('2') = 0;
    x.l('3') = 0;
    x.l('4') = 0.25;
    x.l('5') = 0.25;
    x.l('6') = 0.25;
    x.l('7') = 0.25;
    x.l('8') = 0;
    x.l('9') = 0;
    x.l('10') = 0;

    solve problem using nlp maximizing f;
    PUT "Min f",f.l:16:10//;
    Loop(i, PUT "x   ",x.l(i):16:10//);
