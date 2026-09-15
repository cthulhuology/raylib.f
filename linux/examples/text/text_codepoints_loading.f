\ Port of raylib examples/text/text_codepoints_loading.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE font 64 ALLOT
CREATE count 4 ALLOT
CREATE pos 16 ALLOT
CREATE cpsize 4 ALLOT
VARIABLE showFontAtlas
VARIABLE textPtr
VARIABLE codepoints
VARIABLE codepointsNoDups
VARIABLE codepointCount
VARIABLE codepointsNoDupsCount
VARIABLE uc-src
VARIABLE uc-n
VARIABLE uc-dst
VARIABLE uc-nq

: jp-text ( -- z )
   z" いろはにほへと　ちりぬるをわかよたれそ　つねならむうゐのおくやま　けふこえてあさきゆめみし　ゑひもせす" ;

: n>z ( n -- z ) dup 0< if abs 1 else 0 then >r 0 <# #s r> if [char] - hold then #> zres ;

\ Copy unique 32-bit codepoints from src[n] into newly allocated dst.
: uniquecp ( src n -- dst nuniq )
   uc-n !  uc-src !
   uc-n @ 4 * MemAlloc uc-dst !
   0 uc-nq !
   uc-n @ 0 ?do
      uc-src @ i 4 * + l@
      0
      uc-nq @ 0 ?do
         uc-dst @ i 4 * + l@  2 pick = or
      loop
      if drop else
         uc-dst @ uc-nq @ 4 * + l!
         1 uc-nq +!
      then
   loop
   uc-dst @ uc-nq @ ;

: example
   screenWidth screenHeight z" raylib [text] example - codepoints loading" InitWindow
   0 count l!
   jp-text count LoadCodepoints codepoints !
   count l@ codepointCount !
   codepoints @ codepointCount @ uniquecp codepointsNoDupsCount ! codepointsNoDups !
   font z" /home/dave/Code/raylib/examples/text/resources/DotGothic16-Regular.ttf"
      36 codepointsNoDups @ codepointsNoDupsCount @ LoadFontEx drop
   font font_texture TEXTURE_FILTER_BILINEAR SetTextureFilter
   20 SetTextLineSpacing
   codepoints @ UnloadCodepoints
   0 showFontAtlas !
   jp-text textPtr !
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if showFontAtlas @ 0= showFontAtlas ! then
      KEY_RIGHT IsKeyPressed if textPtr @ cpsize GetCodepointNext drop  cpsize l@ textPtr +! then
      KEY_LEFT  IsKeyPressed if textPtr @ cpsize GetCodepointPrevious drop  cpsize l@ negate textPtr +! then
      BeginDrawing
         RAYWHITE ClearBackground
         0 0 GetScreenWidth 70 BLACK DrawRectangle
         z" Total codepoints contained in provided text: " 10 10 20 GREEN DrawText
         codepointCount @ n>z 480 10 20 GREEN DrawText
         z" Total codepoints required for font atlas (duplicates excluded): " 10 40 20 GREEN DrawText
         codepointsNoDupsCount @ n>z 620 40 20 GREEN DrawText
         showFontAtlas @ if
            font font_texture 150 100 BLACK DrawTexture
            150 100 font font_texture texture_width l@ font font_texture texture_height l@ BLACK DrawRectangleLines
         else
            160e 110e pos Vector2!
            font jp-text pos 48e 5e BLACK DrawTextEx
         then
         z" Press SPACE to toggle font atlas view!" 10 GetScreenHeight 30 - 20 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   font UnloadFont
   codepointsNoDups @ MemFree
   CloseWindow ;

example-end
