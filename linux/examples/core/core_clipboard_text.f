\ Port of raylib examples/core/core_clipboard_text.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE clipboardText
VARIABLE textIndex
VARIABLE popupText
3e fconstant maxTime
0.1e fconstant animMaxTime
-4 CONSTANT offsetAmount

0e fvalue textTimer
0e fvalue pasteAnim
0e fvalue copyAnim
0e fvalue textAnim
0e fvalue textAlpha
VARIABLE copyAnimMult

CREATE clipImage 24 ALLOT

CREATE copy0 20 ALLOT
CREATE copy1 20 ALLOT
CREATE copy2 20 ALLOT
CREATE copies 3 CELLS ALLOT

: copy-at ( i -- zaddr ) CELLS copies + @ ;

: init-copies
   z" raylib is fun" copy0 swap TextCopy drop
   z" hello, clipboard!" copy1 swap TextCopy drop
   z" potato chips" copy2 swap TextCopy drop
   copy0 copies !
   copy1 copies 1 CELLS + !
   copy2 copies 2 CELLS + ! ;

: paste-pressed? ( -- flag )
   KEY_LEFT_CONTROL down  KEY_V IsKeyPressed 1 and and ;

: copy-pressed? ( -- flag )
   KEY_LEFT_CONTROL down  KEY_C IsKeyPressed 1 and and ;

: example
   0 clipboardText !
   0 textIndex !
   0 popupText !
   0e to textTimer  0e to pasteAnim  0e to copyAnim
   0e to textAnim  0e to textAlpha
   1 copyAnimMult !
   init-copies
   screenWidth screenHeight z" raylib [core] example - clipboard text" InitWindow
   60 SetTargetFPS
   begin
      textTimer 0e f> if textTimer GetFrameTime f- to textTimer then
      pasteAnim 0e f> if pasteAnim GetFrameTime f- to pasteAnim then
      copyAnim  0e f> if copyAnim  GetFrameTime f- to copyAnim  then
      textAnim  0e f> if textAnim  GetFrameTime f- to textAnim  then
      paste-pressed? if
         clipImage GetClipboardImage drop
         clipImage IsImageValid 1 and if
            clipImage UnloadImage
            z" clipboard contains image" popupText !
         else
            GetClipboardText clipboardText !
            z" text pasted" popupText !
            animMaxTime to pasteAnim
         then
         maxTime to textTimer
         animMaxTime to textAnim
         1e to textAlpha
      then
      copy-pressed? if
         textIndex @ copy-at SetClipboardText
         maxTime to textTimer
         animMaxTime to textAnim
         animMaxTime to copyAnim
         1 copyAnimMult !
         1e to textAlpha
         z" text copied" popupText !
      then
      KEY_UP IsKeyPressed 1 and if
         animMaxTime to copyAnim
         1 copyAnimMult !
         1 textIndex +!
         textIndex @ 3 >= if 0 textIndex ! then
      then
      KEY_DOWN IsKeyPressed 1 and if
         animMaxTime to copyAnim
         -1 copyAnimMult !
         textIndex @ 0= if 2 textIndex ! else -1 textIndex +! then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         clipboardText @ if
            0
            pasteAnim 0e f> if drop offsetAmount then
            >r
            z" pasted clipboard:" 10 10 r@ + 20 DARKGREEN DrawText
            clipboardText @ 10 30 r> + 20 DARKGRAY DrawText
         then
         0
         copyAnim 0e f> if drop offsetAmount then
         copyAnimMult @ * 330 +
         textIndex @ copy-at  10 rot 20 MAROON DrawText
         z" up/down to change string, ctrl-c to copy, ctrl-v to paste" 10 355 20 DARKGRAY DrawText
         textAlpha 0e f> if
            0
            textAnim 0e f> if drop offsetAmount then
            popupText @ 10 425 rot + 20  DARKGREEN textAlpha ColorAlpha DrawText
            textTimer 0e f< if
               textAlpha GetFrameTime f- to textAlpha
            then
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
