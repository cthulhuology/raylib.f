\ Port of raylib examples/textures/textures_srcrec_dstrec.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE scarfy 32 ALLOT
CREATE sourceRec 16 ALLOT
CREATE destRec 16 ALLOT
CREATE origin 16 ALLOT
VARIABLE rotation
VARIABLE frameWidth
VARIABLE frameHeight

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   screenWidth screenHeight z" raylib [textures] example - srcrec dstrec" InitWindow
   scarfy z" /home/dave/Code/raylib/examples/textures/resources/scarfy.png" LoadTexture drop
   scarfy texture_width l@ 6 / frameWidth !
   scarfy texture_height l@ frameHeight !
   0e 0e frameWidth @ s>f frameHeight @ s>f sourceRec Rec!
   screenWidth s>f 2e f/  screenHeight s>f 2e f/  frameWidth @ 2* s>f  frameHeight @ 2* s>f destRec Rec!
   frameWidth @ s>f frameHeight @ s>f origin Vector2!
   0 rotation !
   60 SetTargetFPS
   begin
      1 rotation +!
      BeginDrawing
         RAYWHITE ClearBackground
         scarfy sourceRec destRec origin rotation @ s>f WHITE DrawTexturePro
         destRec sf@ f>s 0 destRec sf@ f>s screenHeight GRAY DrawLine
         0 destRec 4 + sf@ f>s screenWidth destRec 4 + sf@ f>s GRAY DrawLine
         z" (c) Scarfy sprite by Eiden Marsal" screenWidth 200 - screenHeight 20 - 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   scarfy UnloadTexture
   CloseWindow ;

example-end
