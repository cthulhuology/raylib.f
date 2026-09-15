\ Port of raylib examples/core/core_2d_camera_split_screen.c

800 CONSTANT screenWidth
440 CONSTANT screenHeight
40 CONSTANT PLAYER_SIZE

CREATE player1 16 ALLOT
CREATE player2 16 ALLOT
CREATE camera1 24 ALLOT
CREATE camera2 24 ALLOT
CREATE screenCamera1 44 ALLOT
CREATE screenCamera2 44 ALLOT
CREATE splitScreenRect 16 ALLOT
CREATE origin 8 ALLOT
CREATE nbuf 64 ALLOT

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: cam-off ( cam -- addr ) ;
: cam-tgt ( cam -- addr ) 8 + ;

: draw-scene
   screenWidth PLAYER_SIZE / 1+ 0 ?do
      PLAYER_SIZE i * s>f 0e v2a Vector2!
      PLAYER_SIZE i * s>f screenHeight s>f v2b Vector2!
      v2a v2b LIGHTGRAY DrawLineV
   loop
   screenHeight PLAYER_SIZE / 1+ 0 ?do
      0e PLAYER_SIZE i * s>f v2a Vector2!
      screenWidth s>f PLAYER_SIZE i * s>f v2b Vector2!
      v2a v2b LIGHTGRAY DrawLineV
   loop
   screenWidth PLAYER_SIZE / 0 ?do
      screenHeight PLAYER_SIZE / 0 ?do
         z" ["  10 PLAYER_SIZE j * +  15 PLAYER_SIZE i * +  10 LIGHTGRAY DrawText
         j n>z  20 PLAYER_SIZE j * +  15 PLAYER_SIZE i * +  10 LIGHTGRAY DrawText
      loop
   loop
   player1 RED DrawRectangleRec
   player2 BLUE DrawRectangleRec ;

: example
   200e 200e PLAYER_SIZE s>f fdup player1 Rectangle!
   250e 200e PLAYER_SIZE s>f fdup player2 Rectangle!
   camera1 24 erase  camera2 24 erase
   player1 sf@ player1 4 + sf@ camera1 cam-tgt Vector2!
   200e 200e camera1 cam-off Vector2!
   0e camera1 16 + sf!  1e camera1 20 + sf!
   player2 sf@ player2 4 + sf@ camera2 cam-tgt Vector2!
   200e 200e camera2 cam-off Vector2!
   0e camera2 16 + sf!  1e camera2 20 + sf!
   0e 0e origin Vector2!
   screenWidth screenHeight z" raylib [core] example - 2d camera split screen" InitWindow
   screenCamera1 screenWidth 2/ screenHeight LoadRenderTexture drop
   screenCamera2 screenWidth 2/ screenHeight LoadRenderTexture drop
   0e 0e
   screenCamera1 8 + l@ s>f
   screenCamera1 12 + l@ s>f fnegate
   splitScreenRect Rectangle!
   60 SetTargetFPS
   begin
      KEY_S down if player1 4 + sf@ 3e f+ player1 4 + sf! else
      KEY_W down if player1 4 + sf@ 3e f- player1 4 + sf! then then
      KEY_D down if player1 sf@ 3e f+ player1 sf! else
      KEY_A down if player1 sf@ 3e f- player1 sf! then then
      KEY_UP    down if player2 4 + sf@ 3e f- player2 4 + sf! else
      KEY_DOWN  down if player2 4 + sf@ 3e f+ player2 4 + sf! then then
      KEY_RIGHT down if player2 sf@ 3e f+ player2 sf! else
      KEY_LEFT  down if player2 sf@ 3e f- player2 sf! then then
      player1 sf@ player1 4 + sf@ camera1 cam-tgt Vector2!
      player2 sf@ player2 4 + sf@ camera2 cam-tgt Vector2!
      screenCamera1 BeginTextureMode
         RAYWHITE ClearBackground
         camera1 BeginMode2D
            draw-scene
         EndMode2D
         0 0 GetScreenWidth 2/ 30 RAYWHITE 0.6e Fade DrawRectangle
         z" PLAYER1: W/S/A/D to move" 10 10 10 MAROON DrawText
      EndTextureMode
      screenCamera2 BeginTextureMode
         RAYWHITE ClearBackground
         camera2 BeginMode2D
            draw-scene
         EndMode2D
         0 0 GetScreenWidth 2/ 30 RAYWHITE 0.6e Fade DrawRectangle
         z" PLAYER2: UP/DOWN/LEFT/RIGHT to move" 10 10 10 DARKBLUE DrawText
      EndTextureMode
      BeginDrawing
         BLACK ClearBackground
         0e 0e origin Vector2!
         screenCamera1 4 + splitScreenRect origin WHITE DrawTextureRec
         screenWidth 2/ s>f 0e origin Vector2!
         screenCamera2 4 + splitScreenRect origin WHITE DrawTextureRec
         GetScreenWidth 2/ 2 -  0  4  GetScreenHeight  LIGHTGRAY DrawRectangle
      EndDrawing
   WindowShouldClose until
   screenCamera1 UnloadRenderTexture
   screenCamera2 UnloadRenderTexture
   CloseWindow ;

example-end
