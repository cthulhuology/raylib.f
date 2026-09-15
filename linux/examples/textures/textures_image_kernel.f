\ Port of raylib examples/textures/textures_image_kernel.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE image 32 ALLOT
CREATE catSharpend 32 ALLOT
CREATE catSobel 32 ALLOT
CREATE catGaussian 32 ALLOT
CREATE tex 32 ALLOT
CREATE texSharp 32 ALLOT
CREATE texSobel 32 ALLOT
CREATE texGauss 32 ALLOT
CREATE crop 16 ALLOT

CREATE gaussiankernel  9 4 * ALLOT
CREATE sobelkernel     9 4 * ALLOT
CREATE sharpenkernel   9 4 * ALLOT

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: kf! ( addr i F: v -- ) 4 * + sf! ;
: kf@ ( addr i -- ) ( F: -- v ) 4 * + sf@ ;

: NormalizeKernel ( k size -- )
   0e  over 0 ?do  over i kf@ f+  loop   ( k size F: sum )
   fdup f0= if fdrop 2drop exit then
   0 ?do  dup i kf@ fover f/  over i kf!  loop  fdrop drop ;

: example
   screenWidth screenHeight z" raylib [textures] example - image kernel" InitWindow
   image z" /home/dave/Code/raylib/examples/textures/resources/cat.png" LoadImage drop
   1e 2e 1e  2e 4e 2e  1e 2e 1e
   8 0 do gaussiankernel 8 i - kf! loop  gaussiankernel 0 kf!
   1e 0e -1e  2e 0e -2e  1e 0e -1e
   8 0 do sobelkernel 8 i - kf! loop  sobelkernel 0 kf!
   0e -1e 0e  -1e 5e -1e  0e -1e 0e
   8 0 do sharpenkernel 8 i - kf! loop  sharpenkernel 0 kf!
   gaussiankernel 9 NormalizeKernel
   sharpenkernel 9 NormalizeKernel
   sobelkernel 9 NormalizeKernel
   catSharpend image ImageCopy drop
   catSharpend sharpenkernel 9 ImageKernelConvolution
   catSobel image ImageCopy drop
   catSobel sobelkernel 9 ImageKernelConvolution
   catGaussian image ImageCopy drop
   6 0 do catGaussian gaussiankernel 9 ImageKernelConvolution loop
   0e 0e 200e 450e crop Rec!
   image crop ImageCrop
   catGaussian crop ImageCrop
   catSobel crop ImageCrop
   catSharpend crop ImageCrop
   tex image LoadTextureFromImage drop
   texSharp catSharpend LoadTextureFromImage drop
   texSobel catSobel LoadTextureFromImage drop
   texGauss catGaussian LoadTextureFromImage drop
   image UnloadImage
   catGaussian UnloadImage
   catSobel UnloadImage
   catSharpend UnloadImage
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         texSharp 0 0 WHITE DrawTexture
         texSobel 200 0 WHITE DrawTexture
         texGauss 400 0 WHITE DrawTexture
         tex 600 0 WHITE DrawTexture
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   texGauss UnloadTexture
   texSobel UnloadTexture
   texSharp UnloadTexture
   CloseWindow ;

example-end
