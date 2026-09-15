\ Port of raylib examples/audio/audio_raw_stream.c
\ C audio callback replaced by Forth filling UpdateAudioStream.

800 CONSTANT screenWidth
450 CONSTANT screenHeight
4096 CONSTANT MAX_SAMPLES_PER_UPDATE

CREATE stream 48 ALLOT
CREATE freq 4 ALLOT
CREATE sineIdx 4 ALLOT
CREATE writeBuf MAX_SAMPLES_PER_UPDATE 2 * ALLOT
CREATE mouseY 4 ALLOT

: fill-buf ( -- )
   freq sf@ 44100e f/
   MAX_SAMPLES_PER_UPDATE 0 do
      sineIdx sf@ RPI f* 2e f* fsin 32000e f* f>s $ffff and
      writeBuf i 2 * + w!
      sineIdx sf@ fover f+ fdup 1e f> if 1e f- then sineIdx sf!
   loop
   fdrop ;

: example
   440e freq sf!  0e sineIdx sf!
   screenWidth screenHeight z" raylib [audio] example - raw stream" InitWindow
   InitAudioDevice
   MAX_SAMPLES_PER_UPDATE SetAudioStreamBufferSizeDefault
   stream 44100 16 1 LoadAudioStream drop
   stream PlayAudioStream
   30 SetTargetFPS
   begin
      GetMouseY s>f screenHeight s>f f/ 1960e f* 40e f+ freq sf!
      stream IsAudioStreamProcessed if
         fill-buf
         stream writeBuf MAX_SAMPLES_PER_UPDATE UpdateAudioStream
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" Move mouse up/down to change frequency" 140 180 20 GRAY DrawText
         z" Sine wave raw audio stream" 200 220 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   stream UnloadAudioStream
   CloseAudioDevice
   CloseWindow ;

example-end
