#!perl -T

use v5.24;
use warnings;
use Test2::V0 '!float';
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
# dims: 3, 2;
my $ctype = pdl([[GLP_LO, GLP_LO, GLP_LO],[GLP_UP, GLP_UP, GLP_UP]]);
my $vtype = (GLP_IV * ones(4));
# dims: 1, 2;
my $sense = pdl [[GLPX_MAX], [GLPX_MIN]];
my $xopt = null;
my $fopt = null;
my $status = null;
my $lambda = null;
my $redcosts = null;

glpk($c, $a, $b, $lb, $ub, $ctype, $vtype, $sense, $xopt, $fopt,
   $status, $lambda, $redcosts, {save_pb => 0});

ok(all approx($fopt, pdl([[10, 16], [6, 0]])), 'fopt for min/max lb/ub') ||
    diag "got $fopt";
ok(all approx($xopt, pdl(
        [[[4, 3, 2, 1],
          [4, 4, 4, 4]],
         [[3, 2, 1, 0],
          [0, 0, 0, 0]]])), 'xopt for min/max lb/ub') ||
    diag "got $xopt";

done_testing;
