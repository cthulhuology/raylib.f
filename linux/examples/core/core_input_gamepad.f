\ Port of raylib examples/core/core_input_gamepad.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE texPs3Pad 20 ALLOT
CREATE texXboxPad 20 ALLOT
VARIABLE gamepad
0.1e fconstant leftStickDeadzoneX
0.1e fconstant leftStickDeadzoneY
0.1e fconstant rightStickDeadzoneX
0.1e fconstant rightStickDeadzoneY
-0.9e fconstant leftTriggerDeadzone
-0.9e fconstant rightTriggerDeadzone

0e fvalue leftStickX
0e fvalue leftStickY
0e fvalue rightStickX
0e fvalue rightStickY
0e fvalue leftTrigger
0e fvalue rightTrigger

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

CREATE rec 16 ALLOT
: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

CREATE tri1 8 ALLOT
CREATE tri2 8 ALLOT
CREATE tri3 8 ALLOT

: xbox-like? ( -- flag )
   gamepad @ GetGamepadName TextToLower dup
   z" xbox" TextFindIndex -1 > swap
   z" x-box" TextFindIndex -1 > or ;

: ps-like? ( -- flag )
   gamepad @ GetGamepadName TextToLower z" playstation" TextFindIndex -1 > ;

: deadzone
   gamepad @ GAMEPAD_AXIS_LEFT_X GetGamepadAxisMovement to leftStickX
   gamepad @ GAMEPAD_AXIS_LEFT_Y GetGamepadAxisMovement to leftStickY
   gamepad @ GAMEPAD_AXIS_RIGHT_X GetGamepadAxisMovement to rightStickX
   gamepad @ GAMEPAD_AXIS_RIGHT_Y GetGamepadAxisMovement to rightStickY
   gamepad @ GAMEPAD_AXIS_LEFT_TRIGGER GetGamepadAxisMovement to leftTrigger
   gamepad @ GAMEPAD_AXIS_RIGHT_TRIGGER GetGamepadAxisMovement to rightTrigger
   leftStickX leftStickDeadzoneX fnegate f> leftStickX leftStickDeadzoneX f< and if 0e to leftStickX then
   leftStickY leftStickDeadzoneY fnegate f> leftStickY leftStickDeadzoneY f< and if 0e to leftStickY then
   rightStickX rightStickDeadzoneX fnegate f> rightStickX rightStickDeadzoneX f< and if 0e to rightStickX then
   rightStickY rightStickDeadzoneY fnegate f> rightStickY rightStickDeadzoneY f< and if 0e to rightStickY then
   leftTrigger leftTriggerDeadzone f< if -1e to leftTrigger then
   rightTrigger rightTriggerDeadzone f< if -1e to rightTrigger then ;

: draw-xbox
   texXboxPad 0 0 DARKGRAY DrawTexture
   gamepad @ GAMEPAD_BUTTON_MIDDLE IsGamepadButtonDown 1 and if 394 89 19e RED DrawCircle then
   gamepad @ GAMEPAD_BUTTON_MIDDLE_RIGHT IsGamepadButtonDown 1 and if 436 150 9e RED DrawCircle then
   gamepad @ GAMEPAD_BUTTON_MIDDLE_LEFT IsGamepadButtonDown 1 and if 352 150 9e RED DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_LEFT IsGamepadButtonDown 1 and if 501 151 15e BLUE DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_DOWN IsGamepadButtonDown 1 and if 536 187 15e LIME DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_RIGHT IsGamepadButtonDown 1 and if 572 151 15e MAROON DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_UP IsGamepadButtonDown 1 and if 536 115 15e GOLD DrawCircle then
   317 202 19 71 BLACK DrawRectangle
   293 228 69 19 BLACK DrawRectangle
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_UP IsGamepadButtonDown 1 and if 317 202 19 26 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_DOWN IsGamepadButtonDown 1 and if 317 247 19 26 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_LEFT IsGamepadButtonDown 1 and if 292 228 25 19 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_RIGHT IsGamepadButtonDown 1 and if 336 228 26 19 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_TRIGGER_1 IsGamepadButtonDown 1 and if 259 61 20e RED DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_TRIGGER_1 IsGamepadButtonDown 1 and if 536 61 20e RED DrawCircle then
   BLACK  gamepad @ GAMEPAD_BUTTON_LEFT_THUMB IsGamepadButtonDown 1 and if drop RED then
   259 152 39e BLACK DrawCircle
   259 152 34e LIGHTGRAY DrawCircle
   259 leftStickX 20e f* f>s +  152 leftStickY 20e f* f>s +  25e  rot DrawCircle
   BLACK  gamepad @ GAMEPAD_BUTTON_RIGHT_THUMB IsGamepadButtonDown 1 and if drop RED then
   461 237 38e BLACK DrawCircle
   461 237 33e LIGHTGRAY DrawCircle
   461 rightStickX 20e f* f>s +  237 rightStickY 20e f* f>s +  25e rot DrawCircle
   170 30 15 70 GRAY DrawRectangle
   604 30 15 70 GRAY DrawRectangle
   170 30 15  1e leftTrigger f+ 2e f/ 70e f* f>s RED DrawRectangle
   604 30 15  1e rightTrigger f+ 2e f/ 70e f* f>s RED DrawRectangle ;

: draw-ps
   texPs3Pad 0 0 DARKGRAY DrawTexture
   gamepad @ GAMEPAD_BUTTON_MIDDLE IsGamepadButtonDown 1 and if 396 222 13e RED DrawCircle then
   gamepad @ GAMEPAD_BUTTON_MIDDLE_LEFT IsGamepadButtonDown 1 and if 328 170 32 13 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_MIDDLE_RIGHT IsGamepadButtonDown 1 and if
      436e 168e tri1 Vector2!  436e 185e tri2 Vector2!  464e 177e tri3 Vector2!
      tri1 tri2 tri3 RED DrawTriangle
   then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_UP IsGamepadButtonDown 1 and if 557 144 13e LIME DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_RIGHT IsGamepadButtonDown 1 and if 586 173 13e RED DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_DOWN IsGamepadButtonDown 1 and if 557 203 13e VIOLET DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_LEFT IsGamepadButtonDown 1 and if 527 173 13e PINK DrawCircle then
   225 132 24 84 BLACK DrawRectangle
   195 161 84 25 BLACK DrawRectangle
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_UP IsGamepadButtonDown 1 and if 225 132 24 29 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_DOWN IsGamepadButtonDown 1 and if 225 186 24 30 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_LEFT IsGamepadButtonDown 1 and if 195 161 30 25 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_RIGHT IsGamepadButtonDown 1 and if 249 161 30 25 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_TRIGGER_1 IsGamepadButtonDown 1 and if 239 82 20e RED DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_TRIGGER_1 IsGamepadButtonDown 1 and if 557 82 20e RED DrawCircle then
   BLACK  gamepad @ GAMEPAD_BUTTON_LEFT_THUMB IsGamepadButtonDown 1 and if drop RED then
   319 255 35e BLACK DrawCircle
   319 255 31e LIGHTGRAY DrawCircle
   319 leftStickX 20e f* f>s +  255 leftStickY 20e f* f>s +  25e rot DrawCircle
   BLACK  gamepad @ GAMEPAD_BUTTON_RIGHT_THUMB IsGamepadButtonDown 1 and if drop RED then
   475 255 35e BLACK DrawCircle
   475 255 31e LIGHTGRAY DrawCircle
   475 rightStickX 20e f* f>s +  255 rightStickY 20e f* f>s +  25e rot DrawCircle
   169 48 15 70 GRAY DrawRectangle
   611 48 15 70 GRAY DrawRectangle
   169 48 15  1e leftTrigger f+ 2e f/ 70e f* f>s RED DrawRectangle
   611 48 15  1e rightTrigger f+ 2e f/ 70e f* f>s RED DrawRectangle ;

: draw-generic
   175e 110e 460e 220e rec Rectangle!  rec 0.3e 16 DARKGRAY DrawRectangleRounded
   365 170 12e RAYWHITE DrawCircle
   405 170 12e RAYWHITE DrawCircle
   445 170 12e RAYWHITE DrawCircle
   516 191 17e RAYWHITE DrawCircle
   551 227 17e RAYWHITE DrawCircle
   587 191 17e RAYWHITE DrawCircle
   551 155 17e RAYWHITE DrawCircle
   gamepad @ GAMEPAD_BUTTON_MIDDLE_LEFT IsGamepadButtonDown 1 and if 365 170 10e RED DrawCircle then
   gamepad @ GAMEPAD_BUTTON_MIDDLE IsGamepadButtonDown 1 and if 405 170 10e GREEN DrawCircle then
   gamepad @ GAMEPAD_BUTTON_MIDDLE_RIGHT IsGamepadButtonDown 1 and if 445 170 10e BLUE DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_LEFT IsGamepadButtonDown 1 and if 516 191 15e GOLD DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_DOWN IsGamepadButtonDown 1 and if 551 227 15e BLUE DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_RIGHT IsGamepadButtonDown 1 and if 587 191 15e GREEN DrawCircle then
   gamepad @ GAMEPAD_BUTTON_RIGHT_FACE_UP IsGamepadButtonDown 1 and if 551 155 15e RED DrawCircle then
   245 145 28 88 RAYWHITE DrawRectangle
   215 174 88 29 RAYWHITE DrawRectangle
   247 147 24 84 BLACK DrawRectangle
   217 176 84 25 BLACK DrawRectangle
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_UP IsGamepadButtonDown 1 and if 247 147 24 29 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_DOWN IsGamepadButtonDown 1 and if 247 201 24 30 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_LEFT IsGamepadButtonDown 1 and if 217 176 30 25 RED DrawRectangle then
   gamepad @ GAMEPAD_BUTTON_LEFT_FACE_RIGHT IsGamepadButtonDown 1 and if 271 176 30 25 RED DrawRectangle then
   215e 98e 100e 10e rec Rectangle! rec 0.5e 16 DARKGRAY DrawRectangleRounded
   495e 98e 100e 10e rec Rectangle! rec 0.5e 16 DARKGRAY DrawRectangleRounded
   gamepad @ GAMEPAD_BUTTON_LEFT_TRIGGER_1 IsGamepadButtonDown 1 and if
      215e 98e 100e 10e rec Rectangle! rec 0.5e 16 RED DrawRectangleRounded
   then
   gamepad @ GAMEPAD_BUTTON_RIGHT_TRIGGER_1 IsGamepadButtonDown 1 and if
      495e 98e 100e 10e rec Rectangle! rec 0.5e 16 RED DrawRectangleRounded
   then
   BLACK  gamepad @ GAMEPAD_BUTTON_LEFT_THUMB IsGamepadButtonDown 1 and if drop RED then
   345 260 40e BLACK DrawCircle
   345 260 35e LIGHTGRAY DrawCircle
   345 leftStickX 20e f* f>s +  260 leftStickY 20e f* f>s +  25e rot DrawCircle
   BLACK  gamepad @ GAMEPAD_BUTTON_RIGHT_THUMB IsGamepadButtonDown 1 and if drop RED then
   465 260 40e BLACK DrawCircle
   465 260 35e LIGHTGRAY DrawCircle
   465 rightStickX 20e f* f>s +  260 rightStickY 20e f* f>s +  25e rot DrawCircle
   151 110 15 70 GRAY DrawRectangle
   644 110 15 70 GRAY DrawRectangle
   151 110 15  1e leftTrigger f+ 2e f/ 70e f* f>s RED DrawRectangle
   644 110 15  1e rightTrigger f+ 2e f/ 70e f* f>s RED DrawRectangle ;

: example
   0 gamepad !
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [core] example - input gamepad" InitWindow
   texPs3Pad z" /home/dave/Code/raylib/examples/core/resources/ps3.png" LoadTexture drop
   texXboxPad z" /home/dave/Code/raylib/examples/core/resources/xbox.png" LoadTexture drop
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         KEY_LEFT IsKeyPressed 1 and gamepad @ 0 > and if -1 gamepad +! then
         KEY_RIGHT IsKeyPressed 1 and if 1 gamepad +! then
         gamepad @ IsGamepadAvailable 1 and if
            z" GP" 10 10 10 BLACK DrawText
            gamepad @ n>z 30 10 10 BLACK DrawText
            gamepad @ GetGamepadName 50 10 10 BLACK DrawText
            deadzone
            xbox-like? if draw-xbox else
            ps-like? if draw-ps else draw-generic then then
            z" DETECTED AXIS:" 10 50 10 MAROON DrawText
            gamepad @ GetGamepadAxisCount 0 ?do
               z" AXIS" 20  70 i 20 * +  10 DARKGRAY DrawText
               i n>z 50  70 i 20 * +  10 DARKGRAY DrawText
            loop
            GetGamepadButtonPressed GAMEPAD_BUTTON_UNKNOWN <> if
               z" DETECTED BUTTON:" 10 430 10 RED DrawText
               GetGamepadButtonPressed n>z 140 430 10 RED DrawText
            else
               z" DETECTED BUTTON: NONE" 10 430 10 GRAY DrawText
            then
         else
            z" GP NOT DETECTED" 10 10 10 GRAY DrawText
            texXboxPad 0 0 LIGHTGRAY DrawTexture
         then
      EndDrawing
   WindowShouldClose until
   texPs3Pad UnloadTexture
   texXboxPad UnloadTexture
   CloseWindow ;

example-end
