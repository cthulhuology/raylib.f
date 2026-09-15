\ Port of raylib examples/textures/textures_image_channel.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE fudesumiImage 32 ALLOT
CREATE imageAlpha 32 ALLOT
CREATE imageRed 32 ALLOT
CREATE imageGreen 32 ALLOT
CREATE imageBlue 32 ALLOT
CREATE backgroundImage 32 ALLOT
CREATE fudesumiTexture 32 ALLOT
CREATE textureAlpha 32 ALLOT
CREATE textureRed 32 ALLOT
CREATE textureGreen 32 ALLOT
CREATE textureBlue 32 ALLOT
CREATE backgroundTexture 32 ALLOT
CREATE fudesumiRec 16 ALLOT
CREATE fudesumiPos 16 ALLOT
CREATE redPos 16 ALLOT
CREATE greenPos 16 ALLOT
CREATE bluePos 16 ALLOT
CREATE alphaPos 16 ALLOT
CREATE origin 16 ALLOT

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   screenWidth screenHeight z" raylib [textures] example - image channel" InitWindow
   fudesumiImage z" /home/dave/Code/raylib/examples/textures/resources/fudesumi.png" LoadImage drop
   imageAlpha fudesumiImage 3 ImageFromChannel drop
   imageAlpha imageAlpha ImageAlphaMask
   imageRed fudesumiImage 0 ImageFromChannel drop
   imageRed imageAlpha ImageAlphaMask
   imageGreen fudesumiImage 1 ImageFromChannel drop
   imageGreen imageAlpha ImageAlphaMask
   imageBlue fudesumiImage 2 ImageFromChannel drop
   imageBlue imageAlpha ImageAlphaMask
   backgroundImage screenWidth screenHeight screenWidth 20 / screenHeight 20 / ORANGE YELLOW GenImageChecked drop
   fudesumiTexture fudesumiImage LoadTextureFromImage drop
   textureAlpha imageAlpha LoadTextureFromImage drop
   textureRed imageRed LoadTextureFromImage drop
   textureGreen imageGreen LoadTextureFromImage drop
   textureBlue imageBlue LoadTextureFromImage drop
   backgroundTexture backgroundImage LoadTextureFromImage drop
   fudesumiImage image_width l@ s>f  fudesumiImage image_height l@ s>f
   0e 0e 2swap fudesumiRec Rec!
   50e 10e fudesumiRec 8 + sf@ 0.8e f* fudesumiRec 12 + sf@ 0.8e f* fudesumiPos Rec!
   410e 10e fudesumiPos 8 + sf@ 2e f/ fudesumiPos 12 + sf@ 2e f/ redPos Rec!
   600e 10e fudesumiPos 8 + sf@ 2e f/ fudesumiPos 12 + sf@ 2e f/ greenPos Rec!
   410e 230e fudesumiPos 8 + sf@ 2e f/ fudesumiPos 12 + sf@ 2e f/ bluePos Rec!
   600e 230e fudesumiPos 8 + sf@ 2e f/ fudesumiPos 12 + sf@ 2e f/ alphaPos Rec!
   0e 0e origin Vector2!
   fudesumiImage UnloadImage
   imageAlpha UnloadImage
   imageRed UnloadImage
   imageGreen UnloadImage
   imageBlue UnloadImage
   backgroundImage UnloadImage
   60 SetTargetFPS
   begin
      BeginDrawing
         backgroundTexture 0 0 WHITE DrawTexture
         fudesumiTexture fudesumiRec fudesumiPos origin 0e WHITE DrawTexturePro
         textureRed fudesumiRec redPos origin 0e RED DrawTexturePro
         textureGreen fudesumiRec greenPos origin 0e GREEN DrawTexturePro
         textureBlue fudesumiRec bluePos origin 0e BLUE DrawTexturePro
         textureAlpha fudesumiRec alphaPos origin 0e WHITE DrawTexturePro
      EndDrawing
   WindowShouldClose until
   backgroundTexture UnloadTexture
   fudesumiTexture UnloadTexture
   textureRed UnloadTexture
   textureGreen UnloadTexture
   textureBlue UnloadTexture
   textureAlpha UnloadTexture
   CloseWindow ;

example-end
