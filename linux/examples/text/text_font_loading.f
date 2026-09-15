\ Port of raylib examples/text/text_font_loading.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE fontBm 64 ALLOT
CREATE fontTtf 64 ALLOT
CREATE pos 16 ALLOT
CREATE fontmsg 128 ALLOT
VARIABLE useTtf

: setup-fontmsg
   s" !" fontmsg swap move
   [char] " fontmsg 1+ c!
   s" #$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI" fontmsg 2 + swap move
   0 fontmsg 41 + c! ;

: example
   screenWidth screenHeight z" raylib [text] example - font loading" InitWindow
   setup-fontmsg
   fontBm z" /home/dave/Code/raylib/examples/text/resources/pixantiqua.fnt" LoadFont drop
   fontTtf z" /home/dave/Code/raylib/examples/text/resources/pixantiqua.ttf" 32 0 250 LoadFontEx drop
   16 SetTextLineSpacing
   0 useTtf !
   60 SetTargetFPS
   begin
      KEY_SPACE down if 1 else 0 then useTtf !
      BeginDrawing
         RAYWHITE ClearBackground
         z" Hold SPACE to use TTF generated font" 20 20 20 LIGHTGRAY DrawText
         20e 100e pos Vector2!
         useTtf @ 0= if
            fontBm fontmsg pos fontBm font_baseSize l@ s>f 2e MAROON DrawTextEx
            z" Using BMFont (Angelcode) imported" 20 GetScreenHeight 30 - 20 GRAY DrawText
         else
            fontTtf fontmsg pos fontTtf font_baseSize l@ s>f 2e LIME DrawTextEx
            z" Using TTF font generated" 20 GetScreenHeight 30 - 20 GRAY DrawText
         then
      EndDrawing
   WindowShouldClose until
   fontBm UnloadFont
   fontTtf UnloadFont
   CloseWindow ;

example-end
