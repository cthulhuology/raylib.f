\ Port of raylib examples/core/core_basic_screen_manager.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

0 CONSTANT LOGO
1 CONSTANT TITLE
2 CONSTANT GAMEPLAY
3 CONSTANT ENDING

VARIABLE currentScreen
VARIABLE framesCounter

: example
   screenWidth screenHeight z" raylib [core] example - basic screen manager" InitWindow
   LOGO currentScreen !
   0 framesCounter !
   60 SetTargetFPS
   begin
      currentScreen @ case
         LOGO of
            1 framesCounter +!
            framesCounter @ 120 > if TITLE currentScreen ! then
         endof
         TITLE of
            KEY_ENTER IsKeyPressed 1 and  GESTURE_TAP IsGestureDetected 1 and or if
               GAMEPLAY currentScreen !
            then
         endof
         GAMEPLAY of
            KEY_ENTER IsKeyPressed 1 and  GESTURE_TAP IsGestureDetected 1 and or if
               ENDING currentScreen !
            then
         endof
         ENDING of
            KEY_ENTER IsKeyPressed 1 and  GESTURE_TAP IsGestureDetected 1 and or if
               TITLE currentScreen !
            then
         endof
      endcase
      BeginDrawing
         RAYWHITE ClearBackground
         currentScreen @ case
            LOGO of
               z" LOGO SCREEN" 20 20 40 LIGHTGRAY DrawText
               z" WAIT for 2 SECONDS..." 290 220 20 GRAY DrawText
            endof
            TITLE of
               0 0 screenWidth screenHeight GREEN DrawRectangle
               z" TITLE SCREEN" 20 20 40 DARKGREEN DrawText
               z" PRESS ENTER or TAP to JUMP to GAMEPLAY SCREEN" 120 220 20 DARKGREEN DrawText
            endof
            GAMEPLAY of
               0 0 screenWidth screenHeight PURPLE DrawRectangle
               z" GAMEPLAY SCREEN" 20 20 40 MAROON DrawText
               z" PRESS ENTER or TAP to JUMP to ENDING SCREEN" 130 220 20 MAROON DrawText
            endof
            ENDING of
               0 0 screenWidth screenHeight BLUE DrawRectangle
               z" ENDING SCREEN" 20 20 40 DARKBLUE DrawText
               z" PRESS ENTER or TAP to RETURN to TITLE SCREEN" 120 220 20 DARKBLUE DrawText
            endof
         endcase
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
