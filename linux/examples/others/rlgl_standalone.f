\ Port of raylib examples/others/rlgl_standalone.c
\ SKIP: standalone rlgl/GLFW is not available from this Forth FFI.
: example
   800 450 z" raylib [others] SKIP - rlgl standalone" InitWindow
   begin BeginDrawing RAYWHITE ClearBackground
      z" SKIP: rlgl_standalone.c" 40 200 20 DARKGRAY DrawText
   EndDrawing WindowShouldClose until CloseWindow ;
example-end
