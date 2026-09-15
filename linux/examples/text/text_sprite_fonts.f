\ Port of raylib examples/text/text_sprite_fonts.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
8 CONSTANT MAX_FONTS

CREATE fonts 8 64 * ALLOT
CREATE positions 8 8 * ALLOT
CREATE tsz 16 ALLOT
CREATE spacings  2 , 4 , 8 , 4 , 3 , 4 , 4 , 1 ,
CREATE colors MAROON , ORANGE , DARKGREEN , DARKBLUE , DARKPURPLE , LIME , GOLD , RED ,

: font[] ( i -- a ) 64 * fonts + ;
: pos[] ( i -- a ) 8 * positions + ;
: sp[] ( i -- n ) cells spacings + @ ;
: col[] ( i -- u ) cells colors + @ ;

: msg[] ( i -- z )
   dup 0 = if drop z" ALAGARD FONT designed by Hewett Tsoi" else
   dup 1 = if drop z" PIXELPLAY FONT designed by Aleksander Shevchuk" else
   dup 2 = if drop z" MECHA FONT designed by Captain Falcon" else
   dup 3 = if drop z" SETBACK FONT designed by Brian Kent (AEnigma)" else
   dup 4 = if drop z" ROMULUS FONT designed by Hewett Tsoi" else
   dup 5 = if drop z" PIXANTIQUA FONT designed by Gerhard Grossmann" else
   dup 6 = if drop z" ALPHA_BETA FONT designed by Brian Kent (AEnigma)" else
   drop z" JUPITER_CRASH FONT designed by Brian Kent (AEnigma)"
   then then then then then then then ;

: example
   screenWidth screenHeight z" raylib [text] example - sprite fonts" InitWindow
   0 font[] z" /home/dave/Code/raylib/examples/text/resources/sprite_fonts/alagard.png" LoadFont drop
   1 font[] z" /home/dave/Code/raylib/examples/text/resources/sprite_fonts/pixelplay.png" LoadFont drop
   2 font[] z" /home/dave/Code/raylib/examples/text/resources/sprite_fonts/mecha.png" LoadFont drop
   3 font[] z" /home/dave/Code/raylib/examples/text/resources/sprite_fonts/setback.png" LoadFont drop
   4 font[] z" /home/dave/Code/raylib/examples/text/resources/sprite_fonts/romulus.png" LoadFont drop
   5 font[] z" /home/dave/Code/raylib/examples/text/resources/sprite_fonts/pixantiqua.png" LoadFont drop
   6 font[] z" /home/dave/Code/raylib/examples/text/resources/sprite_fonts/alpha_beta.png" LoadFont drop
   7 font[] z" /home/dave/Code/raylib/examples/text/resources/sprite_fonts/jupiter_crash.png" LoadFont drop
   MAX_FONTS 0 do
      tsz i font[] i msg[] i font[] font_baseSize l@ s>f 2e f* i sp[] s>f MeasureTextEx drop
      screenWidth s>f 2e f/ tsz sf@ 2e f/ f-
      60e i font[] font_baseSize l@ s>f f+ 45e i s>f f* f+
      i pos[] Vector2!
   loop
   3 pos[] v2x 3 pos[] v2y 8e f+ 3 pos[] Vector2!
   4 pos[] v2x 4 pos[] v2y 2e f+ 4 pos[] Vector2!
   7 pos[] v2x 7 pos[] v2y 8e f- 7 pos[] Vector2!
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         z" free sprite fonts included with raylib" 220 20 20 DARKGRAY DrawText
         220 50 600 50 DARKGRAY DrawLine
         MAX_FONTS 0 do
            i font[] i msg[] i pos[] i font[] font_baseSize l@ s>f 2e f* i sp[] s>f i col[] DrawTextEx
         loop
      EndDrawing
   WindowShouldClose until
   MAX_FONTS 0 do i font[] UnloadFont loop
   CloseWindow ;

example-end
