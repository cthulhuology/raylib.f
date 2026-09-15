\ Port of raylib examples/others/raylib_opengl_interop.c
\ SKIP: OpenGL interop (glad) is not available from this Forth FFI.
: example
   800 450 z" raylib [others] SKIP - opengl interop" InitWindow
   begin BeginDrawing RAYWHITE ClearBackground
      z" SKIP: raylib_opengl_interop.c" 40 200 20 DARKGRAY DrawText
   EndDrawing WindowShouldClose until CloseWindow ;
example-end
