\ Port of raylib examples/text/text_unicode_ranges.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE font 64 ALLOT
CREATE pos 16 ALLOT
CREATE src 16 ALLOT
CREATE dst 16 ALLOT
CREATE origin 16 ALLOT
VARIABLE unicodeRange
VARIABLE prevUnicodeRange

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: n>z ( n -- z ) dup 0< if abs 1 else 0 then >r 0 <# #s r> if [char] - hold then #> zres ;

: font-path ( -- z ) z" /home/dave/Code/raylib/examples/text/resources/NotoSansTC-Regular.ttf" ;

VARIABLE (fnt)
VARIABLE (path)
VARIABLE (start)
VARIABLE (stop)
VARIABLE (cur)
VARIABLE (tot)
VARIABLE (cps)

: AddCodepointRange ( font zpath start stop -- )
   (stop) ! (start) ! (path) ! (fnt) !
   (stop) @ (start) @ - 1+  (fnt) @ font_glyphCount l@  2dup + (tot) ! (cur) ! drop
   (tot) @ 4 * MemAlloc (cps) !
   (cur) @ 0 do
      (fnt) @ font_glyphs @ i 40 * + l@  (cps) @ i 4 * + l!
   loop
   (tot) @ (cur) @ ?do
      (start) @ i (cur) @ - +  (cps) @ i 4 * + l!
   loop
   (fnt) @ UnloadFont
   (fnt) @ (path) @ 32 (cps) @ (tot) @ LoadFontEx drop
   (cps) @ MemFree ;

: reload-ranges ( -- )
   font UnloadFont
   font font-path LoadFont drop
   unicodeRange @ 4 = if
      font font-path $4e00 $9fff AddCodepointRange
      font font-path $3400 $4dbf AddCodepointRange
      font font-path $3000 $303f AddCodepointRange
      font font-path $3040 $309f AddCodepointRange
      font font-path $30A0 $30ff AddCodepointRange
      font font-path $31f0 $31ff AddCodepointRange
      font font-path $ff00 $ffef AddCodepointRange
      font font-path $ac00 $d7af AddCodepointRange
      font font-path $1100 $11ff AddCodepointRange
   then
   unicodeRange @ 3 >= if
      font font-path $400 $4ff AddCodepointRange
      font font-path $500 $52f AddCodepointRange
      font font-path $2de0 $2Dff AddCodepointRange
      font font-path $a640 $A69f AddCodepointRange
   then
   unicodeRange @ 2 >= if
      font font-path $370 $3ff AddCodepointRange
      font font-path $1f00 $1fff AddCodepointRange
   then
   unicodeRange @ 1 >= if
      font font-path $c0 $17f AddCodepointRange
      font font-path $180 $24f AddCodepointRange
   then
   unicodeRange @ prevUnicodeRange !
   font font_texture TEXTURE_FILTER_BILINEAR SetTextureFilter ;

: example
   screenWidth screenHeight z" raylib [text] example - unicode ranges" InitWindow
   font font-path LoadFont drop
   font font_texture TEXTURE_FILTER_BILINEAR SetTextureFilter
   0 unicodeRange !
   0 prevUnicodeRange !
   0e 0e origin Vector2!
   60 SetTargetFPS
   begin
      unicodeRange @ prevUnicodeRange @ <> if reload-ranges then
      KEY_ZERO  IsKeyPressed if 0 unicodeRange ! then
      KEY_ONE   IsKeyPressed if 1 unicodeRange ! then
      KEY_TWO   IsKeyPressed if 2 unicodeRange ! then
      KEY_THREE IsKeyPressed if 3 unicodeRange ! then
      KEY_FOUR  IsKeyPressed if 4 unicodeRange ! then
      BeginDrawing
         RAYWHITE ClearBackground
         z" ADD CODEPOINTS: [1][2][3][4]" 20 20 20 MAROON DrawText
         50e 70e pos Vector2!  font z" > English: Hello World!" pos 32e 1e DARKGRAY DrawTextEx
         50e 120e pos Vector2! font z" > Espanol: Hola mundo!" pos 32e 1e DARKGRAY DrawTextEx
         50e 170e pos Vector2! font z" > Greek: Geia sou kosme!" pos 32e 1e DARKGRAY DrawTextEx
         50e 220e pos Vector2! font z" > Russian: Privet mir!" pos 32e 0e DARKGRAY DrawTextEx
         50e 270e pos Vector2! font z" > Chinese: Ni hao shi jie!" pos 32e 1e DARKGRAY DrawTextEx
         50e 320e pos Vector2! font z" > Japanese: Konnichiwa sekai!" pos 32e 1e DARKGRAY DrawTextEx
         380e font font_texture texture_width l@ s>f f/  ( atlasScale )
         400e 16e
         font font_texture texture_width l@ s>f fover f*
         font font_texture texture_height l@ s>f fover f*
         dst Rec!
         dst BLACK DrawRectangleRec
         0e 0e font font_texture texture_width l@ s>f font font_texture texture_height l@ s>f src Rec!
         font font_texture src dst origin 0e WHITE DrawTexturePro
         400 16 380 380 RED DrawRectangleLines
         z" ATLAS SIZE: " 20 380 20 BLUE DrawText
         font font_texture texture_width l@ n>z 160 380 20 BLUE DrawText
         z" x" 210 380 20 BLUE DrawText
         font font_texture texture_height l@ n>z 230 380 20 BLUE DrawText
         z" CODEPOINTS GLYPHS LOADED: " 20 410 20 LIME DrawText
         font font_glyphCount l@ n>z 320 410 20 LIME DrawText
         z" Font: Noto Sans TC. License: SIL Open Font License 1.1" screenWidth 300 - screenHeight 20 - 10 GRAY DrawText
         fdrop
      EndDrawing
   WindowShouldClose until
   font UnloadFont
   CloseWindow ;

example-end
