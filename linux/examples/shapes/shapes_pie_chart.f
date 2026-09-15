\ Port of raylib examples/shapes/shapes_pie_chart.c
\ raygui panel replaced with keys: UP/DOWN slices, LEFT/RIGHT value,
\ V values, P percents, D donut, mouse hover pops a slice

800 CONSTANT screenWidth
450 CONSTANT screenHeight
10 CONSTANT MAX_PIE

CREATE values MAX_PIE 4 * ALLOT
VARIABLE sliceCount
FVARIABLE donutInner
VARIABLE showValues
VARIABLE showPercents
VARIABLE showDonut
VARIABLE hovered
CREATE center 8 ALLOT
CREATE panel 16 ALLOT
205e fconstant radius
FVARIABLE totalValue
FVARIABLE startAng
FVARIABLE sweep
FVARIABLE midAng
CREATE lab 64 ALLOT

: val ( i -- a ) 4 * values + ;

: fmt-label ( i -- zaddr )
   lab 64 erase
   showValues @ showPercents @ and if
      i val sf@ zf2 zcount lab swap move
      s"  (" lab zcount + swap move
      i val sf@ totalValue f@ f/ 100e f* zf0 zcount
      lab zcount + swap move
      s" %)" lab zcount + swap move
      lab zcount + 0 swap c!  lab
   else showValues @ if
      i val sf@ zf2
   else showPercents @ if
      i val sf@ totalValue f@ f/ 100e f* zf0
   else
      lab
   then then then ;

: example
   screenWidth screenHeight z" raylib [shapes] example - pie chart" InitWindow
   7 sliceCount !
   25e donutInner f!
   300e 0 val sf!  100e 1 val sf!  450e 2 val sf!  350e 3 val sf!
   600e 4 val sf!  380e 5 val sf!  750e 6 val sf!
   true showValues !  false showPercents !  false showDonut !
   screenWidth 270 - 5 - 2/ s>f  screenHeight 2/ s>f center Vector2!
   0e 0e  screenWidth 270 - 5 - s>f  screenHeight s>f reca Rectangle!
   60 SetTargetFPS
   begin
      0e totalValue f!
      sliceCount @ 0 do i val sf@ totalValue f@ f+ totalValue f! loop
      -1 hovered !
      mouse@ reca CheckCollisionPointRec if
         mouse@ v2x center v2x f- fdup fdup f*
         mouse@ v2y center v2y f- fdup f* f+ fsqrt
         radius f<= if
            mouse@ v2y center v2y f- mouse@ v2x center v2x f- fatan2 rad>deg
            fdup f0< if 360e f+ then
            0e startAng f!
            sliceCount @ 0 do
               totalValue f@ f0= if 0e else i val sf@ totalValue f@ f/ 360e f* then sweep f!
               fdup startAng f@ f>=  fover startAng f@ sweep f@ f+ f< and if
                  i hovered !  leave
               then
               startAng f@ sweep f@ f+ startAng f!
            loop
            fdrop
         else fdrop then
      then
      KEY_UP IsKeyPressed sliceCount @ MAX_PIE < and if 1 sliceCount +! then
      KEY_DOWN IsKeyPressed sliceCount @ 1 > and if -1 sliceCount +! then
      KEY_RIGHT IsKeyPressed if
         hovered @ 0 >= if hovered @ val sf@ 50e f+ hovered @ val sf! then then
      KEY_LEFT IsKeyPressed if
         hovered @ 0 >= if hovered @ val sf@ 50e f- fdup f0< if fdrop 0e then hovered @ val sf! then then
      KEY_V IsKeyPressed if showValues @ 0= showValues ! then
      KEY_P IsKeyPressed if showPercents @ 0= showPercents ! then
      KEY_D IsKeyPressed if showDonut @ 0= showDonut ! then
      BeginDrawing
         RAYWHITE ClearBackground
         0e startAng f!
         sliceCount @ 0 do
            totalValue f@ f0= if 0e else i val sf@ totalValue f@ f/ 360e f* then sweep f!
            startAng f@ sweep f@ 2e f/ f+ midAng f!
            i s>f sliceCount @ s>f f/ 360e f* 0.75e 0.9e ColorFromHSV
            radius  i hovered @ = if 20e f+ then
            center startAng f@ startAng f@ sweep f@ f+ 120 rot DrawCircleSector
            i val sf@ f0> showValues @ and if
               startAng f@ sweep f@ 2e f/ f+ deg>rad
               fdup fcos radius 0.7e f* f* center v2x f+ f>s
               fswap fsin radius 0.7e f* f* center v2y f+ f>s
               i val sf@ zf2 -rot 20 WHITE DrawText
            then
            showDonut @ if
               center v2x f>s center v2y f>s donutInner f@ RAYWHITE DrawCircle
            then
            startAng f@ sweep f@ f+ startAng f!
         loop
         screenWidth 270 - 5 - 5 270 screenHeight 10 - LIGHTGRAY 0.5e Fade DrawRectangle
         z" UP/DOWN slices  LEFT/RIGHT value" screenWidth 260 - 20 10 DARKGRAY DrawText
         z" V values  P percents  D donut" screenWidth 260 - 40 10 DARKGRAY DrawText
         z" Slices:" screenWidth 260 - 70 10 BLACK DrawText
         sliceCount @ zint screenWidth 200 - 70 10 BLACK DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
