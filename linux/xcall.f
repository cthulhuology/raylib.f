{ ====================================================================

Extra External Library Calls

Copyright (C) 2025 David J Goehrig <dave@dloh.org>

This library extends the externall calling ABI to support all the 
weirdness of the x86_64 ABI.  The main problem being a lot of 
more libraries are using pass by value structures, and the rules
around register mapping break down for structures >32 bytes or have
"unaligned fields" what ever that's supposed to mean.

======================================================================

stack-call is a word to call a function with data passed on the stack.

xfunction: creates a function which uses x-call to 

==================================================================== }

PACKAGE xcall

CODE stack-call ( addr n func -- x )
	rdi push rsi push rsp r12 mov rbp r13 mov -16 # rsp and	\ save vm context & sp align 16
	0 [rbp] rax mov rax rcx mov rax rax or		\ n in rax, rcx
	0= not if 
		rax rsp sub -16 # rsp and		\ allocate n & align 16
		rsp rdi mov				\ get stack in rdi
		CELL [rbp] rsi mov			\ load addr to rsi
		rep movsb
	then
	rbx call rax rbx mov
	CELL [r13] rbp lea				\ pop data stack
	r12 rsp mov					\ fix return stack
	rsi pop rdi pop					\ restore index regs
	ret END-CODE 

: (X-RET0) ( -- )
	DOES> ( -- x ) 2@ stack-call drop ;		\ 



: (look-ahead) >IN @ >R TOKEN 2DROP ; 			\ seek past the function name

: (look-back) R> >IN ! ;				\ reset input buffer

: (count-args) 

: XFUNCTION: ( "name" -- )
	
	create +smudge 


END-PACKAGE
