# NAME

PDL::Opt::GLPK - PDL interface to the GNU Linear Programming Kit

# SYNOPSIS

    use PDL::Opt::GLPK;

    glpk($c, $a, $b $lb, $ub, $ctype, $vtype, GLP_MAX,
           $xopt = null, $fopt = null, $errno = null, $status = null, $lambda = null,
           $redcosts = null, \%params);

# EXAMPLE

This is an example from the GLPK documentation.

    Maximize
     obj: + 10 x_1 + 6 x_2 + 4 x_3

    Subject To
     r_1: + x_3 + x_2 + x_1 <= 100
     r_2: + 5 x_3 + 4 x_2 + 10 x_1 <= 600
     r_3: + 6 x_3 + 2 x_2 + 2 x_1 <= 300

Solving this using `glpk`:

```perl
use PDL::Opt::GLPK;

$a = pdl('[1 1 1] [10 4 5] [2 2 6]');
$b = pdl('[100 600 300]');
$c = pdl('[10 6 4]');
$lb = zeroes(3);
$ub = inf(3);
$ctype = GLP_UP * ones(3);
$vtype = GLP_CV * ones(3);

glpk($c, $a, $b $lb, $ub, $ctype, $vtype, GLP_MAX,
       $xopt = null, $fopt = null, $errno = null, $status = null,
       $lambda = null, $redcosts = null, {});
```
# DESCRIPTION

This module provides an interface to GLPK, the GNU Linear Programming
Kit.
The interface was ported from Octave and mimics its GLPK interface.

# FUNCTIONS

## glpk

    Signature (c(m); a(m, n); b(n); lb(m); ub(m); ctype(n); vtype(m);
           int sense; [o]xopt(m); [o]fopt(); [o]errno(); [o]status(); [o]lambda(n);
           [o]redcosts(n); SV *opts)

Solve a linear program using the GNU GLPK library.

The LP can be of the form

    [ min | max ] C'*x
    subject to

    A*x [ "=" | "<=" | ">=" ] b
      x >= LB
      x <= UB

The coeffient matrix `a` must be 2-d, though broadcasting over higher
dimensions is possible for other arguments.
See ["glpk\_bc"](#glpk_bc) for an alternative.

### Arguments

Input values:

- c

    A ndarray containing the objective function coefficients.

- a

    A ndarray containing the constraints coefficients.
    The coefficients may be given as a [PDL::CCS::Nd](https://metacpan.org/pod/PDL%3A%3ACCS%3A%3ANd) sparse matrix as
    well.

- b

    A ndarray containing the right-hand side value for each constraint
    in the constraint matrix.

- lb

    A ndarray containing the lower bound on each of the variables.

- ub

    A ndarray containing the upper bound on each of the variables.

- ctype

    A ndarray containing the sense of each constraint in the
    constraint matrix.
    Each element of the array may be one of the following
    values

    - 1 (GLP\_FR)

        A free (unbounded) constraint (the constraint is ignored).

    - 2 (GLP\_LO)

        An inequality with a lower bound.

    - 3 (GLP\_UP)

        An inequality constraint with an upper bound.

    - 4 (GLP\_DB)

        An inequality constraint with equal lower and upper bounds.

    - 5 (GLP\_FX)

        An equality constraint.

- vartype

    A ndarray containing the types of the variables.

    - 1 (GLP\_CV)

        A continuous variable.

    - 2 (GLP\_IV)

        An integer variable.

    - 3 (GLP\_BV)

        A binary variable.

- sense

    If sense is 1 (GLPX\_MIN), the problem is a minimization. If sense is -1
    (GLPX\_MAX), the problem is a maximization.

- param

    A hash reference with any of following keys used to define the behavior
    of solver. Missing keys take on default values, so you
    only need to set the values that you wish to change from the default.

    Integer parameters:

    - msglev (default: 1)

        Level of messages output by solver routines:

        - 0 (GLP\_MSG\_OFF)

            No output.

        - 1 (GLP\_MSG\_ERR)

            Error and warning messages only.

        - 2 (GLP\_MSG\_ON)

            Normal output.

        - 3 (GLP\_MSG\_ALL)

            Full output (includes informational messages).

        - 4 (GLP\_MSG\_DBG)

            Debug output.

    - scale (default: 16)

        Scaling option. The values can be combined with the bitwise
        OR operator and may be the following:

        - 1 (GLP\_SF\_GM)

            Geometric mean scaling.

        - 16 (GLP\_SF\_EQ)

            Equilibration scaling.

        - 32 (GLP\_SF\_2N)

            Round scale factors to power of two.

        - 64 (GLP\_SF\_SKIP)

            Skip if problem is well scaled.

        Alternatively, a value of 128 (GLP\_SF\_AUTO) may be also spec-
        ified, in which case the routine chooses the scaling options
        automatically.

    - dual (default: 1)

        Simplex method option:

        - 1 (GLP\_PRIMAL)

            Use two-phase primal simplex.

        - 2 (GLP\_DUALP)

            Use two-phase dual simplex, and if it fails, switch
            to the primal simplex.

        - 3 (GLP\_DUAL)

            Use two-phase dual simplex.

    - price (default: 34)

        Pricing option (for both primal and dual simplex):

        - 17 (GLP\_PT\_STD)

            Textbook pricing.

        - 34 (GLP\_PT\_PSE)

            Steepest edge pricing.

    - itlim (default: intmax)

        Simplex iterations limit. It is decreased by one each time
        when one simplex iteration has been performed, and reaching
        zero value signals the solver to stop the search.

    - outfrq (default: 200)

        Output frequency, in iterations. This parameter specifies how
        frequently the solver sends information about the solution to
        the standard output.

    - branch (default: 4)

        Branching technique option (for MIP only):

        - 1 (GLP\_BR\_FFV)

            First fractional variable.

        - 2 (GLP\_BR\_LFV)

            Last fractional variable.

        - 3 (GLP\_BR\_MFV)

            Most fractional variable.

        - 4 (GLP\_BR\_DTH)

            Heuristic by Driebeck and Tomlin.

        - 5 (GLP\_BR\_PCH)

            Hybrid pseudocost heuristic.

    - btrack (default: 4)
    Backtracking technique option (for MIP only):
        - 1 (GLP\_BT\_DFS)

            Depth first search.

        - 2 (GLP\_BT\_BFS)

            Breadth first search.

        - 3 (GLP\_BT\_BLB)

            Best local bound.

        - 4 (GLP\_BT\_BPH)

            Best projection heuristic.
    - presol (default: 1)

        If this flag is set, the simplex solver uses the built-in LP
        presolver. Otherwise the LP presolver is not used.

    - lpsolver (default: 1)

        Select which solver to use. If the problem is a MIP problem
        this flag will be ignored.

        1. Revised simplex method.
        2. Interior point method.

    - rtest (default: 34)

        Ratio test technique:

        - 0x11 (GLP\_RT\_STD)

            Standard ("textbook").

        - 0x22 (GLP\_RT\_HAR)

            Harris’ two-pass ratio test.

        - 0x33 (GLP\_RT\_FLIP)

            long-step (flip-flop) ratio test

    - tmlim (default: intmax)

        Searching time limit, in milliseconds.

    - outdly (default: 0)

        Output delay, in seconds. This parameter specifies how long
        the solver should delay sending information about the solution
        to the standard output.

    - save\_pb (default: 0)

        If this parameter is nonzero, save a copy of the problem in
        CPLEX LP format to the file "outpb.lp". There is currently
        no way to change the name of the output file.

    Real parameters:

    - tolbnd (default: 1e-7)

        Relative tolerance used to check if the current basic solution
        is primal feasible. It is not recommended that you change
        this parameter unless you have a detailed understanding of
        its purpose.

    - toldj (default: 1e-7)

        Absolute tolerance used to check if the current basic solution
        is dual feasible. It is not recommended that you change this
        parameter unless you have a detailed understanding of its
        purpose.

    - tolpiv (default: 1e-10)

        Relative tolerance used to choose eligible pivotal elements of
        the simplex table. It is not recommended that you change
        this parameter unless you have a detailed understanding of
        its purpose.

    - objll (default: -INFINITY)

        Lower limit of the objective function. If the objective function
        reaches this limit and continues decreasing, the solver stops
        the search. This parameter is used in the dual simplex method
        only.

    - objul (default: INFINITY)

        Upper limit of the objective function. If the objective function
        reaches this limit and continues increasing, the solver stops
        the search. This parameter is used in the dual simplex only.

    - tolint (default: 1e-5)

        Relative tolerance used to check if the current basic solution
        is integer feasible. It is not recommended that you change
        this parameter unless you have a detailed understanding of
        its purpose.

    - tolobj (default: 1e-7)

        Relative tolerance used to check if the value of the objective
        function is not better than in the best known integer feasi-
        ble solution. It is not recommended that you change this
        parameter unless you have a detailed understanding of its
        purpose.

Output values:

- xopt

    The optimizer (the value of the decision variables at the optimum).

- fopt

    The optimum value of the objective function.

- errnum

    Error code.

    - 0

        No error.

    - 1 (GLP\_EBADB)

        Invalid basis.

    - 2 (GLP\_ESING)

        Singular matrix.

    - 3 (GLP\_ECOND)

        Ill-conditioned matrix.

    - 4 (GLP\_EBOUND)

        Invalid bounds.

    - 5 (GLP\_EFAIL)

        Solver failed.

    - 6 (GLP\_EOBJLL)

        Objective function lower limit reached.

    - 7 (GLP\_EOBJUL)

        Objective function upper limit reached.

    - 8 (GLP\_EITLIM)

        Iterations limit exhausted.

    - 9 (GLP\_ETMLIM)

        Time limit exhausted.

    - 10 (GLP\_ENOPFS)

        No primal feasible solution.

    - 11 (GLP\_ENODFS)

        No dual feasible solution.

    - 12 (GLP\_EROOT)

        Root LP optimum not provided.

    - 13 (GLP\_ESTOP)

        Search terminated by application.

    - 14 (GLP\_EMIPGAP)

        Relative MIP gap tolerance reached.

    - 15 (GLP\_ENOFEAS)

        No primal/dual feasible solution.

    - 16 (GLP\_ENOCVG)

        No convergence.

    - 17 (GLP\_EINSTAB)

        Numerical instability.

    - 18 (GLP\_EDATA)

        Invalid data.

    - 19 (GLP\_ERANGE)

        Result out of range.

- lambda

    Dual variables.

- redcosts

    Reduced Costs.

- status Status of the optimization.
    - 1 (GLP\_UNDEF)

        Solution status is undefined.

    - 2 (GLP\_FEAS)

        Solution is feasible.

    - 3 (GLP\_INFEAS)

        Solution is infeasible.

    - 4 (GLP\_NOFEAS)

        Problem has no feasible solution.

    - 5 (GLP\_OPT)

        Solution is optimal.

    - 6 (GLP\_UNBND)

        Problem has no unbounded solution.

## glpk\_bc

This is a wrapper for `glpk` that takes the same arguments, but has two
differences:

- It is capable of broadcasting over higher dimensions of the coefficient
matrix `a`.
- The coefficient matrix `a` must be a true ndarray and cannot be a
[PDL::CCS::Nd](https://metacpan.org/pod/PDL%3A%3ACCS%3A%3ANd) sparse matrix.

# AUTHOR

Jörg Sommrey

# COPYRIGHT AND LICENSE

Copyright 2024 Jörg Sommrey

This library is free software; you may redistribute it and/or
modify it under the terms of the GNU GENERAL PUBLIC LICENSE Version 3.
See COPYING.

# SEE ALSO

The Octave Manual:
[https://docs.octave.org/latest/Linear-Programming.html](https://docs.octave.org/latest/Linear-Programming.html)

The GNU Linear Programming Kit:
[https://www.gnu.org/software/glpk/](https://www.gnu.org/software/glpk/)

The GLPK reference manual is included in the GLPK distribution.
