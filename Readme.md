# PDL-to-GLPK Interface
This module is work in progress.

It tries to mimic the Octave-to-GLPK interface and actually uses an Octave function that orchestrates the required GLP function and thus provides an all-in-one interface. There are no compile-time or runtime dependencies to Octave.

The borrowed function requests the coefficient matrix in Harwell-Boeing-Format.
As the conversion from a full matrix to its compressed form needs dynamically allocated storage of variable size, this transformation is performed on the perl side, i.e. outside of an broadcast-loop. Thus this module does not handle broadcasting in its current state.