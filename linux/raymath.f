\ raymath.f -- Forth stand-ins for raymath.h used by the examples.
\ All vector/matrix arguments are addresses of packed C floats.
\ Vector2! / Vector3! consume dest; dest-first words dup before storing.

: v2x ( v -- ) ( F: -- x )  sf@ ;
: v2y ( v -- ) ( F: -- y )  4 + sf@ ;
: v3x ( v -- ) ( F: -- x )  sf@ ;
: v3y ( v -- ) ( F: -- y )  4 + sf@ ;
: v3z ( v -- ) ( F: -- z )  8 + sf@ ;

: Vector2Zero ( dest -- dest )
   dup 0e 0e Vector2! ;

: Vector2Add ( dest a b -- dest )
   >r
   dup v2x r@ v2x f+
   dup v2y r@ v2y f+
   drop r> drop  dup Vector2! ;

: Vector2Subtract ( dest a b -- dest )
   >r
   dup v2x r@ v2x f-
   dup v2y r@ v2y f-
   drop r> drop  dup Vector2! ;

: Vector2Scale ( dest src F: s -- dest )
   dup v2x fover f*  over     sf!
   dup v2y f*        over 4 + sf!
   drop ;

: Vector2Length ( v -- ) ( F: -- len )
   dup v2x fdup f*  v2y fdup f* f+ fsqrt ;

: Vector2Normalize ( dest src -- dest )
   dup Vector2Length fdup f0= if
      fdrop drop  Vector2Zero
   else
      1e fswap f/ Vector2Scale
   then ;

: Vector2Distance ( a b -- ) ( F: -- dist )
   over v2x  dup v2x f- fdup f*
   over v2y  dup v2y f- fdup f* f+ fsqrt
   2drop ;

CREATE (rc) 4 ALLOT
CREATE (rs) 4 ALLOT
: Vector2Rotate ( dest src F: ang -- dest )
   fdup fcos (rc) sf!  fsin (rs) sf!
   >r
   dup v2x (rc) sf@ f*  over v2y (rs) sf@ f* f-
   over v2y (rc) sf@ f*  over v2x (rs) sf@ f* f+
   r@ Vector2!  drop r> ;

: Vector2Multiply ( dest a b -- dest )
   >r
   dup v2x r@ v2x f*
   dup v2y r@ v2y f*
   drop r> drop  dup Vector2! ;

: Vector2Angle ( v1 v2 -- ) ( F: -- rad )
   over v2x  dup v2y f*
   over v2y  dup v2x f* f-
   over v2x  dup v2x f*
   over v2y  dup v2y f* f+
   2drop fatan2 ;

: Vector2LineAngle ( start end -- ) ( F: -- rad )
   dup v2y  over v2y f-
   dup v2x  over v2x f-
   2drop fatan2 ;

CREATE (wlo) 4 ALLOT
CREATE (wra) 4 ALLOT
: Wrap ( F: v lo hi -- r )
   fover f- (wra) sf!  (wlo) sf!
   (wlo) sf@ f- fdup (wra) sf@ f/ floor (wra) sf@ f* f- (wlo) sf@ f+ ;

: Vector3Zero ( dest -- dest )
   dup 0e 0e 0e Vector3! ;

: Vector3Add ( dest a b -- dest )
   >r
   dup sf@     r@ sf@     f+
   dup 4 + sf@ r@ 4 + sf@ f+
   dup 8 + sf@ r@ 8 + sf@ f+
   drop r> drop  dup Vector3! ;

: Vector3Subtract ( dest a b -- dest )
   >r
   dup sf@     r@ sf@     f-
   dup 4 + sf@ r@ 4 + sf@ f-
   dup 8 + sf@ r@ 8 + sf@ f-
   drop r> drop  dup Vector3! ;

: Vector3Scale ( dest src F: s -- dest )
   dup sf@     fover f*  over     sf!
   dup 4 + sf@ fover f*  over 4 + sf!
   dup 8 + sf@ f*        over 8 + sf!
   drop ;

: Vector3Length ( v -- ) ( F: -- len )
   dup sf@ fdup f*  dup 4 + sf@ fdup f* f+  8 + sf@ fdup f* f+ fsqrt ;

: Vector3Normalize ( dest src -- dest )
   dup Vector3Length fdup f0= if
      fdrop drop Vector3Zero
   else
      1e fswap f/ Vector3Scale
   then ;

CREATE (tlerp) 4 ALLOT
: Vector3Lerp ( dest a b F: t -- dest )
   (tlerp) sf!
   >r
   dup sf@     r@ sf@     f- (tlerp) sf@ f*  dup sf@     f+
   dup 4 + sf@ r@ 4 + sf@ f- (tlerp) sf@ f*  dup 4 + sf@ f+
   dup 8 + sf@ r@ 8 + sf@ f- (tlerp) sf@ f*  dup 8 + sf@ f+
   drop r> drop  dup Vector3! ;

: Vector3Cross ( dest a b -- dest )
   >r
   dup 4 + sf@ r@ 8 + sf@ f*  dup 8 + sf@ r@ 4 + sf@ f* f-
   dup 8 + sf@ r@    sf@ f*   dup    sf@ r@ 8 + sf@ f* f-
   dup    sf@ r@ 4 + sf@ f*   dup 4 + sf@ r@    sf@ f* f-
   drop r> drop  dup Vector3! ;

: Vector3DotProduct ( a b -- ) ( F: -- dot )
   over sf@      dup sf@      f*
   over 4 + sf@  dup 4 + sf@  f* f+
   over 8 + sf@  dup 8 + sf@  f* f+
   2drop ;

: Vector3Distance ( a b -- ) ( F: -- dist )
   over sf@      dup sf@      f- fdup f*
   over 4 + sf@  dup 4 + sf@  f- fdup f* f+
   over 8 + sf@  dup 8 + sf@  f- fdup f* f+ fsqrt
   2drop ;

: ClampF ( F: v lo hi -- v )
   frot fover fmin fswap fmax ;

CREATE (lt) 4 ALLOT
: Lerp ( F: a b t -- r )
   (lt) sf!  fover f- (lt) sf@ f* f+ ;
