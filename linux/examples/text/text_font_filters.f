\ Port of raylib examples/text/text_font_filters.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE font 64 ALLOT
CREATE fontPosition 16 ALLOT
CREATE textSize 16 ALLOT
CREATE dropped 32 ALLOT
FVARIABLE fontSize
VARIABLE currentFontFilter

: (f2.) ( F: r -- c-addr u )
   fdup f0< if fnegate 1 else 0 then >r
   100e f* 0.5e f+ f>s  0 <# # # [char] . hold #s r> if [char] - hold then #> ;

: example
   screenWidth screenHeight z" raylib [text] example - font filters" InitWindow
   font z" /home/dave/Code/raylib/examples/text/resources/KAISG.ttf" 96 0 0 LoadFontEx drop
   font font_texture GenTextureMipmaps
   font font_baseSize l@ s>f fontSize f!
   40e screenHeight s>f 2e f/ 80e f- fontPosition Vector2!
   font font_texture TEXTURE_FILTER_POINT SetTextureFilter
   0 currentFontFilter !
   60 SetTargetFPS
   begin
      GetMouseWheelMove 4e f* fontSize f@ f+ fontSize f!
      KEY_ONE IsKeyPressed if font font_texture TEXTURE_FILTER_POINT SetTextureFilter  0 currentFontFilter ! then
      KEY_TWO IsKeyPressed if font font_texture TEXTURE_FILTER_BILINEAR SetTextureFilter  1 currentFontFilter ! then
      KEY_THREE IsKeyPressed if font font_texture TEXTURE_FILTER_TRILINEAR SetTextureFilter  2 currentFontFilter ! then
      textSize font z" Loaded Font" fontSize f@ 0e MeasureTextEx drop
      KEY_LEFT down if fontPosition v2x 10e f- fontPosition v2y fontPosition Vector2! then
      KEY_RIGHT down if fontPosition v2x 10e f+ fontPosition v2y fontPosition Vector2! then
      IsFileDropped if
         dropped LoadDroppedFiles drop
         dropped filePathList_paths @ @ z" .ttf" IsFileExtension if
            font UnloadFont
            font dropped filePathList_paths @ @ fontSize f@ f>s 0 0 LoadFontEx drop
         then
         dropped UnloadDroppedFiles
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" Use mouse wheel to change font size" 20 20 10 GRAY DrawText
         z" Use KEY_RIGHT and KEY_LEFT to move text" 20 40 10 GRAY DrawText
         z" Use 1, 2, 3 to change texture filter" 20 60 10 GRAY DrawText
         z" Drop a new TTF font for dynamic loading" 20 80 10 DARKGRAY DrawText
         font z" Loaded Font" fontPosition fontSize f@ 0e BLACK DrawTextEx
         0 screenHeight 80 - screenWidth 80 LIGHTGRAY DrawRectangle
         z" Font size: " 20 screenHeight 50 - 10 DARKGRAY DrawText
         fontSize f@ (f2.) zres 90 screenHeight 50 - 10 DARKGRAY DrawText
         z" Text size: " 20 screenHeight 30 - 10 DARKGRAY DrawText
         textSize sf@ (f2.) zres 90 screenHeight 30 - 10 DARKGRAY DrawText
         z" CURRENT TEXTURE FILTER:" 250 400 20 GRAY DrawText
         currentFontFilter @ 0 = if z" POINT" 570 400 20 BLACK DrawText else
         currentFontFilter @ 1 = if z" BILINEAR" 570 400 20 BLACK DrawText else
         z" TRILINEAR" 570 400 20 BLACK DrawText then then
      EndDrawing
   WindowShouldClose until
   font UnloadFont
   CloseWindow ;

example-end
