\ Port of raylib examples/textures/textures_background_scrolling.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE background 32 ALLOT
CREATE midground 32 ALLOT
CREATE foreground 32 ALLOT
CREATE pos 16 ALLOT

FVARIABLE scrollingBack
FVARIABLE scrollingMid
FVARIABLE scrollingFore

: example
   screenWidth screenHeight z" raylib [textures] example - background scrolling" InitWindow
   background z" /home/dave/Code/raylib/examples/textures/resources/cyberpunk_street_background.png" LoadTexture drop
   midground z" /home/dave/Code/raylib/examples/textures/resources/cyberpunk_street_midground.png" LoadTexture drop
   foreground z" /home/dave/Code/raylib/examples/textures/resources/cyberpunk_street_foreground.png" LoadTexture drop
   0e scrollingBack f!
   0e scrollingMid f!
   0e scrollingFore f!
   60 SetTargetFPS
   begin
      scrollingBack f@ 0.1e f- scrollingBack f!
      scrollingMid  f@ 0.5e f- scrollingMid  f!
      scrollingFore f@ 1.0e f- scrollingFore f!
      scrollingBack f@ background texture_width l@ 2* s>f fnegate f<= if 0e scrollingBack f! then
      scrollingMid  f@ midground  texture_width l@ 2* s>f fnegate f<= if 0e scrollingMid  f! then
      scrollingFore f@ foreground texture_width l@ 2* s>f fnegate f<= if 0e scrollingFore f! then
      BeginDrawing
         $052c46ff GetColor ClearBackground
         scrollingBack f@ 20e pos Vector2!
         background pos 0e 2e WHITE DrawTextureEx
         background texture_width l@ 2* s>f scrollingBack f@ f+ 20e pos Vector2!
         background pos 0e 2e WHITE DrawTextureEx
         scrollingMid f@ 20e pos Vector2!
         midground pos 0e 2e WHITE DrawTextureEx
         midground texture_width l@ 2* s>f scrollingMid f@ f+ 20e pos Vector2!
         midground pos 0e 2e WHITE DrawTextureEx
         scrollingFore f@ 70e pos Vector2!
         foreground pos 0e 2e WHITE DrawTextureEx
         foreground texture_width l@ 2* s>f scrollingFore f@ f+ 70e pos Vector2!
         foreground pos 0e 2e WHITE DrawTextureEx
         z" BACKGROUND SCROLLING & PARALLAX" 10 10 20 RED DrawText
         z" (c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)" screenWidth 330 - screenHeight 20 - 10 RAYWHITE DrawText
      EndDrawing
   WindowShouldClose until
   background UnloadTexture
   midground UnloadTexture
   foreground UnloadTexture
   CloseWindow ;

example-end
