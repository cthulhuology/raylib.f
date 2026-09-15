\ Port of raylib examples/audio/audio_music_stream.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE music 64 ALLOT
VARIABLE pause
CREATE timePlayed 4 ALLOT

: example
   0 pause !
   screenWidth screenHeight z" raylib [audio] example - music stream" InitWindow
   InitAudioDevice
   music z" /home/dave/Code/raylib/examples/audio/resources/country.mp3" LoadMusicStream drop
   music PlayMusicStream
   30 SetTargetFPS
   begin
      music UpdateMusicStream
      KEY_SPACE IsKeyPressed if music StopMusicStream  music PlayMusicStream then
      KEY_P IsKeyPressed if
         pause @ 0= dup pause !
         if music PauseMusicStream else music ResumeMusicStream then
      then
      music GetMusicTimePlayed music GetMusicTimeLength f/ 
      1e fmin timePlayed sf!
      BeginDrawing
         RAYWHITE ClearBackground
         z" MUSIC SHOULD BE PLAYING!" 255 150 20 LIGHTGRAY DrawText
         200 200 400 12 LIGHTGRAY DrawRectangle
         200 200  timePlayed sf@ 400e f* f>s  12 MAROON DrawRectangle
         200 200 400 12 GRAY DrawRectangleLines
         z" PRESS SPACE TO RESTART MUSIC" 215 250 20 LIGHTGRAY DrawText
         z" PRESS P TO PAUSE/RESUME MUSIC" 208 280 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   music UnloadMusicStream
   CloseAudioDevice
   CloseWindow ;

example-end
