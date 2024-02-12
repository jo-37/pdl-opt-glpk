#!perl -T

use v5.26;
use Test2::V0 '!float';

use PDL;
use PDL::Opt::GLPK;

my $a = pdl([1, 1, 1], [10, 4, 5], [2, 2, 6]);
my $b = pdl([100, 600, 300]);
my $c = pdl([10, 6, 4]);
my $lb = zeroes(3);
my $ub = inf(3);
my $ctype = GLP_UP * ones(3);
my $vtype = GLP_CV * ones(3);
my $xopt = null;
my $fopt = null;
my $lambda = null;
my $redcosts = null;
my $status = null;

glpk($c,  $a, $b, $lb, $ub, $ctype, $vtype, GLP_MAX,
    $xopt, $fopt, $status, $lambda, $redcosts, {});

my $xexp = pdl(33.3333, 66.6667, 0);
ok all(approx $xopt, $xexp, 1e-4), 'xopt from GLPK example';

my $fexp = 733.333;
ok approx($fopt, $fexp, 1e-3), 'fopt from GLPK example';

done_testing;
