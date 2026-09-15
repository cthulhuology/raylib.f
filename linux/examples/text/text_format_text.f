\ Port of raylib examples/text/text_format_text.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

100020 CONSTANT score
200450 CONSTANT hiscore
5 CONSTANT lives

: n>z08 ( n -- z ) 0 <# # # # # # # # # #> zres ;
: n>z02 ( n -- z ) 0 <# # # #> zres ;
: (f2.) ( F: r -- c-addr u )
   fdup f0< if fnegate 1 else 0 then >r
   100e f* 0.5e f+ f>s  0 <# # # [char] . hold #s r> if [char] - hold then #> ;

: example
   screenWidth screenHeight z" raylib [text] example - format text" InitWindow
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         z" Score: " 200 80 20 RED DrawText
         score n>z08 280 80 20 RED DrawText
         z" HiScore: " 200 120 20 GREEN DrawText
         hiscore n>z08 300 120 20 GREEN DrawText
         z" Lives: " 200 160 40 BLUE DrawText
         lives n>z02 340 160 40 BLUE DrawText
         z" Elapsed Time: " 200 220 20 BLACK DrawText
         GetFrameTime 1000e f* (f2.) zres 360 220 20 BLACK DrawText
         z" ms" 450 220 20 BLACK DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
