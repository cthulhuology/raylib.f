\ Port of raylib examples/textures/textures_gif_player.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
20 CONSTANT MAX_FRAME_DELAY
1 CONSTANT MIN_FRAME_DELAY

CREATE animFrames 4 ALLOT
CREATE imScarfyAnim 32 ALLOT
CREATE texScarfyAnim 32 ALLOT
VARIABLE currentAnimFrame
VARIABLE frameDelay
VARIABLE frameCounter
VARIABLE nextFrameDataOffset

: n>z ( n -- z ) dup 0< if abs 1 else 0 then >r 0 <# #s r> if [char] - hold then #> zres ;
: n>z02 ( n -- z ) 0 <# # # #> zres ;

: example
   screenWidth screenHeight z" raylib [textures] example - gif player" InitWindow
   0 animFrames l!
   imScarfyAnim z" /home/dave/Code/raylib/examples/textures/resources/scarfy_run.gif" animFrames LoadImageAnim drop
   texScarfyAnim imScarfyAnim LoadTextureFromImage drop
   0 nextFrameDataOffset !
   0 currentAnimFrame !
   8 frameDelay !
   0 frameCounter !
   60 SetTargetFPS
   begin
      1 frameCounter +!
      frameCounter @ frameDelay @ >= if
         1 currentAnimFrame +!
         currentAnimFrame @ animFrames l@ >= if 0 currentAnimFrame ! then
         imScarfyAnim image_width l@ imScarfyAnim image_height l@ * 4 * currentAnimFrame @ * nextFrameDataOffset !
         texScarfyAnim  imScarfyAnim image_data @ nextFrameDataOffset @ +  UpdateTexture
         0 frameCounter !
      then
      KEY_RIGHT IsKeyPressed if 1 frameDelay +! then
      KEY_LEFT  IsKeyPressed if -1 frameDelay +! then
      frameDelay @ MAX_FRAME_DELAY > if MAX_FRAME_DELAY frameDelay ! then
      frameDelay @ MIN_FRAME_DELAY < if MIN_FRAME_DELAY frameDelay ! then
      BeginDrawing
         RAYWHITE ClearBackground
         z" TOTAL GIF FRAMES:  " 50 30 20 LIGHTGRAY DrawText
         animFrames l@ n>z02 280 30 20 LIGHTGRAY DrawText
         z" CURRENT FRAME: " 50 60 20 GRAY DrawText
         currentAnimFrame @ n>z02 230 60 20 GRAY DrawText
         z" CURRENT FRAME IMAGE.DATA OFFSET: " 50 90 20 GRAY DrawText
         nextFrameDataOffset @ n>z 430 90 20 GRAY DrawText
         z" FRAMES DELAY: " 100 305 10 DARKGRAY DrawText
         frameDelay @ n>z02 620 305 10 DARKGRAY DrawText
         z" PRESS RIGHT/LEFT KEYS to CHANGE SPEED!" 290 350 10 DARKGRAY DrawText
         MAX_FRAME_DELAY 0 do
            i frameDelay @ < if 190 21 i * + 300 20 20 RED DrawRectangle then
            190 21 i * + 300 20 20 MAROON DrawRectangleLines
         loop
         texScarfyAnim GetScreenWidth 2/ texScarfyAnim texture_width l@ 2/ - 140 WHITE DrawTexture
         z" (c) Scarfy sprite by Eiden Marsal" screenWidth 200 - screenHeight 20 - 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   texScarfyAnim UnloadTexture
   imScarfyAnim UnloadImage
   CloseWindow ;

example-end
