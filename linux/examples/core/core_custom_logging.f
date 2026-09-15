\ Port of raylib examples/core/core_custom_logging.c
\ partial: missing Forth va_list TraceLogCallback

800 CONSTANT screenWidth
450 CONSTANT screenHeight

: example
   screenWidth screenHeight z" raylib [core] example - custom logging" InitWindow
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         z" Check out the console output to see the custom logger in action!" 60 200 20 LIGHTGRAY DrawText
         z" partial: missing TraceLogCallback/va_list" 60 240 20 MAROON DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
