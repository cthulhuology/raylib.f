\ Port of raylib examples/others/web_basic_window.c
\ SKIP: emscripten/web platform example.
: example
   800 450 z" raylib [others] SKIP - web basic window" InitWindow
   begin BeginDrawing RAYWHITE ClearBackground
      z" SKIP: web_basic_window.c" 40 200 20 DARKGRAY DrawText
   EndDrawing WindowShouldClose until CloseWindow ;
example-end
