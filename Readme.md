# NAME

PDL::Opt::GLPK - PDL interface to the GNU Linear Programming Kit

# SYNOPSIS
```perl
    use PDL;
    use PDL::Opt::GLPK;

    glpk($c, $a, $b $lb, $ub, $ctype, $vtype, GLP_MAX,
           $xopt = null, $fopt = null, $status = null,
           $lambda = null, $redcosts = null, \%param);
```

# DESCRIPTION

This module provides an interface to GLPK, the GNU Linear Programming
Kit.
The interface was ported from Octave and mimics its GLPK interface.

# FUNCTIONS

## glpk

    Signature (c(m); a(m, n); b(n); lb(m); ub(m); ctype(n); vtype(m);
           int sense; [o]xopt(m); [o]fopt(); [o]status(); [o]lambda(n);
           [o]redcosts(n); SV *param)

Solve a linear program using the GNU GLPK library.

The LP can be of the form
```
    [ min | max ] C'*x
    subject to

    A*x [ "=" | "<=" | ">=" ] b
      x >= LB
      x <= UB
```
### Arguments

Input values:

- c

    A ndarray containing the objective function coefficients.

- a

    A ndarray containing the constraints coefficients.
    `a` must be 2-d, though broadcasting over higher dimensions is possible
    for other arguments.

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

        An inequality constraint with a lower bound.

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
        Lower and upper bound are ignored and set to zero resp. one.

- sense
    - 1 (GLP\_MIN)

        Minimize the objective function.

    - 2 (GLP\_MAX)

        Maximize the objective function.

- param (optional)

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

    - price (default: 0x22)

        Pricing option (for both primal and dual simplex):

        - 0x11 (GLP\_PT\_STD)

            Textbook pricing.

        - 0x22 (GLP\_PT\_PSE)

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

        - 1 Revised simplex method.

        - 2 Interior point method.

    - rtest (default: 0x22)

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
        CPLEX LP format to a file as specified by the parameter `save_fn`.

    - save\_fn (default: `"outpb.%d.lp"`)

        This is a format for the file name(s) the problem will be written to if
        `save_pb` is true.
        The pattern shall contain a placeholder like `%d`
        that will be replaced with a sequence number.
        This is required for broadcasting to prevent the file being overwritten.

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

- lambda (optional)

    Dual variables.

- redcosts (optional)

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

# EXAMPLES

## A standard case

A modified example from the GLPK documentation, with an extra variable
to avoid a square matrix:
```
    Maximize
     obj: + 10 x_1 + 6 x_2 + 4 x_3 - x_4

    Subject To
     r_1: + x_4 + x_3 + x_2 + x_1 <= 100
     r_2: + x_4 + 5 x_3 + 4 x_2 + 10 x_1 <= 600
     r_3: + x_4 + 6 x_3 + 2 x_2 + 2 x_1 <= 300
```
The solution is straightforward:
```perl
use PDL;
use PDL::Opt::GLPK;

$a = pdl([[1, 1, 1, 1], [10, 4, 5, 1], [2, 2, 6, 1]]);
$b = pdl([100, 600, 300]);
$c = pdl([10, 6, 4, -1]);
$lb = zeroes(4);
$ub = inf(4);
$ctype = pdl([GLP_UP, GLP_UP, GLP_UP]);
$vtype = pdl([GLP_CV, GLP_CV, GLP_CV, GLP_CV]);

glpk($c, $a, $b $lb, $ub, $ctype, $vtype, GLPX_MAX,
   $xopt = null, $fopt = null, $status = null);

# $xopt:
# [
#   [ 33.333333  66.666667      0          0]
# ]

# $fopt:
# [ 733.33333]
```

## Broadcasting

Multiple problems on the same coefficients may be solved simultaneously.
Some care must be taken when all combinations of multiple arguments are
requested.

The base problem:
```
    Maximize
     obj: + y_1 + y_2 + y_3 + y_4

    Subject To
     r_1: - y_2 + y_1 >= 1
     r_2: - y_3 + y_2 >= 1
     r_3: - y_4 + y_3 >= 1

    Bounds
     0 <= y_1 <= 4
     0 <= y_2 <= 4
     0 <= y_3 <= 4
     0 <= y_4 <= 4

    Generals
     y_1
     y_2
     y_3
     y_4
```
Looking for the objective function's minimum _and_ maximum with both
lower _and_ upper bound constraints:
```perl
use PDL;
use PDL::Opt::GLPK;

my $a = pdl(
    [[1, -1, 0, 0],
     [0, 1, -1, 0],
     [0, 0, 1, -1]]);
my $b = pdl([1, 1, 1]);
my $c = pdl([1, 1, 1, 1]);
my $lb = pdl([0, 0, 0, 0]);
my $ub = pdl([4, 4, 4, 4]);

# dims: 3, 2 - loop over lower and upper bounds
my $ctype = pdl([[GLP_LO, GLP_LO, GLP_LO],[GLP_UP, GLP_UP, GLP_UP]]);

my $vtype = (GLP_IV * ones(4));

# dims: 1, 2 - extra loop over min and max
my $sense = pdl [[GLPX_MAX], [GLPX_MIN]];

my $xopt = null;
my $fopt = null;
my $status = null;

glpk($c, $a, $b, $lb, $ub, $ctype, $vtype, $sense, $xopt, $fopt, $status);

# $xopt:
# [
#  [
#   [4 3 2 1]
#   [4 4 4 4]
#  ]
#  [
#   [3 2 1 0]
#   [0 0 0 0]
#  ]
# ]
#
# $fopt:
# [
#  [10 16]
#  [ 6  0]
# ]
```

## Specifying parameters

The `params` hash ref is always the last argument. It is permitted to
leave out the other optional output arguments, as in
```perl
    glpk($c, $a, $b, $lb, $up, $ctpye, $vtype, $sense,
        $xopt, $fopt, $status, {save_pb => 1});
```
# ERRORS

In case the solver reports an error, it will raise an PDL error.

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
