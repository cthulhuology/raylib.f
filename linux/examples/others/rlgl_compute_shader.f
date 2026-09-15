\ Port of raylib examples/others/rlgl_compute_shader.c
\ SKIP: rlgl compute shaders are not bound in this Forth FFI.
: example
   800 450 z" raylib [others] SKIP - rlgl compute shader" InitWindow
   begin BeginDrawing RAYWHITE ClearBackground
      z" SKIP: rlgl_compute_shader.c" 40 200 20 DARKGRAY DrawText
   EndDrawing WindowShouldClose until CloseWindow ;
example-end
