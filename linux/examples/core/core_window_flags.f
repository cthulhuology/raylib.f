\ Port of raylib examples/core/core_window_flags.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE ballPosition 8 ALLOT
CREATE ballSpeed 8 ALLOT
20e fconstant ballRadius
VARIABLE framesCounter
CREATE rec 16 ALLOT

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: flag-on  ( z x y -- )  10 BLACK DrawText drop drop drop ; \ unused

: example
   screenWidth screenHeight z" raylib [core] example - window flags" InitWindow
   GetScreenWidth 2/ s>f GetScreenHeight 2/ s>f ballPosition Vector2!
   5e 4e ballSpeed Vector2!
   0 framesCounter !
   60 SetTargetFPS
   begin
      KEY_F IsKeyPressed 1 and if ToggleFullscreen then
      KEY_R IsKeyPressed 1 and if
         FLAG_WINDOW_RESIZABLE IsWindowState 1 and if FLAG_WINDOW_RESIZABLE ClearWindowState
         else FLAG_WINDOW_RESIZABLE SetWindowState then
      then
      KEY_D IsKeyPressed 1 and if
         FLAG_WINDOW_UNDECORATED IsWindowState 1 and if FLAG_WINDOW_UNDECORATED ClearWindowState
         else FLAG_WINDOW_UNDECORATED SetWindowState then
      then
      KEY_H IsKeyPressed 1 and if
         FLAG_WINDOW_HIDDEN IsWindowState 1 and 0= if FLAG_WINDOW_HIDDEN SetWindowState then
         0 framesCounter !
      then
      FLAG_WINDOW_HIDDEN IsWindowState 1 and if
         1 framesCounter +!
         framesCounter @ 240 >= if FLAG_WINDOW_HIDDEN ClearWindowState then
      then
      KEY_N IsKeyPressed 1 and if
         FLAG_WINDOW_MINIMIZED IsWindowState 1 and 0= if MinimizeWindow then
         0 framesCounter !
      then
      FLAG_WINDOW_MINIMIZED IsWindowState 1 and if
         1 framesCounter +!
         framesCounter @ 240 >= if RestoreWindow 0 framesCounter ! then
      then
      KEY_M IsKeyPressed 1 and if
         FLAG_WINDOW_MAXIMIZED IsWindowState 1 and if RestoreWindow else MaximizeWindow then
      then
      KEY_U IsKeyPressed 1 and if
         FLAG_WINDOW_UNFOCUSED IsWindowState 1 and if FLAG_WINDOW_UNFOCUSED ClearWindowState
         else FLAG_WINDOW_UNFOCUSED SetWindowState then
      then
      KEY_T IsKeyPressed 1 and if
         FLAG_WINDOW_TOPMOST IsWindowState 1 and if FLAG_WINDOW_TOPMOST ClearWindowState
         else FLAG_WINDOW_TOPMOST SetWindowState then
      then
      KEY_A IsKeyPressed 1 and if
         FLAG_WINDOW_ALWAYS_RUN IsWindowState 1 and if FLAG_WINDOW_ALWAYS_RUN ClearWindowState
         else FLAG_WINDOW_ALWAYS_RUN SetWindowState then
      then
      KEY_V IsKeyPressed 1 and if
         FLAG_VSYNC_HINT IsWindowState 1 and if FLAG_VSYNC_HINT ClearWindowState
         else FLAG_VSYNC_HINT SetWindowState then
      then
      KEY_B IsKeyPressed 1 and if ToggleBorderlessWindowed then
      ballPosition v2x ballSpeed v2x f+  ballPosition v2y ballSpeed v2y f+  ballPosition Vector2!
      ballPosition v2x GetScreenWidth s>f ballRadius f- f>=
      ballPosition v2x ballRadius f<= or if
         ballSpeed v2x fnegate ballSpeed v2y ballSpeed Vector2!
      then
      ballPosition v2y GetScreenHeight s>f ballRadius f- f>=
      ballPosition v2y ballRadius f<= or if
         ballSpeed v2x ballSpeed v2y fnegate ballSpeed Vector2!
      then
      BeginDrawing
         FLAG_WINDOW_TRANSPARENT IsWindowState 1 and if TRANSPARENT else RAYWHITE then ClearBackground
         ballPosition ballRadius MAROON DrawCircleV
         0e 0e GetScreenWidth s>f GetScreenHeight s>f rec Rectangle!
         rec 4e RAYWHITE DrawRectangleLinesEx
         mouse@ 10e DARKBLUE DrawCircleV
         10 10 DrawFPS
         z" Screen Size: [" 10 40 10 GREEN DrawText
         GetScreenWidth n>z 90 40 10 GREEN DrawText
         z" Following flags can be set after window creation:" 10 60 10 GRAY DrawText
         FLAG_FULLSCREEN_MODE IsWindowState 1 and if
            z" [F] FLAG_FULLSCREEN_MODE: on" 10 80 10 LIME DrawText
         else z" [F] FLAG_FULLSCREEN_MODE: off" 10 80 10 MAROON DrawText then
         FLAG_WINDOW_RESIZABLE IsWindowState 1 and if
            z" [R] FLAG_WINDOW_RESIZABLE: on" 10 100 10 LIME DrawText
         else z" [R] FLAG_WINDOW_RESIZABLE: off" 10 100 10 MAROON DrawText then
         FLAG_WINDOW_UNDECORATED IsWindowState 1 and if
            z" [D] FLAG_WINDOW_UNDECORATED: on" 10 120 10 LIME DrawText
         else z" [D] FLAG_WINDOW_UNDECORATED: off" 10 120 10 MAROON DrawText then
         FLAG_WINDOW_HIDDEN IsWindowState 1 and if
            z" [H] FLAG_WINDOW_HIDDEN: on" 10 140 10 LIME DrawText
         else z" [H] FLAG_WINDOW_HIDDEN: off (hides for 3 seconds)" 10 140 10 MAROON DrawText then
         FLAG_WINDOW_MINIMIZED IsWindowState 1 and if
            z" [N] FLAG_WINDOW_MINIMIZED: on" 10 160 10 LIME DrawText
         else z" [N] FLAG_WINDOW_MINIMIZED: off (restores after 3 seconds)" 10 160 10 MAROON DrawText then
         FLAG_WINDOW_MAXIMIZED IsWindowState 1 and if
            z" [M] FLAG_WINDOW_MAXIMIZED: on" 10 180 10 LIME DrawText
         else z" [M] FLAG_WINDOW_MAXIMIZED: off" 10 180 10 MAROON DrawText then
         FLAG_WINDOW_UNFOCUSED IsWindowState 1 and if
            z" [U] FLAG_WINDOW_UNFOCUSED: on" 10 200 10 LIME DrawText
         else z" [U] FLAG_WINDOW_UNFOCUSED: off" 10 200 10 MAROON DrawText then
         FLAG_WINDOW_TOPMOST IsWindowState 1 and if
            z" [T] FLAG_WINDOW_TOPMOST: on" 10 220 10 LIME DrawText
         else z" [T] FLAG_WINDOW_TOPMOST: off" 10 220 10 MAROON DrawText then
         FLAG_WINDOW_ALWAYS_RUN IsWindowState 1 and if
            z" [A] FLAG_WINDOW_ALWAYS_RUN: on" 10 240 10 LIME DrawText
         else z" [A] FLAG_WINDOW_ALWAYS_RUN: off" 10 240 10 MAROON DrawText then
         FLAG_VSYNC_HINT IsWindowState 1 and if
            z" [V] FLAG_VSYNC_HINT: on" 10 260 10 LIME DrawText
         else z" [V] FLAG_VSYNC_HINT: off" 10 260 10 MAROON DrawText then
         FLAG_BORDERLESS_WINDOWED_MODE IsWindowState 1 and if
            z" [B] FLAG_BORDERLESS_WINDOWED_MODE: on" 10 280 10 LIME DrawText
         else z" [B] FLAG_BORDERLESS_WINDOWED_MODE: off" 10 280 10 MAROON DrawText then
         z" Following flags can only be set before window creation:" 10 320 10 GRAY DrawText
         FLAG_WINDOW_HIGHDPI IsWindowState 1 and if
            z" FLAG_WINDOW_HIGHDPI: on" 10 340 10 LIME DrawText
         else z" FLAG_WINDOW_HIGHDPI: off" 10 340 10 MAROON DrawText then
         FLAG_WINDOW_TRANSPARENT IsWindowState 1 and if
            z" FLAG_WINDOW_TRANSPARENT: on" 10 360 10 LIME DrawText
         else z" FLAG_WINDOW_TRANSPARENT: off" 10 360 10 MAROON DrawText then
         FLAG_MSAA_4X_HINT IsWindowState 1 and if
            z" FLAG_MSAA_4X_HINT: on" 10 380 10 LIME DrawText
         else z" FLAG_MSAA_4X_HINT: off" 10 380 10 MAROON DrawText then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
