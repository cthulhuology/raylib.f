\ Port of raylib examples/core/core_automation_events.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
400e fconstant GRAVITY
350e fconstant PLAYER_JUMP_SPD
200e fconstant PLAYER_HOR_SPD
5 CONSTANT MAX_ENVIRONMENT_ELEMENTS
32 CONSTANT /env

CREATE player 16 ALLOT
CREATE envElements  MAX_ENVIRONMENT_ELEMENTS /env * ALLOT
CREATE camera 24 ALLOT
CREATE aelist 16 ALLOT
CREATE dropped 16 ALLOT
CREATE playerRect 16 ALLOT
CREATE v-max 8 ALLOT
CREATE v-min 8 ALLOT
VARIABLE eventRecording
VARIABLE eventPlaying
VARIABLE frameCounter
VARIABLE playFrameCounter
VARIABLE currentPlayFrame

0e fvalue minX
0e fvalue minY
0e fvalue maxX
0e fvalue maxY

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: ply-pos player ;
: ply-spd player 8 + ;
: ply-jump player 12 + ;
: env ( i -- addr ) /env * envElements + ;
: env-rec ( i -- addr ) env ;
: env-block ( i -- addr ) env 16 + ;
: env-col ( i -- n ) env 24 + @ ;
: cam-off camera ;
: cam-tgt camera 8 + ;
: cam-rot camera 16 + ;
: cam-zoom camera 20 + ;

: init-env
   0e 0e 1000e 400e 0 env-rec Rectangle!  0 0 env-block l! LIGHTGRAY 0 env 24 + !
   0e 400e 1000e 200e 1 env-rec Rectangle! 1 1 env-block l! GRAY 1 env 24 + !
   300e 200e 400e 10e 2 env-rec Rectangle! 1 2 env-block l! GRAY 2 env 24 + !
   250e 300e 100e 10e 3 env-rec Rectangle! 1 3 env-block l! GRAY 3 env 24 + !
   650e 300e 100e 10e 4 env-rec Rectangle! 1 4 env-block l! GRAY 4 env 24 + ! ;

: reset-scene
   400e 280e player Vector2!
   0e ply-spd sf!  0 ply-jump l!
   ply-pos cam-tgt 8 move
   screenWidth 2/ s>f screenHeight 2/ s>f cam-off Vector2!
   0e cam-rot sf!  1e cam-zoom sf! ;

: example
   reset-scene
   init-env
   0 eventRecording !  0 eventPlaying !
   0 frameCounter !  0 playFrameCounter !  0 currentPlayFrame !
   screenWidth screenHeight z" raylib [core] example - automation events" InitWindow
   aelist 0 LoadAutomationEventList drop
   aelist SetAutomationEventList
   60 SetTargetFPS
   begin
      0.015e  \ deltaTime
      IsFileDropped 1 and if
         dropped LoadDroppedFiles drop
         dropped filePathList_count l@ 0 > if
            dropped filePathList_paths @ @  z" .txt;.rae" IsFileExtension 1 and if
               aelist UnloadAutomationEventList
               aelist dropped filePathList_paths @ @ LoadAutomationEventList drop
               0 eventRecording !
               1 eventPlaying !
               0 playFrameCounter !  0 currentPlayFrame !
               reset-scene
            then
         then
         dropped UnloadDroppedFiles
      then
      KEY_LEFT down if ply-pos sf@ PLAYER_HOR_SPD fover f* f- ply-pos sf! then
      KEY_RIGHT down if ply-pos sf@ PLAYER_HOR_SPD fover f* f+ ply-pos sf! then
      KEY_SPACE down ply-jump l@ and if PLAYER_JUMP_SPD fnegate ply-spd sf!  0 ply-jump l! then
      0
      MAX_ENVIRONMENT_ELEMENTS 0 ?do
         i env-block l@ if
            i env-rec sf@ ply-pos sf@ f<=
            i env-rec sf@ i env-rec 8 + sf@ f+ ply-pos sf@ f>= and
            i env-rec 4 + sf@ ply-pos 4 + sf@ f>= and
            i env-rec 4 + sf@ ply-pos 4 + sf@ ply-spd sf@ fover f* f+ f<= and if
               drop 1
               0e ply-spd sf!
               i env-rec 4 + sf@ ply-pos 4 + sf!
            then
         then
      loop
      0= if
         ply-pos 4 + sf@ ply-spd sf@ fover f* f+ ply-pos 4 + sf!
         ply-spd sf@ GRAVITY fover f* f+ ply-spd sf!
         0 ply-jump l!
      else 1 ply-jump l! then
      KEY_R IsKeyPressed 1 and if reset-scene then
      eventPlaying @ if
         begin
            eventPlaying @
            playFrameCounter @
            aelist automationEventList_events @ currentPlayFrame @ 24 * + automationEvent_frame l@
            = and
         while
            aelist automationEventList_events @ currentPlayFrame @ 24 * + PlayAutomationEvent
            1 currentPlayFrame +!
            currentPlayFrame @ aelist automationEventList_count l@ = if
               0 eventPlaying !  0 currentPlayFrame !  0 playFrameCounter !
            then
         repeat
         eventPlaying @ if 1 playFrameCounter +! then
      then
      ply-pos cam-tgt 8 move
      screenWidth 2/ s>f screenHeight 2/ s>f cam-off Vector2!
      cam-zoom sf@ GetMouseWheelMove 0.05e f* f+ cam-zoom sf!
      cam-zoom sf@ 3e f> if 3e cam-zoom sf! then
      cam-zoom sf@ 0.25e f< if 0.25e cam-zoom sf! then
      1000e to minX 1000e to minY -1000e to maxX -1000e to maxY
      MAX_ENVIRONMENT_ELEMENTS 0 ?do
         i env-rec sf@ minX fmin to minX
         i env-rec sf@ i env-rec 8 + sf@ f+ maxX fmax to maxX
         i env-rec 4 + sf@ minY fmin to minY
         i env-rec 4 + sf@ i env-rec 12 + sf@ f+ maxY fmax to maxY
      loop
      maxX maxY v-max Vector2!
      minX minY v-min Vector2!
      v-max dup camera GetWorldToScreen2D drop
      v-min dup camera GetWorldToScreen2D drop
      v-max v2x screenWidth s>f f< if screenWidth s>f v-max v2x screenWidth 2/ s>f f- f- cam-off sf! then
      v-max v2y screenHeight s>f f< if screenHeight s>f v-max v2y screenHeight 2/ s>f f- f- cam-off 4 + sf! then
      v-min v2x 0e f> if screenWidth 2/ s>f v-min v2x f- cam-off sf! then
      v-min v2y 0e f> if screenHeight 2/ s>f v-min v2y f- cam-off 4 + sf! then
      KEY_S IsKeyPressed 1 and if
         eventPlaying @ 0= if
            eventRecording @ if
               StopAutomationEventRecording
               0 eventRecording !
               aelist z" automation.rae" ExportAutomationEventList drop
            else
               180 SetAutomationEventBaseFrame
               StartAutomationEventRecording
               1 eventRecording !
            then
         then
      else KEY_A IsKeyPressed 1 and if
         eventRecording @ 0= aelist automationEventList_count l@ 0 > and if
            1 eventPlaying !  0 playFrameCounter !  0 currentPlayFrame !
            reset-scene
         then
      then then
      eventRecording @ eventPlaying @ or if 1 frameCounter +! else 0 frameCounter ! then
      fdrop
      BeginDrawing
         LIGHTGRAY ClearBackground
         camera BeginMode2D
            MAX_ENVIRONMENT_ELEMENTS 0 ?do
               i env-rec i env-col DrawRectangleRec
            loop
            ply-pos sf@ 20e f- ply-pos 4 + sf@ 40e f- 40e 40e playerRect Rectangle!
            playerRect RED DrawRectangleRec
         EndMode2D
         10 10 290 145 SKYBLUE 0.5e Fade DrawRectangle
         10 10 290 145 BLUE 0.8e Fade DrawRectangleLines
         z" Controls:" 20 20 10 BLACK DrawText
         z" - RIGHT | LEFT: Player movement" 30 40 10 DARKGRAY DrawText
         z" - SPACE: Player jump" 30 60 10 DARKGRAY DrawText
         z" - R: Reset game state" 30 80 10 DARKGRAY DrawText
         z" - S: START/STOP RECORDING INPUT EVENTS" 30 110 10 BLACK DrawText
         z" - A: REPLAY LAST RECORDED INPUT EVENTS" 30 130 10 BLACK DrawText
         eventRecording @ if
            10 160 290 30 RED 0.3e Fade DrawRectangle
            10 160 290 30 MAROON 0.8e Fade DrawRectangleLines
            30 175 10e MAROON DrawCircle
            frameCounter @ 15 / 2 mod 1 = if
               z" RECORDING EVENTS..." 50 170 10 MAROON DrawText
            then
         else eventPlaying @ if
            10 160 290 30 LIME 0.3e Fade DrawRectangle
            10 160 290 30 DARKGREEN 0.8e Fade DrawRectangleLines
            20e 165e v2a Vector2!  20e 185e v2b Vector2!  40e 175e v2c Vector2!
            v2a v2b v2c DARKGREEN DrawTriangle
            frameCounter @ 15 / 2 mod 1 = if
               z" PLAYING RECORDED EVENTS..." 50 170 10 DARKGREEN DrawText
            then
         then then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
