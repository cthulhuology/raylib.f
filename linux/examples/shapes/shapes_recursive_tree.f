\ Port of raylib examples/shapes/shapes_recursive_tree.c
\ raygui widgets replaced with mouse sliders/checkbox

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE start 8 ALLOT
FVARIABLE tangle
FVARIABLE thick
FVARIABLE treeDepth
FVARIABLE branchDecay
FVARIABLE tlength
VARIABLE bezier
CREATE s1 16 ALLOT CREATE s2 16 ALLOT CREATE s3 16 ALLOT
CREATE s4 16 ALLOT CREATE s5 16 ALLOT CREATE ck 16 ALLOT
218 218 218 255 RGBA CONSTANT PANEL_LINE
232 232 232 255 RGBA CONSTANT PANEL_BG

24 CONSTANT /BR
1030 CONSTANT MAXBR
CREATE branches MAXBR /BR * ALLOT
VARIABLE bcount
VARIABLE maxB
VARIABLE bi
FVARIABLE theta
FVARIABLE nextLen
FVARIABLE ang1
FVARIABLE ang2
CREATE bstart 8 ALLOT
CREATE bend 8 ALLOT
CREATE bend2 8 ALLOT

: br ( i -- a ) /BR * branches + ;
: br.start ( a -- a ) ;
: br.end ( a -- a ) 8 + ;
: br.ang ( a -- a ) 16 + ;
: br.len ( a -- a ) 20 + ;

: add-br ( start end F: ang len -- )
   bcount @ MAXBR >= if 2drop fdrop fdrop exit then
   bcount @ br >r
   r@ br.len sf!  r@ br.ang sf!
   r@ br.end 8 move  r@ br.start 8 move
   r> drop  1 bcount +! ;

: build-tree
   0 bcount !
   tangle f@ deg>rad theta f!
   2e treeDepth f@ floor f** f>s maxB !
   start v2x tlength f@ 0e fsin f* f+
   start v2y tlength f@ 0e fcos f* f- bend Vector2!
   start bend 0e tlength f@ add-br
   0 bi !
   begin bi @ bcount @ < while
      bi @ br br.len sf@ 2e f>= if
         bi @ br br.len sf@ branchDecay f@ f* nextLen f!
         bcount @ maxB @ <  nextLen f@ 2e f>= and if
            bi @ br br.end bstart 8 move
            bi @ br br.ang sf@ theta f@ f+ ang1 f!
            bstart v2x nextLen f@ ang1 f@ fsin f* f+
            bstart v2y nextLen f@ ang1 f@ fcos f* f- bend Vector2!
            bstart bend ang1 f@ nextLen f@ add-br
            bi @ br br.ang sf@ theta f@ f- ang2 f!
            bstart v2x nextLen f@ ang2 f@ fsin f* f+
            bstart v2y nextLen f@ ang2 f@ fcos f* f- bend2 Vector2!
            bstart bend2 ang2 f@ nextLen f@ add-br
         then
      then
      1 bi +!
   repeat ;

: example
   screenWidth screenHeight z" raylib [shapes] example - recursive tree" InitWindow
   screenWidth 2/ s>f 125e f- screenHeight s>f start Vector2!
   40e tangle f!  1e thick f!  10e treeDepth f!
   0.66e branchDecay f!  120e tlength f!  false bezier !
   60 SetTargetFPS
   begin
      build-tree
      BeginDrawing
         RAYWHITE ClearBackground
         bcount @ 0 do
            i br br.len sf@ 2e f>= if
               bezier @ if
                  i br br.start i br br.end thick f@ RED DrawLineBezier
               else
                  i br br.start i br br.end thick f@ RED DrawLineEx
               then
            then
         loop
         580 0 580 GetScreenHeight PANEL_LINE DrawLine
         580 0 GetScreenWidth GetScreenHeight PANEL_BG DrawRectangle
         640e 40e 120e 20e s1 Rectangle!  s1 tangle 0e 180e gui-slider
         z" Angle" 580 42 10 DARKGRAY DrawText
         640e 70e 120e 20e s2 Rectangle!  s2 tlength 12e 240e gui-slider
         z" Length" 580 72 10 DARKGRAY DrawText
         640e 100e 120e 20e s3 Rectangle!  s3 branchDecay 0.1e 0.78e gui-slider
         z" Decay" 580 102 10 DARKGRAY DrawText
         640e 130e 120e 20e s4 Rectangle!  s4 treeDepth 1e 10e gui-slider
         z" Depth" 580 132 10 DARKGRAY DrawText
         640e 160e 120e 20e s5 Rectangle!  s5 thick 1e 8e gui-slider
         z" Thick" 580 162 10 DARKGRAY DrawText
         640e 190e 20e 20e ck Rectangle!  ck bezier z" Bezier" gui-check
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
