\ Port of raylib examples/core/core_input_actions.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

0 CONSTANT NO_ACTION
1 CONSTANT ACTION_UP
2 CONSTANT ACTION_DOWN
3 CONSTANT ACTION_LEFT
4 CONSTANT ACTION_RIGHT
5 CONSTANT ACTION_FIRE
6 CONSTANT MAX_ACTION

VARIABLE gamepadIndex
\ ActionInput: key, button  (2 cells)
CREATE actionInputs  MAX_ACTION 2 CELLS * ALLOT
VARIABLE actionSet
CREATE position 8 ALLOT
CREATE size 8 ALLOT

: act-key ( action -- addr ) 2 CELLS * actionInputs + ;
: act-btn ( action -- addr ) 2 CELLS * actionInputs + CELL+ ;

: IsActionPressed ( action -- flag )
   dup MAX_ACTION < if
      dup act-key @ IsKeyPressed 1 and
      swap act-btn @ gamepadIndex @ swap IsGamepadButtonPressed 1 and or
   else drop 0 then ;

: IsActionReleased ( action -- flag )
   dup MAX_ACTION < if
      dup act-key @ IsKeyReleased 1 and
      swap act-btn @ gamepadIndex @ swap IsGamepadButtonReleased 1 and or
   else drop 0 then ;

: IsActionDown ( action -- flag )
   dup MAX_ACTION < if
      dup act-key @ IsKeyDown 1 and
      swap act-btn @ gamepadIndex @ swap IsGamepadButtonDown 1 and or
   else drop 0 then ;

: SetActionsDefault
   KEY_W     ACTION_UP    act-key !
   KEY_S     ACTION_DOWN  act-key !
   KEY_A     ACTION_LEFT  act-key !
   KEY_D     ACTION_RIGHT act-key !
   KEY_SPACE ACTION_FIRE  act-key !
   GAMEPAD_BUTTON_LEFT_FACE_UP     ACTION_UP    act-btn !
   GAMEPAD_BUTTON_LEFT_FACE_DOWN   ACTION_DOWN  act-btn !
   GAMEPAD_BUTTON_LEFT_FACE_LEFT   ACTION_LEFT  act-btn !
   GAMEPAD_BUTTON_LEFT_FACE_RIGHT  ACTION_RIGHT act-btn !
   GAMEPAD_BUTTON_RIGHT_FACE_DOWN  ACTION_FIRE  act-btn ! ;

: SetActionsCursor
   KEY_UP    ACTION_UP    act-key !
   KEY_DOWN  ACTION_DOWN  act-key !
   KEY_LEFT  ACTION_LEFT  act-key !
   KEY_RIGHT ACTION_RIGHT act-key !
   KEY_SPACE ACTION_FIRE  act-key !
   GAMEPAD_BUTTON_RIGHT_FACE_UP    ACTION_UP    act-btn !
   GAMEPAD_BUTTON_RIGHT_FACE_DOWN  ACTION_DOWN  act-btn !
   GAMEPAD_BUTTON_RIGHT_FACE_LEFT  ACTION_LEFT  act-btn !
   GAMEPAD_BUTTON_RIGHT_FACE_RIGHT ACTION_RIGHT act-btn !
   GAMEPAD_BUTTON_LEFT_FACE_DOWN   ACTION_FIRE  act-btn ! ;

: example
   0 gamepadIndex !
   0 actionSet !
   SetActionsDefault
   400e 200e position Vector2!
   40e 40e size Vector2!
   screenWidth screenHeight z" raylib [core] example - input actions" InitWindow
   60 SetTargetFPS
   begin
      0 gamepadIndex !
      ACTION_UP    IsActionDown if position v2x  position v2y 2e f-  position Vector2! then
      ACTION_DOWN  IsActionDown if position v2x  position v2y 2e f+  position Vector2! then
      ACTION_LEFT  IsActionDown if position v2x 2e f-  position v2y  position Vector2! then
      ACTION_RIGHT IsActionDown if position v2x 2e f+  position v2y  position Vector2! then
      ACTION_FIRE  IsActionPressed if
         screenWidth s>f size v2x f- 2e f/  screenHeight s>f size v2y f- 2e f/  position Vector2!
      then
      KEY_TAB IsKeyPressed 1 and if
         actionSet @ 0= actionSet !
         actionSet @ 0= if SetActionsDefault else SetActionsCursor then
      then
      BeginDrawing
         GRAY ClearBackground
         position size RED DrawRectangleV
         actionSet @ 0= if
            z" Current input set: WASD (default)" 10 10 20 WHITE DrawText
         else
            z" Current input set: Cursor" 10 10 20 WHITE DrawText
         then
         z" Use TAB key to toggles Actions keyset" 10 50 20 GREEN DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
