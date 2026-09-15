\ Port of raylib examples/core/core_monitor_detector.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
10 CONSTANT MAX_MONITORS

\ MonitorInfo: pos(8) name(8) w h physW physH refresh  = 8+8+5*4 aligned ~ 40
40 CONSTANT /mon
CREATE monitors  MAX_MONITORS /mon * ALLOT
VARIABLE currentMonitorIndex
VARIABLE monitorCount
CREATE rec 16 ALLOT
CREATE winpos 8 ALLOT
CREATE winsz 8 ALLOT
CREATE nbuf 64 ALLOT

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: mon ( i -- addr ) /mon * monitors + ;
: mon-pos ( i -- addr ) mon ;
: mon-name ( i -- addr ) mon 8 + ;
: mon-w ( i -- addr ) mon 16 + ;
: mon-h ( i -- addr ) mon 20 + ;
: mon-pw ( i -- addr ) mon 24 + ;
: mon-ph ( i -- addr ) mon 28 + ;
: mon-rr ( i -- addr ) mon 32 + ;

: example
   screenWidth screenHeight z" raylib [core] example - monitor detector" InitWindow
   GetCurrentMonitor currentMonitorIndex !
   0 monitorCount !
   60 SetTargetFPS
   begin
      1  \ maxWidth
      1  \ maxHeight
      0  \ monitorOffsetX
      GetMonitorCount monitorCount !
      monitorCount @ 0 ?do
         i mon-pos i GetMonitorPosition drop
         i GetMonitorName i mon-name !
         i GetMonitorWidth i mon-w l!
         i GetMonitorHeight i mon-h l!
         i GetMonitorPhysicalWidth i mon-pw l!
         i GetMonitorPhysicalHeight i mon-ph l!
         i GetMonitorRefreshRate i mon-rr l!
         i mon-pos v2x f>s 2 pick > if 2 pick drop i mon-pos v2x f>s negate >r rot r> swap then
         \ messy offset tracking - simplify:
      loop
      3drop
      0 1 1  \ offset maxW maxH rebuilt
      drop drop drop
      0 >r  1 >r  1 >r   \ r: offset maxW maxH?  let's use variables
      KEY_ENTER IsKeyPressed 1 and monitorCount @ 1 > and if
         1 currentMonitorIndex +!
         currentMonitorIndex @ monitorCount @ = if 0 currentMonitorIndex ! then
         currentMonitorIndex @ SetWindowMonitor
      else
         GetCurrentMonitor currentMonitorIndex !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" Press [Enter] to move window to next monitor available" 20 20 20 DARKGRAY DrawText
         20 60 screenWidth 40 - screenHeight 100 - DARKGRAY DrawRectangleLines
         0.6e  \ monitorScale base
         monitorCount @ 0 ?do
            i mon-pos v2x 140e f+
            i mon-pos v2y 80e f+
            i mon-w l@ s>f 0.25e f*
            i mon-h l@ s>f 0.25e f*
            rec Rectangle!
            rec 5e  i currentMonitorIndex @ = if RED else GRAY then DrawRectangleLinesEx
            i n>z rec sf@ f>s 10 + rec 4 + sf@ f>s 10 + 12 BLUE DrawText
            i mon-name @ rec sf@ f>s 40 + rec 4 + sf@ f>s 10 + 12 BLUE DrawText
            i currentMonitorIndex @ = if
               winpos GetWindowPosition drop
               winpos v2x 140e f+ winpos v2y 80e f+ winpos Vector2!
               screenWidth s>f 0.25e f* screenHeight s>f 0.25e f* winsz Vector2!
               winpos winsz GREEN 0.5e Fade DrawRectangleV
            then
         loop
         fdrop
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
