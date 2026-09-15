\ Port of raylib examples/core/core_directory_files.c
\ raygui GuiButton replaced with mouse hit-tests

800 CONSTANT screenWidth
450 CONSTANT screenHeight
2048 CONSTANT MAX_FILEPATH_SIZE

CREATE directory MAX_FILEPATH_SIZE ALLOT
CREATE files 16 ALLOT
CREATE btnBack 16 ALLOT
CREATE rowRec 16 ALLOT
CREATE click 8 ALLOT

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: file-path ( i -- zaddr )
   files filePathList_paths @ swap CELLS + @ ;

: reload-dir
   files UnloadDirectoryFiles
   files directory LoadDirectoryFiles drop ;

: example
   GetWorkingDirectory directory swap TextCopy drop
   files directory LoadDirectoryFiles drop
   40e 40e 20e 20e btnBack Rectangle!
   screenWidth screenHeight z" raylib [core] example - directory files" InitWindow
   60 SetTargetFPS
   begin
      click GetMousePosition drop
      MOUSE_BUTTON_LEFT IsMouseButtonPressed 1 and if
         click btnBack CheckCollisionPointRec 1 and if
            directory dup GetPrevDirectoryPath TextCopy drop
            reload-dir
         then
         files filePathList_count l@ 0 ?do
            0e  85e i s>f 40e f* f+  screenWidth s>f  40e  rowRec Rectangle!
            click rowRec CheckCollisionPointRec 1 and
            i file-path IsPathFile 1 and 0= and if
               directory i file-path TextCopy drop
               reload-dir
               leave
            then
         loop
      then
      BeginDrawing
         RAYWHITE ClearBackground
         directory 100 40 20 DARKGRAY DrawText
         btnBack LIGHTGRAY DrawRectangleRec
         z" <" 44 42 16 BLACK DrawText
         files filePathList_count l@ 0 ?do
            0  85 i 40 * +  screenWidth 40  LIGHTGRAY 0.3e Fade DrawRectangle
            i file-path GetFileName  120  100 i 40 * +  10 GRAY DrawText
         loop
      EndDrawing
   WindowShouldClose until
   files UnloadDirectoryFiles
   CloseWindow ;

example-end
