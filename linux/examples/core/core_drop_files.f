\ Port of raylib examples/core/core_drop_files.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
4096 CONSTANT MAX_FILEPATH_RECORDED
2048 CONSTANT MAX_FILEPATH_SIZE

VARIABLE filePathCounter
CREATE filePaths  MAX_FILEPATH_RECORDED CELLS ALLOT
CREATE dropped 16 ALLOT

: path-at ( i -- zaddr ) CELLS filePaths + @ ;

: alloc-paths
   MAX_FILEPATH_RECORDED 0 ?do
      MAX_FILEPATH_SIZE MemAlloc  i CELLS filePaths + !
   loop ;

: free-paths
   MAX_FILEPATH_RECORDED 0 ?do
      i path-at MemFree
   loop ;

: example
   0 filePathCounter !
   alloc-paths
   screenWidth screenHeight z" raylib [core] example - drop files" InitWindow
   60 SetTargetFPS
   begin
      IsFileDropped 1 and if
         dropped LoadDroppedFiles drop
         dropped filePathList_count l@  0
         ?do
            filePathCounter @ MAX_FILEPATH_RECORDED 1- < if
               filePathCounter @ path-at
               dropped filePathList_paths @ i CELLS + @
               TextCopy drop
               1 filePathCounter +!
            then
         loop
         dropped UnloadDroppedFiles
      then
      BeginDrawing
         RAYWHITE ClearBackground
         filePathCounter @ 0= if
            z" Drop your files to this window!" 100 40 20 DARKGRAY DrawText
         else
            z" Dropped files:" 100 40 20 DARKGRAY DrawText
            filePathCounter @ 0 ?do
               i 2 mod 0= if
                  0  85 i 40 * +  screenWidth 40  LIGHTGRAY 0.5e Fade DrawRectangle
               else
                  0  85 i 40 * +  screenWidth 40  LIGHTGRAY 0.3e Fade DrawRectangle
               then
               i path-at 120  100 i 40 * +  10 GRAY DrawText
            loop
            z" Drop new files..." 100  110 filePathCounter @ 40 * +  20 DARKGRAY DrawText
         then
      EndDrawing
   WindowShouldClose until
   free-paths
   CloseWindow ;

example-end
