\ Port of raylib examples/textures/textures_image_rotate.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
3 CONSTANT NUM_TEXTURES

CREATE img 32 ALLOT
CREATE textures 3 32 * ALLOT
VARIABLE currentTexture

: tex[] ( i -- a ) 32 * textures + ;

: example
   screenWidth screenHeight z" raylib [textures] example - image rotate" InitWindow
   img z" /home/dave/Code/raylib/examples/textures/resources/raylib_logo.png" LoadImage drop
   img 45 ImageRotate
   0 tex[] img LoadTextureFromImage drop  img UnloadImage
   img z" /home/dave/Code/raylib/examples/textures/resources/raylib_logo.png" LoadImage drop
   img 90 ImageRotate
   1 tex[] img LoadTextureFromImage drop  img UnloadImage
   img z" /home/dave/Code/raylib/examples/textures/resources/raylib_logo.png" LoadImage drop
   img -90 ImageRotate
   2 tex[] img LoadTextureFromImage drop  img UnloadImage
   0 currentTexture !
   60 SetTargetFPS
   begin
      MOUSE_BUTTON_LEFT IsMouseButtonPressed KEY_RIGHT IsKeyPressed or if
         currentTexture @ 1+ NUM_TEXTURES mod currentTexture !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         currentTexture @ tex[]
         dup texture_width l@  screenWidth 2/ swap 2/ -
         swap texture_height l@ screenHeight 2/ swap 2/ -
         currentTexture @ tex[] -rot WHITE DrawTexture
         z" Press LEFT MOUSE BUTTON to rotate the image clockwise" 250 420 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   NUM_TEXTURES 0 do i tex[] UnloadTexture loop
   CloseWindow ;

example-end
