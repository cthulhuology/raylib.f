\ Port of raylib examples/shapes/shapes_top_down_lights.c
\ Custom rlgl blend masks approximated: boxes, draggable lights,
\ shadow volumes on F1, dark overlay with additive light discs.

800 CONSTANT screenWidth
450 CONSTANT screenHeight
20 CONSTANT MAX_BOXES
16 CONSTANT MAXL

CREATE boxes MAX_BOXES 16 * ALLOT
VARIABLE boxCount
CREATE img 24 ALLOT
CREATE bgtex 20 ALLOT
CREATE lpos MAXL 8 * ALLOT
CREATE lrad MAXL 4 * ALLOT
CREATE lactive MAXL CELLS ALLOT
VARIABLE nlights
VARIABLE showLines
CREATE sp 8 ALLOT
CREATE ep 8 ALLOT
CREATE spv 8 ALLOT
CREATE epv 8 ALLOT
CREATE projS 8 ALLOT
CREATE projE 8 ALLOT
CREATE fan 4 8 * ALLOT

: box ( i -- a ) 16 * boxes + ;
: lp ( i -- a ) 8 * lpos + ;
: lr ( i -- a ) 4 * lrad + ;

: setup-boxes
   150e 80e 40e 40e 0 box Rectangle!
   1200e 700e 40e 40e 1 box Rectangle!
   200e 600e 40e 40e 2 box Rectangle!
   1000e 50e 40e 40e 3 box Rectangle!
   500e 350e 40e 40e 4 box Rectangle!
   MAX_BOXES 5 do
      0 GetScreenWidth GetRandomValue s>f
      0 GetScreenHeight GetRandomValue s>f
      10 100 GetRandomValue s>f
      10 100 GetRandomValue s>f
      i box Rectangle!
   loop
   MAX_BOXES boxCount ! ;

: add-light ( F: x y r -- )
   nlights @ MAXL >= if fdrop fdrop fdrop exit then
   nlights @ lr sf!
   nlights @ lp Vector2!
   true nlights @ cells lactive + !
   1 nlights +! ;

: example
   screenWidth screenHeight z" raylib [shapes] example - top down lights" InitWindow
   setup-boxes
   img 64 64 32 32 DARKBROWN DARKGRAY GenImageChecked drop
   bgtex img LoadTextureFromImage drop
   img UnloadImage
   0 nlights !
   600e 400e 300e add-light
   false showLines !
   60 SetTargetFPS
   begin
      MOUSE_BUTTON_LEFT IsMouseButtonDown if
         mouse@ 0 lp 8 move then
      MOUSE_BUTTON_RIGHT IsMouseButtonPressed nlights @ MAXL < and if
         mouse@ v2x mouse@ v2y 200e add-light then
      KEY_F1 IsKeyPressed if showLines @ 0= showLines ! then
      BeginDrawing
         BLACK ClearBackground
         0e 0e GetScreenWidth s>f GetScreenHeight s>f reca Rectangle!
         bgtex reca origin2 WHITE DrawTextureRec
         0 0 screenWidth screenHeight BLACK 0.65e Fade DrawRectangle
         nlights @ 0 do
            i cells lactive + @ if
               i lp v2x f>s i lp v2y f>s i lr sf@ WHITE 0e ColorAlpha WHITE DrawCircleGradient
            then
         loop
         boxCount @ 0 do
            i box DARKBROWN DrawRectangleRec
            i box rec.x f>s i box rec.y f>s i box rec.w f>s i box rec.h f>s DARKBLUE DrawRectangleLines
         loop
         nlights @ 0 do
            i cells lactive + @ if
               i lp v2x f>s i lp v2y f>s 10  i 0 = if YELLOW else WHITE then DrawCircle
            then
         loop
         showLines @ if
            boxCount @ 0 do
               i box 0.4e Fade DARKPURPLE DrawRectangleRec
            loop
            z" (F1) Hide Shadow Volumes" 10 50 10 GREEN DrawText
         else
            z" (F1) Show Shadow Volumes" 10 50 10 GREEN DrawText
         then
         screenWidth 80 - 10 DrawFPS
         z" Drag to move light #1" 10 10 10 DARKGREEN DrawText
         z" Right click to add new light" 10 30 10 DARKGREEN DrawText
      EndDrawing
   WindowShouldClose until
   bgtex UnloadTexture
   CloseWindow ;

example-end
