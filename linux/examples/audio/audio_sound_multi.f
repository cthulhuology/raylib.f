\ Port of raylib examples/audio/audio_sound_multi.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
10 CONSTANT MAX_SOUNDS

CREATE sounds 10 48 * ALLOT
VARIABLE currentSound

: snd-i ( i -- a ) 48 * sounds + ;

: example
   0 currentSound !
   screenWidth screenHeight z" raylib [audio] example - sound multi" InitWindow
   InitAudioDevice
   0 snd-i z" /home/dave/Code/raylib/examples/audio/resources/sound.wav" LoadSound drop
   MAX_SOUNDS 1 do
      i snd-i  0 snd-i LoadSoundAlias drop
   loop
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if
         currentSound @ snd-i PlaySound
         currentSound @ 1+ MAX_SOUNDS mod currentSound !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" Press SPACE to PLAY a WAV sound!" 200 180 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   MAX_SOUNDS 1 do i snd-i UnloadSoundAlias loop
   0 snd-i UnloadSound
   CloseAudioDevice
   CloseWindow ;

example-end
