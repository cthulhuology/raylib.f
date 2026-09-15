\ example.f -- turnkey every Forth raylib example into examples/bin/
\
\   cd ~/forth/raylib.f/linux
\   sf64 include examples/example.f
\
\   cd ~/forth/raylib.f/linux/examples
\   sf64 example.f
\
\ Each binary is named after the source (core_basic_window, ...).
\ The child image starts at EXAMPLE; EXAMPLE-NO-RUN keeps the source
\ from running while it is being compiled.

only forth also definitions

create (ex)   ," /home/dave/forth/raylib.f/linux/examples"
create (bin)  ," /home/dave/forth/raylib.f/linux/examples/bin"
create (sf)   ," /opt/SwiftForth/bin/linux/sf64"
create (list) ," /tmp/sfex-list.txt"
create (wrap) ," /tmp/sfex-build.f"

: /EX   (ex) count ;
: /BIN  (bin) count ;
: /SF   (sf) count ;
: /LIST (list) count ;
: /WRAP (wrap) count ;

create zcmd  1024 allot
create exline  512 allot
create name  128 allot
variable pass
variable fail

: /name ( addr u -- addr2 u2 )
   begin
      2dup [char] / scan dup
   while  1 /string  2swap 2drop
   repeat 2drop ;

: -ext ( addr u -- addr u )
   2dup [char] . scan nip - ;

: bin-name ( rel-addr rel-u -- addr u )
   /name -ext  name place  name count ;

: wr ( addr u fid -- )
   write-file throw ;

: wrnl ( fid -- )
   10 pad c!  pad 1 rot wr ;

: write-wrap ( rel-addr rel-u -- )
   /WRAP r/w create-file throw >r
   s" empty" r@ wr  r@ wrnl
   s" : EXAMPLE-NO-RUN ;" r@ wr  r@ wrnl
   s" include " r@ wr  /EX r@ wr  s" /common.f" r@ wr  r@ wrnl
   s" include " r@ wr  /EX r@ wr  s" /" r@ wr  2dup r@ wr  r@ wrnl
   s" ' example 'MAIN !" r@ wr  r@ wrnl
   s" PROGRAM " r@ wr  /BIN r@ wr  s" /" r@ wr
      2dup bin-name r@ wr  r@ wrnl
   s" bye" r@ wr  r@ wrnl
   r> close-file throw  2drop ;

: compile-one ( rel-addr rel-u -- )
   2dup cr type  ."  -> bin/"  2dup bin-name type
   write-wrap
   /SF zcmd zplace  s"  " zcmd zappend  /WRAP zcmd zappend
   zcmd system
   if  1 fail +!  ."   FAIL"
   else  1 pass +!  ."   OK"  then ;

: list-examples ( -- )
   s" find " zcmd zplace
   /EX zcmd zappend
   s"  -name '*.f' ! -name common.f ! -name example.f ! -name raymath.f -printf '%P\n' | sort > "
      zcmd zappend
   /LIST zcmd zappend
   zcmd system abort" find failed" ;

: each-example ( -- )
   /LIST r/o open-file throw >r
   begin
      exline 511 r@ read-line throw
   while
      exline swap compile-one
   repeat drop
   r> close-file throw ;

: mkdir-bin ( -- )
   s" mkdir -p " zcmd zplace  /BIN zcmd zappend
   zcmd system abort" mkdir failed" ;

mkdir-bin
0 pass !  0 fail !
list-examples
each-example
cr cr ." Built: " pass @ .  ."  Failed: " fail @ .
cr ." Binaries: " /BIN type cr
fail @ abort" example turnkey failed"
bye
