
# Use this as a template for the Makefile.PL for
# any external PDL module.

use ExtUtils::MakeMaker;

use PDL::Core::Dev;
@pack = (["glpk.pd",GLPK,PDL::Opt::GLPK]);

%hash = pdlpp_stdargs(@pack);
$hash{LIBS}[0] .= ' -lm -lglpk ';
$hash{OBJECT} = q{$(O_FILES)};

WriteMakefile(%hash);

# Add genpp rule
# add other makefile additions as required (see also ExtUtils::MakeMaker)
sub My::postamble {
	pdlpp_postamble(@pack);
}

