# SI152-QP
Final project for SI152 2024 Fall
Team member: Xinyue Hu, Sihan Zhuang & Shenghan Gao

## Code
### Implementation
We implement the QP-solver based on IRWA and ADMM algorithm with input para(A1,A2,b1,b2,g,H)
where $$A_1x+b_1=0\\A_2x+b_2=0$$
the code for each algorithm is written in
- IRWA: `IRWA_QP_scaling.m`
- ADMM: `ADMM_QP.m`

Other helper function: **Please put them in the environment at runtime**
- `conjgrad.m`
- `Pc.m`
- `standard_constraints`: to meet the osqp api for comparison

### Test
`test.mlx` provide
- a random test case generation based on `generate_random_qp.m`
- if you want to compare our result with the osqp solver, **please make sure you have osqp in your environment**.

## Doc
胡馨月_庄思涵_高圣涵_SI152_report.pdf

## More Details
https://github.com/HuNianlan/SI152-QP
