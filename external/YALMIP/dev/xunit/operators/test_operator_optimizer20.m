function test_operator_optimizer20

yalmip('clear')
sdpvar x y a b c
ops = sdpsettings('solver','cplex');
P = optimizer([0 <= [x y] <= 10, x + y <= exp(c)],(x-a)^2+5*(y-b)^2,ops,{a,b,c},[x y]);
sol = P{[c == log(5), a == 3, b == 4]}
mbg_asserttolequal(sol,[1 + 1/3;3 + 2/3]',1e-2);

ops = sdpsettings('solver','cplex');
P = optimizer([0 <= [x y] <= 10, x + y <= exp(c)],(x-a)^2+5*(y-b)^2,ops,{a,b,c},[x y]);
PC = P{[b == 4,c == log(5)]}
sol = PC{[a == 3]}
mbg_asserttolequal(sol,[1 + 1/3;3 + 2/3]',1e-2);

ops = sdpsettings('solver','cplex');
P = optimizer([0 <= [x y] <= 10, x + y <= exp(c)],(x-log(a))^2+5*(y-exp(b))^2,ops,{a,b,c},[x y]);
PC = P{[a == exp(3)]}
sol = PC{[c == log(5), b == log(4)]}
mbg_asserttolequal(sol,[1 + 1/3;3 + 2/3]',1e-2);

