\ Port of raylib examples/textures/textures_image_generation.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
9 CONSTANT NUM_TEXTURES

CREATE img 32 ALLOT
CREATE textures 9 32 * ALLOT
VARIABLE currentTexture

: tex[] ( i -- a ) 32 * textures + ;

: gen-tex ( i -- )  \ load texture i from img, then unload img
   tex[] img LoadTextureFromImage drop  img UnloadImage ;

: example
   screenWidth screenHeight z" raylib [textures] example - image generation" InitWindow
   img screenWidth screenHeight 0 RED BLUE GenImageGradientLinear drop  0 gen-tex
   img screenWidth screenHeight 90 RED BLUE GenImageGradientLinear drop  1 gen-tex
   img screenWidth screenHeight 45 RED BLUE GenImageGradientLinear drop  2 gen-tex
   img screenWidth screenHeight 0e WHITE BLACK GenImageGradientRadial drop  3 gen-tex
   img screenWidth screenHeight 0e WHITE BLACK GenImageGradientSquare drop  4 gen-tex
   img screenWidth screenHeight 32 32 RED BLUE GenImageChecked drop  5 gen-tex
   img screenWidth screenHeight 0.5e GenImageWhiteNoise drop  6 gen-tex
   img screenWidth screenHeight 50 50 4e GenImagePerlinNoise drop  7 gen-tex
   img screenWidth screenHeight 32 GenImageCellular drop  8 gen-tex
   0 currentTexture !
   60 SetTargetFPS
   begin
      MOUSE_BUTTON_LEFT IsMouseButtonPressed KEY_RIGHT IsKeyPressed or if
         currentTexture @ 1+ NUM_TEXTURES mod currentTexture !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         currentTexture @ tex[] 0 0 WHITE DrawTexture
         30 400 325 30 SKYBLUE 0.5e Fade DrawRectangle
         30 400 325 30 WHITE 0.5e Fade DrawRectangleLines
         z" MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES" 40 410 10 WHITE DrawText
         currentTexture @
         dup 0 = if drop z" VERTICAL GRADIENT" 560 10 20 RAYWHITE DrawText else
         dup 1 = if drop z" HORIZONTAL GRADIENT" 540 10 20 RAYWHITE DrawText else
         dup 2 = if drop z" DIAGONAL GRADIENT" 540 10 20 RAYWHITE DrawText else
         dup 3 = if drop z" RADIAL GRADIENT" 580 10 20 LIGHTGRAY DrawText else
         dup 4 = if drop z" SQUARE GRADIENT" 580 10 20 LIGHTGRAY DrawText else
         dup 5 = if drop z" CHECKED" 680 10 20 RAYWHITE DrawText else
         dup 6 = if drop z" WHITE NOISE" 640 10 20 RED DrawText else
         dup 7 = if drop z" PERLIN NOISE" 640 10 20 RED DrawText else
         drop z" CELLULAR" 670 10 20 RAYWHITE DrawText
         then then then then then then then then
      EndDrawing
   WindowShouldClose until
   NUM_TEXTURES 0 do i tex[] UnloadTexture loop
   CloseWindow ;

example-end
