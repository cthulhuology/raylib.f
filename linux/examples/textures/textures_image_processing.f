\ Port of raylib examples/textures/textures_image_processing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
9 CONSTANT NUM_PROCESSES

CREATE imOrigin 32 ALLOT
CREATE imCopy 32 ALLOT
CREATE texture 32 ALLOT
CREATE toggleRecs 9 16 * ALLOT
VARIABLE currentProcess
VARIABLE textureReload
VARIABLE mouseHoverRec

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: rec[] ( i -- a ) 16 * toggleRecs + ;

: process-name ( i -- z )
   dup 0 = if drop z" NO PROCESSING" else
   dup 1 = if drop z" COLOR GRAYSCALE" else
   dup 2 = if drop z" COLOR TINT" else
   dup 3 = if drop z" COLOR INVERT" else
   dup 4 = if drop z" COLOR CONTRAST" else
   dup 5 = if drop z" COLOR BRIGHTNESS" else
   dup 6 = if drop z" GAUSSIAN BLUR" else
   dup 7 = if drop z" FLIP VERTICAL" else
   drop z" FLIP HORIZONTAL"
   then then then then then then then then ;

: apply-process ( -- )
   currentProcess @
   dup 1 = if drop imCopy ImageColorGrayscale else
   dup 2 = if drop imCopy GREEN ImageColorTint else
   dup 3 = if drop imCopy ImageColorInvert else
   dup 4 = if drop imCopy -40e ImageColorContrast else
   dup 5 = if drop imCopy -80 ImageColorBrightness else
   dup 6 = if drop imCopy 10 ImageBlurGaussian else
   dup 7 = if drop imCopy ImageFlipVertical else
   dup 8 = if drop imCopy ImageFlipHorizontal else
   drop
   then then then then then then then then ;

: example
   screenWidth screenHeight z" raylib [textures] example - image processing" InitWindow
   imOrigin z" /home/dave/Code/raylib/examples/textures/resources/parrots.png" LoadImage drop
   imOrigin PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 ImageFormat
   texture imOrigin LoadTextureFromImage drop
   imCopy imOrigin ImageCopy drop
   0 currentProcess !
   0 textureReload !
   -1 mouseHoverRec !
   NUM_PROCESSES 0 do
      40e 50 32 i * + s>f 150e 30e i rec[] Rec!
   loop
   60 SetTargetFPS
   begin
      NUM_PROCESSES 0 do
         mouse@ i rec[] CheckCollisionPointRec if
            i mouseHoverRec !
            MOUSE_BUTTON_LEFT IsMouseButtonReleased if
               i currentProcess !  1 textureReload !
            then
         else
            mouseHoverRec @ i = if -1 mouseHoverRec ! then
         then
      loop
      KEY_DOWN IsKeyPressed if
         currentProcess @ 1+ dup NUM_PROCESSES 1- > if drop 0 then currentProcess !
         1 textureReload !
      then
      KEY_UP IsKeyPressed if
         currentProcess @ 1- dup 0< if drop NUM_PROCESSES 1- then currentProcess !
         1 textureReload !
      then
      textureReload @ if
         imCopy UnloadImage
         imCopy imOrigin ImageCopy drop
         apply-process
         imCopy LoadImageColors  ( pixels )
         texture over UpdateTexture
         UnloadImageColors
         0 textureReload !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" IMAGE PROCESSING:" 40 30 10 DARKGRAY DrawText
         NUM_PROCESSES 0 do
            i currentProcess @ = i mouseHoverRec @ = or if SKYBLUE else LIGHTGRAY then
            i rec[] swap DrawRectangleRec
            i rec[] sf@ f>s  i rec[] 4 + sf@ f>s
            i rec[] 8 + sf@ f>s  i rec[] 12 + sf@ f>s
            i currentProcess @ = i mouseHoverRec @ = or if BLUE else GRAY then
            DrawRectangleLines
            i process-name
            i rec[] sf@ f>s i rec[] 8 + sf@ f>s 2/ +  over 10 MeasureText 2/ -
            i rec[] 4 + sf@ f>s 11 +
            10
            i currentProcess @ = i mouseHoverRec @ = or if DARKBLUE else DARKGRAY then
            DrawText
         loop
         screenWidth texture texture_width l@ - 60 -
         screenHeight 2/ texture texture_height l@ 2/ -
         2dup texture -rot WHITE DrawTexture
         texture texture_width l@ texture texture_height l@ BLACK DrawRectangleLines
      EndDrawing
   WindowShouldClose until
   texture UnloadTexture
   imOrigin UnloadImage
   imCopy UnloadImage
   CloseWindow ;

example-end
