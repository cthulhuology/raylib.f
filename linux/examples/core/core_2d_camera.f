\ Port of raylib examples/core/core_2d_camera.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
100 CONSTANT MAX_BUILDINGS

CREATE player 16 ALLOT
CREATE buildings  MAX_BUILDINGS 16 * ALLOT
CREATE buildColors  MAX_BUILDINGS CELLS ALLOT
CREATE camera 24 ALLOT
VARIABLE spacing

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: bldg ( i -- addr ) 16 * buildings + ;
: bcol ( i -- addr ) CELLS buildColors + ;

: cam-off  camera ;
: cam-tgt  camera 8 + ;
: cam-rot  camera 16 + ;
: cam-zoom camera 20 + ;

: init-buildings
   0 spacing !
   MAX_BUILDINGS 0 ?do
      50 200 GetRandomValue s>f  i bldg 8 + sf!
      100 800 GetRandomValue s>f i bldg 12 + sf!
      screenHeight s>f 130e f- i bldg 12 + sf@ f-  i bldg 4 + sf!
      -6000e spacing @ s>f f+  i bldg sf!
      spacing @ i bldg 8 + sf@ f>s + spacing !
      200 240 GetRandomValue  200 240 GetRandomValue  200 250 GetRandomValue  255 RGBA
      i bcol !
   loop ;

: example
   400e 280e 40e 40e player Rectangle!
   init-buildings
   player sf@ 20e f+  player 4 + sf@ 20e f+  cam-tgt Vector2!
   screenWidth 2/ s>f  screenHeight 2/ s>f  cam-off Vector2!
   0e cam-rot sf!
   1e cam-zoom sf!
   screenWidth screenHeight z" raylib [core] example - 2d camera" InitWindow
   60 SetTargetFPS
   begin
      KEY_RIGHT down if player sf@ 2e f+ player sf! else
      KEY_LEFT  down if player sf@ 2e f- player sf! then then
      player sf@ 20e f+  player 4 + sf@ 20e f+  cam-tgt Vector2!
      KEY_A down if cam-rot sf@ 1e f- cam-rot sf! else
      KEY_S down if cam-rot sf@ 1e f+ cam-rot sf! then then
      cam-rot sf@  40e f> if 40e cam-rot sf! then
      cam-rot sf@ -40e f< if -40e cam-rot sf! then
      cam-zoom sf@ fln  GetMouseWheelMove 0.1e f* f+ fexp  cam-zoom sf!
      cam-zoom sf@ 3e f> if 3e cam-zoom sf! then
      cam-zoom sf@ 0.1e f< if 0.1e cam-zoom sf! then
      KEY_R IsKeyPressed 1 and if
         1e cam-zoom sf!
         0e cam-rot sf!
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode2D
            -6000 320 13000 8000 DARKGRAY DrawRectangle
            MAX_BUILDINGS 0 ?do
               i bldg  i bcol @  DrawRectangleRec
            loop
            player RED DrawRectangleRec
            cam-tgt v2x f>s  screenHeight -10 *  cam-tgt v2x f>s  screenHeight 10 *  GREEN DrawLine
            screenWidth -10 *  cam-tgt v2y f>s  screenWidth 10 *  cam-tgt v2y f>s  GREEN DrawLine
         EndMode2D
         z" SCREEN AREA" 640 10 20 RED DrawText
         0 0 screenWidth 5 RED DrawRectangle
         0 5 5 screenHeight 10 - RED DrawRectangle
         screenWidth 5 - 5 5 screenHeight 10 - RED DrawRectangle
         0 screenHeight 5 - screenWidth 5 RED DrawRectangle
         10 10 250 113 SKYBLUE 0.5e Fade DrawRectangle
         10 10 250 113 BLUE DrawRectangleLines
         z" Free 2d camera controls:" 20 20 10 BLACK DrawText
         z" - Right/Left to move Offset" 40 40 10 DARKGRAY DrawText
         z" - Mouse Wheel to Zoom in-out" 40 60 10 DARKGRAY DrawText
         z" - A / S to Rotate" 40 80 10 DARKGRAY DrawText
         z" - R to reset Zoom and Rotation" 40 100 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
