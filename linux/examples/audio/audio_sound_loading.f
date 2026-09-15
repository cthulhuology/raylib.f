\ Port of raylib examples/audio/audio_sound_loading.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE fxWav 48 ALLOT
CREATE fxOgg 48 ALLOT

: example
   screenWidth screenHeight z" raylib [audio] example - sound loading" InitWindow
   InitAudioDevice
   fxWav z" /home/dave/Code/raylib/examples/audio/resources/sound.wav" LoadSound drop
   fxOgg z" /home/dave/Code/raylib/examples/audio/resources/target.ogg" LoadSound drop
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if fxWav PlaySound then
      KEY_ENTER IsKeyPressed if fxOgg PlaySound then
      BeginDrawing
         RAYWHITE ClearBackground
         z" Press SPACE to PLAY the WAV sound!" 200 180 20 LIGHTGRAY DrawText
         z" Press ENTER to PLAY the OGG sound!" 200 220 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   fxWav UnloadSound
   fxOgg UnloadSound
   CloseAudioDevice
   CloseWindow ;

example-end
