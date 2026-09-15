\ Port of raylib examples/audio/audio_mixed_processor.c
\ Mixed-processor callback not bound; plays music + sound.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE music 64 ALLOT
CREATE sound 48 ALLOT

: example
   screenWidth screenHeight z" raylib [audio] example - mixed processor" InitWindow
   InitAudioDevice
   music z" /home/dave/Code/raylib/examples/audio/resources/country.mp3" LoadMusicStream drop
   sound z" /home/dave/Code/raylib/examples/audio/resources/coin.wav" LoadSound drop
   music PlayMusicStream
   60 SetTargetFPS
   begin
      music UpdateMusicStream
      KEY_SPACE IsKeyPressed if sound PlaySound then
      BeginDrawing
         RAYWHITE ClearBackground
         z" MUSIC PLAYING" 255 150 20 LIGHTGRAY DrawText
         z" Press SPACE to play a sound" 200 200 20 LIGHTGRAY DrawText
         z" Audio mixed processor callback not ported" 140 250 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   music UnloadMusicStream
   sound UnloadSound
   CloseAudioDevice
   CloseWindow ;

example-end
