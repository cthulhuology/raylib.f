\ Port of raylib examples/core/core_input_gestures_testbed.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
20 CONSTANT GESTURE_LOG_SIZE
32 CONSTANT MAX_TOUCH_COUNT

CREATE messagePosition 8 ALLOT
CREATE lastGesturePosition 8 ALLOT
CREATE gestureLog  GESTURE_LOG_SIZE 12 * ALLOT
VARIABLE lastGesture
VARIABLE gestureLogIndex
VARIABLE previousGesture
VARIABLE logMode
VARIABLE gestureColor
CREATE logButton1 16 ALLOT
CREATE logButton2 16 ALLOT
CREATE gestureLogPosition 8 ALLOT
90e fconstant angleLength
0e fvalue currentAngleDegrees
CREATE finalVector 8 ALLOT
CREATE protractorPosition 8 ALLOT
CREATE touchPosition  MAX_TOUCH_COUNT 8 * ALLOT
CREATE mousePosition 8 ALLOT
CREATE nbuf 64 ALLOT

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: glog ( i -- addr ) 12 * gestureLog + ;

: GetGestureName ( g -- z )
   case
      0 of z" None" endof
      1 of z" Tap" endof
      2 of z" Double Tap" endof
      4 of z" Hold" endof
      8 of z" Drag" endof
      16 of z" Swipe Right" endof
      32 of z" Swipe Left" endof
      64 of z" Swipe Up" endof
      128 of z" Swipe Down" endof
      256 of z" Pinch In" endof
      512 of z" Pinch Out" endof
      dup of z" Unknown" endof
   endcase ;

: GetGestureColor ( g -- u )
   case
      0 of BLACK endof
      1 of BLUE endof
      2 of SKYBLUE endof
      4 of BLACK endof
      8 of LIME endof
      16 of RED endof
      32 of RED endof
      64 of RED endof
      128 of RED endof
      256 of VIOLET endof
      512 of ORANGE endof
      dup of BLACK endof
   endcase ;

: touch-at ( i -- addr ) 8 * touchPosition + ;

CREATE vA 8 ALLOT
CREATE vB 8 ALLOT
CREATE vC 8 ALLOT

: example
   160e 7e messagePosition Vector2!
   0 lastGesture !
   165e 130e lastGesturePosition Vector2!
   GESTURE_LOG_SIZE gestureLogIndex !
   0 previousGesture !
   1 logMode !
   BLACK gestureColor !
   53e 7e 48e 26e logButton1 Rectangle!
   108e 7e 36e 26e logButton2 Rectangle!
   10e 10e gestureLogPosition Vector2!
   0e to currentAngleDegrees
   0e 0e finalVector Vector2!
   266e 315e protractorPosition Vector2!
   screenWidth screenHeight z" raylib [core] example - input gestures testbed" InitWindow
   60 SetTargetFPS
   begin
      GetGestureDetected
      GetGestureDragAngle
      GetGesturePinchAngle
      GetTouchPointCount
      >r  \ touchCount
      \ F: currentPitch currentDrag  data: currentGesture  (actually GetGestureDragAngle is %f)
      \ stack after GetGestureDetected: g
      \ GetGestureDragAngle: g  F: drag
      \ GetGesturePinchAngle: g  F: drag pitch
      \ GetTouchPointCount: g touch  F: drag pitch
      \ I messed the order. redo below in locals.
      r> drop fdrop fdrop drop

      GetGestureDetected
      dup 0 <> over 4 <> and over previousGesture @ <> and if dup lastGesture ! then
      MOUSE_BUTTON_LEFT IsMouseButtonReleased 1 and if
         mouse@ logButton1 CheckCollisionPointRec 1 and if
            logMode @ case
               3 of 2 logMode ! endof
               2 of 3 logMode ! endof
               1 of 0 logMode ! endof
               dup of 1 logMode ! endof
            endcase
         else mouse@ logButton2 CheckCollisionPointRec 1 and if
            logMode @ case
               3 of 1 logMode ! endof
               2 of 0 logMode ! endof
               1 of 3 logMode ! endof
               dup of 2 logMode ! endof
            endcase
         then then
      then
      0  \ fillLog
      over 0 <> if
         logMode @ 3 = if
            over 4 <> over previousGesture @ <> and  over 3 < or if drop 1 then
         else logMode @ 2 = if
            over 4 <> if drop 1 then
         else logMode @ 1 = if
            over previousGesture @ <> if drop 1 then
         else drop 1 then then then
      then
      if
         dup previousGesture !
         dup GetGestureColor gestureColor !
         gestureLogIndex @ 0 <= if GESTURE_LOG_SIZE gestureLogIndex ! then
         -1 gestureLogIndex +!
         gestureLogIndex @ glog  over GetGestureName TextCopy drop
      then
      dup 255 > if GetGesturePinchAngle to currentAngleDegrees
      else dup 15 > if GetGestureDragAngle to currentAngleDegrees
      else dup 0 > if 0e to currentAngleDegrees then then then
      currentAngleDegrees 90e f+ pi f* 180e f/  \ radians
      fdup fsin angleLength f* protractorPosition v2x f+
      fswap fcos angleLength f* protractorPosition v2y f+
      finalVector Vector2!
      GetTouchPointCount
      over GESTURE_NONE <> if
         dup 0 <> if
            dup 0 ?do  i touch-at i GetTouchPosition drop  loop
         else
            mousePosition GetMousePosition drop
         then
      then
      \ g touchCount
      BeginDrawing
         RAYWHITE ClearBackground
         z" *" messagePosition v2x f>s 5 + messagePosition v2y f>s 5 + 10 BLACK DrawText
         z" Example optimized for Web/HTML5" messagePosition v2x f>s 15 + messagePosition v2y f>s 5 + 10 BLACK DrawText
         z" Last gesture" lastGesturePosition v2x f>s 33 + lastGesturePosition v2y f>s 47 - 20 BLACK DrawText
         lastGesturePosition v2x f>s 20 + lastGesturePosition v2y f>s 20 20
         lastGesture @ GESTURE_SWIPE_UP = if RED else LIGHTGRAY then DrawRectangle
         lastGesturePosition v2x f>s lastGesturePosition v2y f>s 20 + 20 20
         lastGesture @ GESTURE_SWIPE_LEFT = if RED else LIGHTGRAY then DrawRectangle
         lastGesturePosition v2x f>s 40 + lastGesturePosition v2y f>s 20 + 20 20
         lastGesture @ GESTURE_SWIPE_RIGHT = if RED else LIGHTGRAY then DrawRectangle
         lastGesturePosition v2x f>s 20 + lastGesturePosition v2y f>s 40 + 20 20
         lastGesture @ GESTURE_SWIPE_DOWN = if RED else LIGHTGRAY then DrawRectangle
         lastGesturePosition v2x f>s 80 + lastGesturePosition v2y f>s 16 + 10e
         lastGesture @ GESTURE_TAP = if BLUE else LIGHTGRAY then DrawCircle
         lastGesturePosition v2x f>s 80 + lastGesturePosition v2y f>s 43 + 10e
         lastGesture @ GESTURE_DOUBLETAP = if SKYBLUE else LIGHTGRAY then DrawCircle
         z" Log" gestureLogPosition v2x f>s gestureLogPosition v2y f>s 20 BLACK DrawText
         gestureLogIndex @
         GESTURE_LOG_SIZE 0 ?do
            dup glog  gestureLogPosition v2x f>s  gestureLogPosition v2y f>s 410 + i 20 * -  20
            i 0= if gestureColor @ else LIGHTGRAY then DrawText
            1+ GESTURE_LOG_SIZE mod
         loop drop
         logButton1  logMode @ 1 = logMode @ 3 = or if MAROON else GRAY then DrawRectangleRec
         z" Hide" logButton1 sf@ f>s 7 + logButton1 4 + sf@ f>s 3 + 10 WHITE DrawText
         z" Repeat" logButton1 sf@ f>s 7 + logButton1 4 + sf@ f>s 13 + 10 WHITE DrawText
         logButton2  logMode @ 2 = logMode @ 3 = or if MAROON else GRAY then DrawRectangleRec
         z" Hide" logButton1 sf@ f>s 62 + logButton1 4 + sf@ f>s 3 + 10 WHITE DrawText
         z" Hold" logButton1 sf@ f>s 62 + logButton1 4 + sf@ f>s 13 + 10 WHITE DrawText
         z" Angle" protractorPosition v2x f>s 55 + protractorPosition v2y f>s 76 + 10 BLACK DrawText
         protractorPosition 80e WHITE DrawCircleV
         protractorPosition v2x 90e f- protractorPosition v2y vA Vector2!
         protractorPosition v2x 90e f+ protractorPosition v2y vB Vector2!
         vA vB 3e LIGHTGRAY DrawLineEx
         protractorPosition v2x protractorPosition v2y 90e f- vA Vector2!
         protractorPosition v2x protractorPosition v2y 90e f+ vB Vector2!
         vA vB 3e LIGHTGRAY DrawLineEx
         currentAngleDegrees f0= 0= if protractorPosition finalVector 3e gestureColor @ DrawLineEx then
         2dup GESTURE_NONE <> swap 0= and 0= if
            over GESTURE_NONE <> if
               dup 0 <> if
                  dup 0 ?do
                     i touch-at 50e gestureColor @ 0.5e Fade DrawCircleV
                     i touch-at 5e gestureColor @ DrawCircleV
                  loop
               else
                  mousePosition 35e gestureColor @ 0.5e Fade DrawCircleV
                  mousePosition 5e gestureColor @ DrawCircleV
               then
            then
         then
      EndDrawing
      2drop
   WindowShouldClose until
   CloseWindow ;

example-end
