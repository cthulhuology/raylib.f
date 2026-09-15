\ Port of raylib examples/textures/textures_mouse_painting.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
23 CONSTANT MAX_COLORS_COUNT

CREATE colors
RAYWHITE , YELLOW , GOLD , ORANGE , PINK , RED , MAROON , GREEN , LIME , DARKGREEN ,
SKYBLUE , BLUE , DARKBLUE , PURPLE , VIOLET , DARKPURPLE , BEIGE , BROWN , DARKBROWN ,
LIGHTGRAY , GRAY , DARKGRAY , BLACK ,

CREATE colorsRecs 23 16 * ALLOT
CREATE btnSaveRec 16 ALLOT
CREATE target 64 ALLOT
CREATE src 16 ALLOT
CREATE img 32 ALLOT
CREATE selRec 16 ALLOT
CREATE origin 16 ALLOT

VARIABLE colorSelected
VARIABLE colorSelectedPrev
VARIABLE colorMouseHover
FVARIABLE brushSize
VARIABLE mouseWasPressed
VARIABLE btnSaveMouseHover
VARIABLE showSaveMessage
VARIABLE saveMessageCounter

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: rec[] ( i -- a ) 16 * colorsRecs + ;
: col[] ( i -- u ) cells colors + @ ;

: example
   screenWidth screenHeight z" raylib [textures] example - mouse painting" InitWindow
   MAX_COLORS_COUNT 0 do
      10e 30e i s>f f* f+ i 2* s>f f+  10e 30e 30e  i rec[] Rec!
   loop
   0 colorSelected !
   0 colorSelectedPrev !
   0 colorMouseHover !
   20e brushSize f!
   0 mouseWasPressed !
   750e 10e 40e 30e btnSaveRec Rec!
   0 btnSaveMouseHover !
   0 showSaveMessage !
   0 saveMessageCounter !
   0e 0e origin Vector2!
   target screenWidth screenHeight LoadRenderTexture drop
   target BeginTextureMode
      0 col[] ClearBackground
   EndTextureMode
   120 SetTargetFPS
   begin
      KEY_RIGHT IsKeyPressed if 1 colorSelected +! then
      KEY_LEFT  IsKeyPressed if -1 colorSelected +! then
      colorSelected @ MAX_COLORS_COUNT >= if MAX_COLORS_COUNT 1- colorSelected ! then
      colorSelected @ 0< if 0 colorSelected ! then
      -1 colorMouseHover !
      MAX_COLORS_COUNT 0 do
         mouse@ i rec[] CheckCollisionPointRec if i colorMouseHover ! then
      loop
      colorMouseHover @ 0< 0= MOUSE_BUTTON_LEFT IsMouseButtonPressed and if
         colorMouseHover @ dup colorSelected ! colorSelectedPrev !
      then
      GetMouseWheelMove 5e f* brushSize f@ f+ brushSize f!
      brushSize f@ 2e f< if 2e brushSize f! then
      brushSize f@ 50e f> if 50e brushSize f! then
      KEY_C IsKeyPressed if
         target BeginTextureMode  0 col[] ClearBackground  EndTextureMode
      then
      MOUSE_BUTTON_LEFT IsMouseButtonDown  GetGestureDetected GESTURE_DRAG = or if
         target BeginTextureMode
            mouse@ v2y 50e f> if
               mouse@ v2x f>s mouse@ v2y f>s brushSize f@ colorSelected @ col[] DrawCircle
            then
         EndTextureMode
      then
      MOUSE_BUTTON_RIGHT IsMouseButtonDown if
         mouseWasPressed @ 0= if colorSelected @ colorSelectedPrev !  0 colorSelected ! then
         1 mouseWasPressed !
         target BeginTextureMode
            mouse@ v2y 50e f> if
               mouse@ v2x f>s mouse@ v2y f>s brushSize f@ 0 col[] DrawCircle
            then
         EndTextureMode
      else
         MOUSE_BUTTON_RIGHT IsMouseButtonReleased mouseWasPressed @ and if
            colorSelectedPrev @ colorSelected !
            0 mouseWasPressed !
         then
      then
      mouse@ btnSaveRec CheckCollisionPointRec if 1 else 0 then btnSaveMouseHover !
      btnSaveMouseHover @ MOUSE_BUTTON_LEFT IsMouseButtonReleased and  KEY_S IsKeyPressed or if
         img target render_texture_texture LoadImageFromTexture drop
         img ImageFlipVertical
         img z" my_amazing_texture_painting.png" ExportImage drop
         img UnloadImage
         1 showSaveMessage !
      then
      showSaveMessage @ if
         1 saveMessageCounter +!
         saveMessageCounter @ 240 > if 0 showSaveMessage !  0 saveMessageCounter ! then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         0e 0e
         target render_texture_texture texture_width l@ s>f
         target render_texture_texture texture_height l@ s>f fnegate
         src Rec!
         0e 0e origin Vector2!
         target render_texture_texture src origin WHITE DrawTextureRec
         mouse@ v2y 50e f> if
            MOUSE_BUTTON_RIGHT IsMouseButtonDown if
               mouse@ v2x f>s mouse@ v2y f>s brushSize f@ GRAY DrawCircleLines
            else
               GetMouseX GetMouseY brushSize f@ colorSelected @ col[] DrawCircle
            then
         then
         0 0 GetScreenWidth 50 RAYWHITE DrawRectangle
         0 50 GetScreenWidth 50 LIGHTGRAY DrawLine
         MAX_COLORS_COUNT 0 do i rec[] i col[] DrawRectangleRec loop
         10 10 30 30 LIGHTGRAY DrawRectangleLines
         colorMouseHover @ 0< 0= if
            colorMouseHover @ rec[] WHITE 0.6e Fade DrawRectangleRec
         then
         colorSelected @ rec[] sf@ 2e f-  colorSelected @ rec[] 4 + sf@ 2e f-
         colorSelected @ rec[] 8 + sf@ 4e f+  colorSelected @ rec[] 12 + sf@ 4e f+
         selRec Rec!
         selRec 2e BLACK DrawRectangleLinesEx
         btnSaveRec 2e btnSaveMouseHover @ if RED else BLACK then DrawRectangleLinesEx
         z" SAVE!" 755 20 10 btnSaveMouseHover @ if RED else BLACK then DrawText
         showSaveMessage @ if
            0 0 GetScreenWidth GetScreenHeight RAYWHITE 0.8e Fade DrawRectangle
            0 150 GetScreenWidth 80 BLACK DrawRectangle
            z" IMAGE SAVED!" 150 180 20 RAYWHITE DrawText
         then
      EndDrawing
   WindowShouldClose until
   target UnloadRenderTexture
   CloseWindow ;

example-end
