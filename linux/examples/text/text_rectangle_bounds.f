\ Port of raylib examples/text/text_rectangle_bounds.c
\ Word-wrap uses scissor + DrawTextEx (full glyph-walk wrap is C-only complexity).

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE container 16 ALLOT
CREATE resizer 16 ALLOT
CREATE lastMouse 16 ALLOT
CREATE font 64 ALLOT
CREATE textRec 16 ALLOT
CREATE box 16 ALLOT
CREATE tpos 16 ALLOT
VARIABLE resizing
VARIABLE wordWrap
VARIABLE borderColor
60e FCONSTANT minWidth
60e FCONSTANT minHeight

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;
: rec-x ( a -- ) ( F: -- x ) sf@ ;
: rec-y ( a -- ) ( F: -- y ) 4 + sf@ ;
: rec-w ( a -- ) ( F: -- w ) 8 + sf@ ;
: rec-h ( a -- ) ( F: -- h ) 12 + sf@ ;

: DrawTextBoxed ( font z rec F: size spc  wrap color -- )
   >r drop
   dup rec-x f>s over rec-y f>s  2 pick rec-w f>s  3 pick rec-h f>s BeginScissorMode
   dup rec-x over rec-y tpos Vector2!
   drop tpos r> DrawTextEx
   EndScissorMode ;

: example
   screenWidth screenHeight z" raylib [text] example - rectangle bounds" InitWindow
   0 resizing !
   1 wordWrap !
   25e 25e screenWidth 50 - s>f screenHeight 250 - s>f container Rec!
   container rec-x container rec-w f+ 17e f-  container rec-y container rec-h f+ 17e f-  14e 14e resizer Rec!
   0e 0e lastMouse Vector2!
   MAROON borderColor !
   font GetFontDefault drop
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if wordWrap @ 0= wordWrap ! then
      mouse@ container CheckCollisionPointRec if MAROON 0.4e Fade else
         resizing @ 0= if MAROON else borderColor @ then
      then borderColor !
      resizing @ if
         MOUSE_BUTTON_LEFT IsMouseButtonReleased if 0 resizing ! then
         container rec-w mouse@ v2x lastMouse v2x f- f+
         fdup minWidth f< if fdrop minWidth then
         fdup screenWidth 50 - s>f f> if fdrop screenWidth 50 - s>f then
         container 8 + sf!
         container rec-h mouse@ v2y lastMouse v2y f- f+
         fdup minHeight f< if fdrop minHeight then
         fdup screenHeight 160 - s>f f> if fdrop screenHeight 160 - s>f then
         container 12 + sf!
      else
         MOUSE_BUTTON_LEFT IsMouseButtonDown mouse@ resizer CheckCollisionPointRec and if 1 resizing ! then
      then
      container rec-x container rec-w f+ 17e f- container rec-y container rec-h f+ 17e f- 14e 14e resizer Rec!
      mouse@ lastMouse 8 move
      BeginDrawing
         RAYWHITE ClearBackground
         container 3e borderColor @ DrawRectangleLinesEx
         container rec-x 4e f+ container rec-y 4e f+ container rec-w 4e f- container rec-h 4e f- textRec Rec!
         font z" Text cannot escape this container ... word wrap also works when active so here's a long text for testing. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            textRec 20e 2e wordWrap @ GRAY DrawTextBoxed
         resizer borderColor @ DrawRectangleRec
         0 screenHeight 54 - screenWidth 54 GRAY DrawRectangle
         382e screenHeight 34 - s>f 12e 12e box Rec!  box MAROON DrawRectangleRec
         z" Word Wrap: " 313 screenHeight 115 - 20 BLACK DrawText
         wordWrap @ if z" ON" else z" OFF" then 447 screenHeight 115 - 20 wordWrap @ if RED else BLACK then DrawText
         z" Press [SPACE] to toggle word wrap" 218 screenHeight 86 - 20 GRAY DrawText
         z" Click hold & drag the    to resize the container" 155 screenHeight 38 - 20 RAYWHITE DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
