#!perl -T

use v5.24;
use warnings;
use Test2::V0 '!float', float => {-as => 'float_v2'};
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
my $ctype = (GLP_LO * ones(3));
# dims: 3, 2;
my $ctype = pdl([[GLP_LO, GLP_LO, GLP_LO],[GLP_UP, GLP_UP, GLP_UP]]);
#my $ctype = pdl([GLP_LO, GLP_LO, GLP_LO]);
my $vtype = (GLP_IV * ones(4));
# dims: 1, 2;
my $sense = pdl [[GLPX_MAX], [GLPX_MIN]];
my $xopt = null;
my $fopt = null;
my $errno = null;
my $status = null;
my $lambda = null;
my $redcosts = null;

glpk($c, $a, $b, $lb, $ub, $ctype, $vtype, $sense, $xopt, $fopt,
   $errno, $status, $lambda, $redcosts, {});

is $fopt->unpdl, [[float_v2(10), float_v2(16)], [float_v2(6), float_v2(0)]],
    'min/max lb/ub';

done_testing;
