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
my $vtype = (GLP_IV * ones(4));
my $sense = pdl [[GLPX_MAX], [GLPX_MIN]];
my $xopt = null;
my $fopt = null;
my $errno = null;
my $status = null;
my $lambda = null;
my $redcosts = null;

glpk_bc($c, $a, $b, $lb, $ub, $ctype, $vtype, $sense, $xopt, $fopt,
   $errno, $status, $lambda, $redcosts, {});

is $fopt->at(0, 0), float_v2(10), 'maximize';
is $fopt->at(0, 1), float_v2(6), 'minimize';

done_testing;
