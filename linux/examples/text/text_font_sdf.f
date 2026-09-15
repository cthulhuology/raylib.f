\ Port of raylib examples/text/text_font_sdf.c
\ Partial: SDF atlas/LoadFontData extras not bound as in the C sample.
\ Loads a TTF via LoadFontEx, optional sdf.fs shader, and draws scalable text.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE fontDefault 64 ALLOT
CREATE fontSDF 64 ALLOT
CREATE shader 32 ALLOT
CREATE fontPosition 16 ALLOT
CREATE textSize 16 ALLOT
FVARIABLE fontSize
VARIABLE currentFont

: (f2.) ( F: r -- c-addr u )
   fdup f0< if fnegate 1 else 0 then >r
   100e f* 0.5e f+ f>s  0 <# # # [char] . hold #s r> if [char] - hold then #> ;

: example
   screenWidth screenHeight z" raylib [text] example - font sdf" InitWindow
   fontDefault z" /home/dave/Code/raylib/examples/text/resources/anonymous_pro_bold.ttf" 16 0 0 LoadFontEx drop
   fontSDF z" /home/dave/Code/raylib/examples/text/resources/anonymous_pro_bold.ttf" 16 0 0 LoadFontEx drop
   shader 0 z" /home/dave/Code/raylib/examples/text/resources/shaders/glsl330/sdf.fs" LoadShader drop
   fontSDF font_texture TEXTURE_FILTER_BILINEAR SetTextureFilter
   40e screenHeight s>f 2e f/ 50e f- fontPosition Vector2!
   16e fontSize f!
   0 currentFont !
   60 SetTargetFPS
   begin
      GetMouseWheelMove 8e f* fontSize f@ f+ fontSize f!
      fontSize f@ 6e f< if 6e fontSize f! then
      KEY_SPACE down if 1 else 0 then currentFont !
      currentFont @ if
         textSize fontSDF z" Signed Distance Fields" fontSize f@ 0e MeasureTextEx drop
      else
         textSize fontDefault z" Signed Distance Fields" fontSize f@ 0e MeasureTextEx drop
      then
      GetScreenWidth s>f 2e f/ textSize sf@ 2e f/ f-
      GetScreenHeight s>f 2e f/ textSize 4 + sf@ 2e f/ f- 80e f+
      fontPosition Vector2!
      BeginDrawing
         RAYWHITE ClearBackground
         currentFont @ if
            shader BeginShaderMode
               fontSDF z" Signed Distance Fields" fontPosition fontSize f@ 0e BLACK DrawTextEx
            EndShaderMode
            fontSDF font_texture 10 10 BLACK DrawTexture
            z" SDF!" 320 20 80 RED DrawText
         else
            fontDefault z" Signed Distance Fields" fontPosition fontSize f@ 0e BLACK DrawTextEx
            fontDefault font_texture 10 10 BLACK DrawTexture
            z" default font" 315 40 30 GRAY DrawText
         then
         z" FONT SIZE: 16.0" GetScreenWidth 240 - 20 20 DARKGRAY DrawText
         z" RENDER SIZE: " GetScreenWidth 240 - 50 20 DARKGRAY DrawText
         fontSize f@ (f2.) zres GetScreenWidth 80 - 50 20 DARKGRAY DrawText
         z" Use MOUSE WHEEL to SCALE TEXT!" GetScreenWidth 240 - 90 10 DARKGRAY DrawText
         z" HOLD SPACE to USE SDF FONT VERSION!" 340 GetScreenHeight 30 - 20 MAROON DrawText
         z" Partial: SDF atlas via LoadFontData/GenImageFontAtlas not ported" 10 GetScreenHeight 50 - 10 ORANGE DrawText
      EndDrawing
   WindowShouldClose until
   fontDefault UnloadFont
   fontSDF UnloadFont
   shader UnloadShader
   CloseWindow ;

example-end
