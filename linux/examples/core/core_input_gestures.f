\ Port of raylib examples/core/core_input_gestures.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
20 CONSTANT MAX_GESTURE_STRINGS

CREATE touchPosition 8 ALLOT
CREATE touchArea 16 ALLOT
VARIABLE gesturesCount
CREATE gestureStrings  MAX_GESTURE_STRINGS 32 * ALLOT
VARIABLE currentGesture
VARIABLE lastGesture

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: gstr ( i -- addr ) 32 * gestureStrings + ;

: store-gesture ( -- )
   currentGesture @ case
      GESTURE_TAP         of gesturesCount @ gstr z" GESTURE TAP"         TextCopy drop endof
      GESTURE_DOUBLETAP   of gesturesCount @ gstr z" GESTURE DOUBLETAP"   TextCopy drop endof
      GESTURE_HOLD        of gesturesCount @ gstr z" GESTURE HOLD"        TextCopy drop endof
      GESTURE_DRAG        of gesturesCount @ gstr z" GESTURE DRAG"        TextCopy drop endof
      GESTURE_SWIPE_RIGHT of gesturesCount @ gstr z" GESTURE SWIPE RIGHT" TextCopy drop endof
      GESTURE_SWIPE_LEFT  of gesturesCount @ gstr z" GESTURE SWIPE LEFT"  TextCopy drop endof
      GESTURE_SWIPE_UP    of gesturesCount @ gstr z" GESTURE SWIPE UP"    TextCopy drop endof
      GESTURE_SWIPE_DOWN  of gesturesCount @ gstr z" GESTURE SWIPE DOWN"  TextCopy drop endof
      GESTURE_PINCH_IN    of gesturesCount @ gstr z" GESTURE PINCH IN"    TextCopy drop endof
      GESTURE_PINCH_OUT   of gesturesCount @ gstr z" GESTURE PINCH OUT"   TextCopy drop endof
   endcase ;

: example
   0e 0e touchPosition Vector2!
   220e 10e  screenWidth 230 - s>f  screenHeight 20 - s>f  touchArea Rectangle!
   0 gesturesCount !
   GESTURE_NONE currentGesture !
   GESTURE_NONE lastGesture !
   screenWidth screenHeight z" raylib [core] example - input gestures" InitWindow
   60 SetTargetFPS
   begin
      currentGesture @ lastGesture !
      GetGestureDetected currentGesture !
      touchPosition 0 GetTouchPosition drop
      touchPosition touchArea CheckCollisionPointRec 1 and
      currentGesture @ GESTURE_NONE <> and if
         currentGesture @ lastGesture @ <> if
            store-gesture
            1 gesturesCount +!
            gesturesCount @ MAX_GESTURE_STRINGS >= if
               MAX_GESTURE_STRINGS 0 ?do  i gstr 0 swap c!  loop
               0 gesturesCount !
            then
         then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         touchArea GRAY DrawRectangleRec
         225 15 screenWidth 240 - screenHeight 30 - RAYWHITE DrawRectangle
         z" GESTURES TEST AREA" screenWidth 270 - screenHeight 40 - 20 GRAY 0.5e Fade DrawText
         gesturesCount @ 0 ?do
            i 2 mod 0= if
               10  30 i 20 * +  200 20  LIGHTGRAY 0.5e Fade DrawRectangle
            else
               10  30 i 20 * +  200 20  LIGHTGRAY 0.3e Fade DrawRectangle
            then
            i gstr 35  36 i 20 * +  10
            i gesturesCount @ 1- < if DARKGRAY else MAROON then
            DrawText
         loop
         10 29 200 screenHeight 50 - GRAY DrawRectangleLines
         z" DETECTED GESTURES" 50 15 10 GRAY DrawText
         currentGesture @ GESTURE_NONE <> if
            touchPosition 30e MAROON DrawCircleV
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
