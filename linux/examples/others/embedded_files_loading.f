\ Port of raylib examples/others/embedded_files_loading.c
\ Header-embedded blobs replaced by loading the original resource files.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE wave 32 ALLOT
CREATE sound 48 ALLOT
CREATE img 32 ALLOT
CREATE tex 32 ALLOT

: example
   screenWidth screenHeight z" raylib [others] example - embedded files loading" InitWindow
   InitAudioDevice
   wave z" /home/dave/Code/raylib/examples/audio/resources/sound.wav" LoadWave drop
   sound wave LoadSoundFromWave drop
   wave UnloadWave
   img z" /home/dave/Code/raylib/examples/models/resources/raylib_logo.png" LoadImage drop
   tex img LoadTextureFromImage drop
   img UnloadImage
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if sound PlaySound then
      BeginDrawing
         RAYWHITE ClearBackground
         tex screenWidth 2/ tex tex.w 2/ -  screenHeight 2/ tex tex.h 2/ - WHITE DrawTexture
         z" Press SPACE to PLAY the embedded sound" 150 220 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   sound UnloadSound
   tex UnloadTexture
   CloseAudioDevice
   CloseWindow ;

example-end
