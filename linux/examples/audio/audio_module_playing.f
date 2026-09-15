\ Port of raylib examples/audio/audio_module_playing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
64 CONSTANT MAX_CIRCLES

CREATE music 64 ALLOT
CREATE pitch 4 ALLOT
VARIABLE pause
CREATE timePlayed 4 ALLOT

\ circle: Vector2 pos + radius + alpha + speed + Color + pad
32 CONSTANT /CIRC
CREATE circles MAX_CIRCLES /CIRC * ALLOT
CREATE colors 14 cells ALLOT

: circ[] ( i -- a ) /CIRC * circles + ;
: C.pos ( a -- a ) ;
: C.radius ( a -- a ) 8 + ;
: C.alpha ( a -- a ) 12 + ;
: C.speed ( a -- a ) 16 + ;
: C.color ( a -- a ) 20 + ;

: rand-circle ( a -- )
   locals| c |
   0e c C.alpha sf!
   10 40 GetRandomValue s>f c C.radius sf!
   c C.radius sf@ f>s dup screenWidth swap - GetRandomValue s>f
   c C.radius sf@ f>s dup screenHeight swap - GetRandomValue s>f
   c C.pos Vector2!
   1 100 GetRandomValue s>f 2000e f/ c C.speed sf!
   0 13 GetRandomValue 0 max 13 min cells colors + @ c C.color l! ;

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [audio] example - module playing" InitWindow
   InitAudioDevice
   ORANGE  colors 0 cells + !
   RED     colors 1 cells + !
   GOLD    colors 2 cells + !
   LIME    colors 3 cells + !
   BLUE    colors 4 cells + !
   VIOLET  colors 5 cells + !
   BROWN   colors 6 cells + !
   LIGHTGRAY colors 7 cells + !
   PINK    colors 8 cells + !
   YELLOW  colors 9 cells + !
   GREEN   colors 10 cells + !
   SKYBLUE colors 11 cells + !
   PURPLE  colors 12 cells + !
   BEIGE   colors 13 cells + !
   MAX_CIRCLES 0 do i circ[] rand-circle loop
   music z" /home/dave/Code/raylib/examples/audio/resources/mini1111.xm" LoadMusicStream drop
   0 music 36 + l!
   1e pitch sf!
   music PlayMusicStream
   0 pause !
   60 SetTargetFPS
   begin
      music UpdateMusicStream
      KEY_SPACE IsKeyPressed if music StopMusicStream music PlayMusicStream  0 pause ! then
      KEY_P IsKeyPressed if
         pause @ 0= dup pause !
         if music PauseMusicStream else music ResumeMusicStream then
      then
      KEY_DOWN down if pitch sf@ 0.01e f- pitch sf! then
      KEY_UP down if pitch sf@ 0.01e f+ pitch sf! then
      music pitch sf@ SetMusicPitch
      music GetMusicTimePlayed music GetMusicTimeLength f/ screenWidth 40 - s>f f* timePlayed sf!
      pause @ 0= if
         MAX_CIRCLES 0 do
            i circ[]
            dup C.alpha sf@  dup C.speed sf@ f+  dup C.alpha sf!
            dup C.radius sf@ dup C.speed sf@ 10e f* f+  dup C.radius sf!
            dup C.alpha sf@ 1e f> if dup C.speed sf@ fnegate dup C.speed sf! then
            dup C.alpha sf@ f0<= if rand-circle else drop then
         loop
      then
      BeginDrawing
         RAYWHITE ClearBackground
         MAX_CIRCLES 0 do
            i circ[]
            dup C.pos  over C.radius sf@  over C.color l@  2 pick C.alpha sf@ Fade DrawCircleV
            drop
         loop
         20 screenHeight 32 -  screenWidth 40 - 12 LIGHTGRAY DrawRectangle
         20 screenHeight 32 -  timePlayed sf@ f>s 12 MAROON DrawRectangle
         20 screenHeight 32 -  screenWidth 40 - 12 GRAY DrawRectangleLines
         20 20 425 145 WHITE DrawRectangle
         20 20 425 145 GRAY DrawRectangleLines
         z" PRESS SPACE TO RESTART MUSIC" 40 40 20 BLACK DrawText
         z" PRESS P TO PAUSE/RESUME" 40 70 20 BLACK DrawText
         z" PRESS UP/DOWN TO CHANGE SPEED" 40 100 20 BLACK DrawText
         z" SPEED: (see pitch)" 40 130 20 MAROON DrawText
      EndDrawing
   WindowShouldClose until
   music UnloadMusicStream
   CloseAudioDevice
   CloseWindow ;

example-end
