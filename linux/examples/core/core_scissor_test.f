\ Port of raylib examples/core/core_scissor_test.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE scissorArea 16 ALLOT
VARIABLE scissorMode

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   0e 0e 300e 300e scissorArea Rectangle!
   1 scissorMode !
   screenWidth screenHeight z" raylib [core] example - scissor test" InitWindow
   60 SetTargetFPS
   begin
      KEY_S IsKeyPressed 1 and if scissorMode @ 0= scissorMode ! then
      GetMouseX s>f scissorArea 8 + sf@ f2/ f- scissorArea sf!
      GetMouseY s>f scissorArea 12 + sf@ f2/ f- scissorArea 4 + sf!
      BeginDrawing
         RAYWHITE ClearBackground
         scissorMode @ if
            scissorArea sf@ f>s  scissorArea 4 + sf@ f>s
            scissorArea 8 + sf@ f>s  scissorArea 12 + sf@ f>s
            BeginScissorMode
         then
         0 0 GetScreenWidth GetScreenHeight RED DrawRectangle
         z" Move the mouse around to reveal this text!" 190 200 20 LIGHTGRAY DrawText
         scissorMode @ if EndScissorMode then
         scissorArea 1e BLACK DrawRectangleLinesEx
         z" Press S to toggle scissor test" 10 10 20 BLACK DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
