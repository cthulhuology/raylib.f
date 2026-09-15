\ Port of raylib examples/textures/textures_tiled_drawing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
220 CONSTANT OPT_WIDTH
8 CONSTANT MARGIN_SIZE
16 CONSTANT COLOR_SIZE
6 CONSTANT #PATTERNS
10 CONSTANT MAX_COLORS

CREATE texPattern 32 ALLOT
CREATE recPattern 6 16 * ALLOT
CREATE colorRec 10 16 * ALLOT
CREATE origin 16 ALLOT
CREATE dest 16 ALLOT
CREATE src 16 ALLOT
CREATE dst 16 ALLOT
CREATE hit 16 ALLOT
CREATE colors
BLACK , MAROON , ORANGE , BLUE , PURPLE , BEIGE , LIME , RED , DARKGRAY , SKYBLUE ,
VARIABLE activePattern
VARIABLE activeCol
FVARIABLE scale
FVARIABLE rotation

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;
: rec-x ( a -- ) ( F: -- x ) sf@ ;
: rec-y ( a -- ) ( F: -- y ) 4 + sf@ ;
: rec-w ( a -- ) ( F: -- w ) 8 + sf@ ;
: rec-h ( a -- ) ( F: -- h ) 12 + sf@ ;
: pat[] ( i -- a ) 16 * recPattern + ;
: crec[] ( i -- a ) 16 * colorRec + ;
: col[] ( i -- u ) cells colors + @ ;

: n>z ( n -- z ) dup 0< if abs 1 else 0 then >r 0 <# #s r> if [char] - hold then #> zres ;

\ Simplified tiled blit: full tiles + clipped remainder via DrawTexturePro
CREATE tsrc 16 ALLOT
CREATE tdst 16 ALLOT
: DrawTextureTiled ( tex src dest orig F: rot scale tint -- )
   >r fswap fdup f0<= if r> drop fdrop fdrop 2drop 2drop exit then   ( F: rot scale )
   2 pick rec-w fover f* f>s  ( tileW )
   2 pick rec-h fover f* f>s  ( tileH )  ( tex src dest orig F: rot scale  tileW tileH )
   dup 0= over 0= or if 2drop r> drop fdrop fdrop 2drop 2drop exit then
   3 pick rec-h f>s over / 1+  0 do          \ rows
      4 pick rec-w f>s 2 pick / 1+  0 do    \ cols
         5 pick rec-x  5 pick rec-y  5 pick rec-w  5 pick rec-h tsrc Rec!
         4 pick rec-x i 3 pick * s>f f+
         4 pick rec-y j 2 pick * s>f f+
         2 pick s>f  over s>f tdst Rec!
         \ clip dest to remaining dest rect
         tdst rec-x 3 pick rec-x 3 pick rec-w f+ f> if
         else
            tdst rec-y 3 pick rec-y 3 pick rec-h f+ f> if
            else
               tdst rec-x 3 pick rec-x 3 pick rec-w f+ tdst rec-w f- f> if
                  3 pick rec-x 3 pick rec-w f+ tdst rec-x f- tdst 8 + sf!
                  tdst rec-w 2 pick s>f f/ 5 pick rec-w f* tsrc 8 + sf!
               then
               tdst rec-y 3 pick rec-y 3 pick rec-h f+ tdst rec-h f- f> if
                  3 pick rec-y 3 pick rec-h f+ tdst rec-y f- tdst 12 + sf!
                  tdst rec-h over s>f f/ 5 pick rec-h f* tsrc 12 + sf!
               then
               tdst rec-w f0> tdst rec-h f0> and if
                  fover fover  ( keep rot scale )
                  6 pick tsrc tdst 3 pick r@ DrawTexturePro
               then
            then
         then
      loop
   loop
   2drop r> drop fdrop fdrop 2drop 2drop ;

: example
   FLAG_WINDOW_RESIZABLE SetConfigFlags
   screenWidth screenHeight z" raylib [textures] example - tiled drawing" InitWindow
   texPattern z" /home/dave/Code/raylib/examples/textures/resources/patterns.png" LoadTexture drop
   texPattern TEXTURE_FILTER_TRILINEAR SetTextureFilter
   3e 3e 66e 66e 0 pat[] Rec!
   75e 3e 100e 100e 1 pat[] Rec!
   3e 75e 66e 66e 2 pat[] Rec!
   7e 156e 50e 50e 3 pat[] Rec!
   85e 106e 90e 45e 4 pat[] Rec!
   75e 154e 100e 60e 5 pat[] Rec!
   0e 0e origin Vector2!
   0 0 ( x y )
   MAX_COLORS 0 do
      2e MARGIN_SIZE s>f f+ over s>f f+
      22e 256e f+ MARGIN_SIZE s>f f+ over s>f f+
      COLOR_SIZE 2* s>f COLOR_SIZE s>f
      i crec[] Rec!
      i MAX_COLORS 2/ 1- = if drop 0 swap COLOR_SIZE MARGIN_SIZE + + swap
      else COLOR_SIZE 2* MARGIN_SIZE + + then
   loop 2drop
   0 activePattern !  0 activeCol !
   1e scale f!  0e rotation f!
   60 SetTargetFPS
   begin
      MOUSE_BUTTON_LEFT IsMouseButtonPressed if
         #PATTERNS 0 do
            2e MARGIN_SIZE s>f f+ i pat[] rec-x f+
            40e MARGIN_SIZE s>f f+ i pat[] rec-y f+
            i pat[] rec-w i pat[] rec-h hit Rec!
            mouse@ hit CheckCollisionPointRec if i activePattern ! then
         loop
         MAX_COLORS 0 do
            mouse@ i crec[] CheckCollisionPointRec if i activeCol ! then
         loop
      then
      KEY_UP   IsKeyPressed if scale f@ 0.25e f+ scale f! then
      KEY_DOWN IsKeyPressed if scale f@ 0.25e f- scale f! then
      scale f@ 10e f> if 10e scale f! then
      scale f@ f0<= if 0.25e scale f! then
      KEY_LEFT  IsKeyPressed if rotation f@ 25e f- rotation f! then
      KEY_RIGHT IsKeyPressed if rotation f@ 25e f+ rotation f! then
      KEY_SPACE IsKeyPressed if 0e rotation f! 1e scale f! then
      BeginDrawing
         RAYWHITE ClearBackground
         OPT_WIDTH MARGIN_SIZE + s>f MARGIN_SIZE s>f
         GetScreenWidth OPT_WIDTH - MARGIN_SIZE 2* - s>f
         GetScreenHeight MARGIN_SIZE 2* - s>f dest Rec!
         texPattern activePattern @ pat[] dest origin rotation f@ scale f@ activeCol @ col[] DrawTextureTiled
         MARGIN_SIZE MARGIN_SIZE OPT_WIDTH MARGIN_SIZE - GetScreenHeight MARGIN_SIZE 2* - LIGHTGRAY 0.5e ColorAlpha DrawRectangle
         z" Select Pattern" 2 MARGIN_SIZE + 30 MARGIN_SIZE + 10 BLACK DrawText
         texPattern 2 MARGIN_SIZE + 40 MARGIN_SIZE + BLACK DrawTexture
         2 MARGIN_SIZE + activePattern @ pat[] rec-x f>s +
         40 MARGIN_SIZE + activePattern @ pat[] rec-y f>s +
         activePattern @ pat[] rec-w f>s activePattern @ pat[] rec-h f>s
         DARKBLUE 0.3e ColorAlpha DrawRectangle
         z" Select Color" 2 MARGIN_SIZE + 10 256 + MARGIN_SIZE + 10 BLACK DrawText
         MAX_COLORS 0 do
            i crec[] i col[] DrawRectangleRec
            activeCol @ i = if i crec[] 3e WHITE 0.5e ColorAlpha DrawRectangleLinesEx then
         loop
         z" Scale (UP/DOWN to change)" 2 MARGIN_SIZE + 80 256 + MARGIN_SIZE + 10 BLACK DrawText
         scale f@ 100e f* f>s n>z 2 MARGIN_SIZE + 92 256 + MARGIN_SIZE + 20 BLACK DrawText
         z" Rotation (LEFT/RIGHT to change)" 2 MARGIN_SIZE + 122 256 + MARGIN_SIZE + 10 BLACK DrawText
         rotation f@ f>s n>z 2 MARGIN_SIZE + 134 256 + MARGIN_SIZE + 20 BLACK DrawText
         z" Press [SPACE] to reset" 2 MARGIN_SIZE + 164 256 + MARGIN_SIZE + 10 DARKBLUE DrawText
         GetFPS n>z 2 MARGIN_SIZE + 2 MARGIN_SIZE + 20 BLACK DrawText
      EndDrawing
   WindowShouldClose until
   texPattern UnloadTexture
   CloseWindow ;

example-end
