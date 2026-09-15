\ Port of raylib examples/core/core_storage_values.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

0 CONSTANT STORAGE_POSITION_SCORE
1 CONSTANT STORAGE_POSITION_HISCORE

VARIABLE score
VARIABLE hiscore
VARIABLE framesCounter
VARIABLE dataSize

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

CREATE store 8 ALLOT

: SaveStorageValue ( pos value -- )
   z" storage.data" dataSize LoadFileData
   dup 0= if
      drop  8 MemAlloc  8 dataSize l!
      store 8 erase
   else
      8 dataSize l@ max dataSize l!
   then
   >r
   swap 4 * r@ + l!
   z" storage.data" r@ 8 SaveFileData drop
   r> MemFree ;

: LoadStorageValue ( pos -- n )
   0 dataSize l!
   z" storage.data" dataSize LoadFileData
   dup if
      >r
      dataSize l@  over 4 *  > if
         4 * r@ + l@
      else drop 0 then
      r> UnloadFileData
   else drop drop 0 then ;

: example
   0 score !  0 hiscore !  0 framesCounter !
   screenWidth screenHeight z" raylib [core] example - storage values" InitWindow
   60 SetTargetFPS
   begin
      KEY_R IsKeyPressed 1 and if
         1000 2000 GetRandomValue score !
         2000 4000 GetRandomValue hiscore !
      then
      KEY_ENTER IsKeyPressed 1 and if
         STORAGE_POSITION_SCORE score @ SaveStorageValue
         STORAGE_POSITION_HISCORE hiscore @ SaveStorageValue
      else KEY_SPACE IsKeyPressed 1 and if
         STORAGE_POSITION_SCORE LoadStorageValue score !
         STORAGE_POSITION_HISCORE LoadStorageValue hiscore !
      then then
      1 framesCounter +!
      BeginDrawing
         RAYWHITE ClearBackground
         z" SCORE: " 280 130 40 MAROON DrawText
         score @ n>z 430 130 40 MAROON DrawText
         z" HI-SCORE: " 210 200 50 BLACK DrawText
         hiscore @ n>z 480 200 50 BLACK DrawText
         z" frames: " 10 10 20 LIME DrawText
         framesCounter @ n>z 100 10 20 LIME DrawText
         z" Press R to generate random numbers" 220 40 20 LIGHTGRAY DrawText
         z" Press ENTER to SAVE values" 250 310 20 LIGHTGRAY DrawText
         z" Press SPACE to LOAD values" 252 350 20 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
