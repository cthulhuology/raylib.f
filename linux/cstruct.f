\ cstruct.f
\ 
\ Some basic translation of C structures into forth, need this for x86_64 ffi calls
\ 

\ sizeof the current struct
0 value (ptr)
0 value (sizeof)
1 value (array)

: struct ( "name" -- )			\ base struct definiton
	1 to (array)
	0 to (sizeof)
	create here to (ptr) 0 ,
	does> ( -- sizeof ) @ ;

: extend ( n -- )			\ for overlay structs / unions
	to (sizeof)
	1 to (array)
	create here to (ptr) (sizeof) ,
	does> ( -- sizeof) @ ;

: ;struct ( -- )			\ update struct sizeof and reset globals
	(sizeof) (ptr) !
	0 to (sizeof) 
	0 to (ptr)
	1 to (array) ; 

: [] ( n -- ) to (array) ;		\ populate the (array) with a static allocation

: c_struct  ( n -- ) 			\ create a field of the given size
	(array) 1 to (array)		\ for arrays we default to 1 element
	*				\ n (array) *
	(sizeof) dup >r + to (sizeof)	\ offset >r, update (sizeof)
	create r> , does> @ + ;		\ define offset word ( addr -- addr+offset )

: c_char	1 c_struct ;
: c_short	2 c_struct ;
: c_int		4 c_struct ;
: c_long	8 c_struct ;
: c_float	4 c_struct ;
: c_double	8 c_struct ;

: c_void*	8 c_struct ;
: c_void**	8 c_struct ;
: c_char*	c_void* ;
: c_short*	c_void* ;
: c_int*	c_void* ;
: c_long*	c_void* ;
: c_float*	c_void* ;
: c_double*	c_void* ;


