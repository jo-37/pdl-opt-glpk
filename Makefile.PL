
# Use this as a template for the Makefile.PL for
# any external PDL module.

use ExtUtils::MakeMaker;

use PDL::Core::Dev;
@pack = (["glpk.pd",GLPK,PDL::Opt::GLPK]);

%hash = pdlpp_stdargs(@pack);
$hash{LIBS}[0] .= ' -lm -lglpk ';
$hash{OBJECT} = q{$(O_FILES)};
$hash{MAGIC_XS} = 1;

WriteMakefile(%hash);

# Add genpp rule
# add other makefile additions as required (see also ExtUtils::MakeMaker)
sub MY::postamble {
	pdlpp_postamble(@pack);
}

