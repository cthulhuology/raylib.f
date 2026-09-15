\ Port of raylib examples/text/text_font_spritefont.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE font1 64 ALLOT
CREATE font2 64 ALLOT
CREATE font3 64 ALLOT
CREATE fontPosition1 16 ALLOT
CREATE fontPosition2 16 ALLOT
CREATE fontPosition3 16 ALLOT
CREATE tsz 16 ALLOT

: example
   screenWidth screenHeight z" raylib [text] example - font spritefont" InitWindow
   font1 z" /home/dave/Code/raylib/examples/text/resources/custom_mecha.png" LoadFont drop
   font2 z" /home/dave/Code/raylib/examples/text/resources/custom_alagard.png" LoadFont drop
   font3 z" /home/dave/Code/raylib/examples/text/resources/custom_jupiter_crash.png" LoadFont drop
   tsz font1 z" THIS IS A custom SPRITE FONT..." font1 font_baseSize l@ s>f -3e MeasureTextEx drop
   screenWidth s>f 2e f/ tsz sf@ 2e f/ f-
   screenHeight s>f 2e f/ font1 font_baseSize l@ s>f 2e f/ f- 80e f-
   fontPosition1 Vector2!
   tsz font2 z" ...and this is ANOTHER CUSTOM font..." font2 font_baseSize l@ s>f -2e MeasureTextEx drop
   screenWidth s>f 2e f/ tsz sf@ 2e f/ f-
   screenHeight s>f 2e f/ font2 font_baseSize l@ s>f 2e f/ f- 10e f-
   fontPosition2 Vector2!
   tsz font3 z" ...and a THIRD one! GREAT! :D" font3 font_baseSize l@ s>f 2e MeasureTextEx drop
   screenWidth s>f 2e f/ tsz sf@ 2e f/ f-
   screenHeight s>f 2e f/ font3 font_baseSize l@ s>f 2e f/ f- 50e f+
   fontPosition3 Vector2!
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         font1 z" THIS IS A custom SPRITE FONT..." fontPosition1 font1 font_baseSize l@ s>f -3e WHITE DrawTextEx
         font2 z" ...and this is ANOTHER CUSTOM font..." fontPosition2 font2 font_baseSize l@ s>f -2e WHITE DrawTextEx
         font3 z" ...and a THIRD one! GREAT! :D" fontPosition3 font3 font_baseSize l@ s>f 2e WHITE DrawTextEx
      EndDrawing
   WindowShouldClose until
   font1 UnloadFont
   font2 UnloadFont
   font3 UnloadFont
   CloseWindow ;

example-end
