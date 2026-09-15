\ Port of raylib examples/core/core_3d_camera_split_screen.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE cameraPlayer1 44 ALLOT
CREATE cameraPlayer2 44 ALLOT
CREATE screenPlayer1 44 ALLOT
CREATE screenPlayer2 44 ALLOT
CREATE splitScreenRect 16 ALLOT
CREATE planePos 12 ALLOT
CREATE planeSize 8 ALLOT
CREATE cube 12 ALLOT
CREATE origin 8 ALLOT
5 CONSTANT count
4e fconstant spacing

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: cam-pos ( c -- a ) ;
: cam-tgt ( c -- a ) Camera.target ;
: cam-up  ( c -- a ) Camera.up ;
: cam-fovy ( c -- a ) Camera.fovy ;
: cam-proj ( c -- a ) Camera.proj ;

: draw-world
   0e 0e 0e planePos Vector3!
   50e 50e planeSize Vector2!
   planePos planeSize BEIGE DrawPlane
   count s>f spacing f* fnegate
   begin
      fdup count s>f spacing f* f<=
   while
      fdup  \ x
      count s>f spacing f* fnegate
      begin
         fdup count s>f spacing f* f<=
      while
         fover 1.5e fover cube Vector3!
         cube 1e 1e 1e LIME DrawCube
         fover 0.5e fover cube Vector3!
         cube 0.25e 1e 0.25e BROWN DrawCube
         spacing f+
      repeat
      fdrop
      spacing f+
   repeat
   fdrop
   cameraPlayer1 cam-pos 1e 1e 1e RED DrawCube
   cameraPlayer2 cam-pos 1e 1e 1e BLUE DrawCube ;

: example
   cameraPlayer1 44 erase
   cameraPlayer2 44 erase
   45e cameraPlayer1 cam-fovy sf!
   0e 1e 0e cameraPlayer1 cam-up Vector3!
   0e 1e 0e cameraPlayer1 cam-tgt Vector3!
   0e 1e -3e cameraPlayer1 cam-pos Vector3!
   CAMERA_PERSPECTIVE cameraPlayer1 cam-proj l!
   45e cameraPlayer2 cam-fovy sf!
   0e 1e 0e cameraPlayer2 cam-up Vector3!
   0e 3e 0e cameraPlayer2 cam-tgt Vector3!
   -3e 3e 0e cameraPlayer2 cam-pos Vector3!
   CAMERA_PERSPECTIVE cameraPlayer2 cam-proj l!
   screenWidth screenHeight z" raylib [core] example - 3d camera split screen" InitWindow
   screenPlayer1 screenWidth 2/ screenHeight LoadRenderTexture drop
   screenPlayer2 screenWidth 2/ screenHeight LoadRenderTexture drop
   0e 0e
   screenPlayer1 8 + l@ s>f
   screenPlayer1 12 + l@ s>f fnegate
   splitScreenRect Rectangle!
   0e 0e origin Vector2!
   60 SetTargetFPS
   begin
      10e GetFrameTime f*  \ offsetThisFrame
      KEY_W down if
         fdup cameraPlayer1 cam-pos .z f+ cameraPlayer1 cam-pos .z!
         fdup cameraPlayer1 cam-tgt .z f+ cameraPlayer1 cam-tgt .z!
      else KEY_S down if
         fdup fnegate cameraPlayer1 cam-pos .z f+ cameraPlayer1 cam-pos .z!
         fdup fnegate cameraPlayer1 cam-tgt .z f+ cameraPlayer1 cam-tgt .z!
      then then
      KEY_UP down if
         fdup cameraPlayer2 cam-pos .x f+ cameraPlayer2 cam-pos .x!
         fdup cameraPlayer2 cam-tgt .x f+ cameraPlayer2 cam-tgt .x!
      else KEY_DOWN down if
         fdup fnegate cameraPlayer2 cam-pos .x f+ cameraPlayer2 cam-pos .x!
         fdup fnegate cameraPlayer2 cam-tgt .x f+ cameraPlayer2 cam-tgt .x!
      then then
      fdrop
      screenPlayer1 BeginTextureMode
         SKYBLUE ClearBackground
         cameraPlayer1 BeginMode3D
            draw-world
         EndMode3D
         0 0 GetScreenWidth 2/ 40 RAYWHITE 0.8e Fade DrawRectangle
         z" PLAYER1: W/S to move" 10 10 20 MAROON DrawText
      EndTextureMode
      screenPlayer2 BeginTextureMode
         SKYBLUE ClearBackground
         cameraPlayer2 BeginMode3D
            draw-world
         EndMode3D
         0 0 GetScreenWidth 2/ 40 RAYWHITE 0.8e Fade DrawRectangle
         z" PLAYER2: UP/DOWN to move" 10 10 20 DARKBLUE DrawText
      EndTextureMode
      BeginDrawing
         BLACK ClearBackground
         0e 0e origin Vector2!
         screenPlayer1 4 + splitScreenRect origin WHITE DrawTextureRec
         screenWidth 2/ s>f 0e origin Vector2!
         screenPlayer2 4 + splitScreenRect origin WHITE DrawTextureRec
         GetScreenWidth 2/ 2 -  0  4  GetScreenHeight LIGHTGRAY DrawRectangle
      EndDrawing
   WindowShouldClose until
   screenPlayer1 UnloadRenderTexture
   screenPlayer2 UnloadRenderTexture
   CloseWindow ;

example-end
