\ Port of raylib examples/core/core_undo_redo.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
26 CONSTANT MAX_UNDO_STATES
24 CONSTANT GRID_CELL_SIZE
30 CONSTANT MAX_GRID_CELLS_X
13 CONSTANT MAX_GRID_CELLS_Y

\ PlayerState: cell.x cell.y color  (3 cells)
CREATE player 3 CELLS ALLOT
CREATE states  MAX_UNDO_STATES 3 CELLS * ALLOT
VARIABLE currentUndoIndex
VARIABLE firstUndoIndex
VARIABLE lastUndoIndex
VARIABLE undoFrameCounter
CREATE undoInfoPos 8 ALLOT
CREATE gridPosition 8 ALLOT

: ply-x player ;
: ply-y player CELL+ ;
: ply-c player 2 CELLS + ;

: st ( i -- addr ) 3 CELLS * states + ;

: copy-state ( dest src -- )  3 CELLS move ;

: state<> ( a b -- flag )
   over @ over @ <> >r
   over CELL+ @ over CELL+ @ <> r> or >r
   2 CELLS + @ swap 2 CELLS + @ <> r> or ;

: draw-undo ( -- )
   undoInfoPos v2x f>s 8 +  GRID_CELL_SIZE currentUndoIndex @ * +  undoInfoPos v2y f>s 10 -  8 8 RED DrawRectangle
   undoInfoPos v2x f>s 2 +  GRID_CELL_SIZE firstUndoIndex @ * +  undoInfoPos v2y f>s 27 +  8 8 BLACK DrawRectangleLines
   undoInfoPos v2x f>s 14 + GRID_CELL_SIZE lastUndoIndex @ * +   undoInfoPos v2y f>s 27 +  8 8 BLACK DrawRectangle
   MAX_UNDO_STATES 0 ?do
      undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup LIGHTGRAY DrawRectangle
      undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup GRAY DrawRectangleLines
   loop
   firstUndoIndex @ lastUndoIndex @ <= if
      lastUndoIndex @ 1+ firstUndoIndex @ ?do
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup SKYBLUE DrawRectangle
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup BLUE DrawRectangleLines
      loop
   else
      MAX_UNDO_STATES firstUndoIndex @ ?do
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup SKYBLUE DrawRectangle
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup BLUE DrawRectangleLines
      loop
      lastUndoIndex @ 1+ 0 ?do
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup SKYBLUE DrawRectangle
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup BLUE DrawRectangleLines
      loop
   then
   firstUndoIndex @ currentUndoIndex @ < if
      currentUndoIndex @ firstUndoIndex @ ?do
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup GREEN DrawRectangle
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup LIME DrawRectangleLines
      loop
   else currentUndoIndex @ firstUndoIndex @ < if
      MAX_UNDO_STATES firstUndoIndex @ ?do
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup GREEN DrawRectangle
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup LIME DrawRectangleLines
      loop
      currentUndoIndex @ 0 ?do
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup GREEN DrawRectangle
         undoInfoPos v2x f>s GRID_CELL_SIZE i * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup LIME DrawRectangleLines
      loop
   then then
   undoInfoPos v2x f>s GRID_CELL_SIZE currentUndoIndex @ * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup GOLD DrawRectangle
   undoInfoPos v2x f>s GRID_CELL_SIZE currentUndoIndex @ * +  undoInfoPos v2y f>s  GRID_CELL_SIZE dup ORANGE DrawRectangleLines ;

: example
   0 currentUndoIndex !  0 firstUndoIndex !  0 lastUndoIndex !  0 undoFrameCounter !
   110e 400e undoInfoPos Vector2!
   40e 60e gridPosition Vector2!
   10 ply-x !  10 ply-y !  RED ply-c !
   MAX_UNDO_STATES 0 ?do  i st player copy-state  loop
   screenWidth screenHeight z" raylib [core] example - undo redo" InitWindow
   60 SetTargetFPS
   begin
      KEY_RIGHT IsKeyPressed 1 and if 1 ply-x +! else
      KEY_LEFT  IsKeyPressed 1 and if -1 ply-x +! else
      KEY_UP    IsKeyPressed 1 and if -1 ply-y +! else
      KEY_DOWN  IsKeyPressed 1 and if 1 ply-y +! then then then then
      ply-x @ 0 < if 0 ply-x ! then
      ply-x @ MAX_GRID_CELLS_X >= if MAX_GRID_CELLS_X 1- ply-x ! then
      ply-y @ 0 < if 0 ply-y ! then
      ply-y @ MAX_GRID_CELLS_Y >= if MAX_GRID_CELLS_Y 1- ply-y ! then
      KEY_SPACE IsKeyPressed 1 and if
         20 255 GetRandomValue  20 220 GetRandomValue  20 240 GetRandomValue  255 RGBA ply-c !
      then
      1 undoFrameCounter +!
      undoFrameCounter @ 2 >= if
         currentUndoIndex @ st player state<> if
            1 currentUndoIndex +!
            currentUndoIndex @ MAX_UNDO_STATES >= if 0 currentUndoIndex ! then
            currentUndoIndex @ firstUndoIndex @ = if 1 firstUndoIndex +! then
            firstUndoIndex @ MAX_UNDO_STATES >= if 0 firstUndoIndex ! then
            currentUndoIndex @ st player copy-state
            currentUndoIndex @ lastUndoIndex !
         then
         0 undoFrameCounter !
      then
      KEY_LEFT_CONTROL down KEY_Z IsKeyPressed 1 and and if
         currentUndoIndex @ firstUndoIndex @ <> if
            -1 currentUndoIndex +!
            currentUndoIndex @ 0 < if MAX_UNDO_STATES 1- currentUndoIndex ! then
            currentUndoIndex @ st player state<> if
               player currentUndoIndex @ st copy-state
            then
         then
      then
      KEY_LEFT_CONTROL down KEY_Y IsKeyPressed 1 and and if
         currentUndoIndex @ lastUndoIndex @ <> if
            currentUndoIndex @ 1+ MAX_UNDO_STATES mod
            dup firstUndoIndex @ <> if
               currentUndoIndex !
               currentUndoIndex @ st player state<> if
                  player currentUndoIndex @ st copy-state
               then
            else drop then
         then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" [ARROWS] MOVE PLAYER - [SPACE] CHANGE PLAYER COLOR" 40 20 20 DARKGRAY DrawText
         lastUndoIndex @ firstUndoIndex @ > if
            currentUndoIndex @ firstUndoIndex @ ?do
               gridPosition v2x f>s i st @ GRID_CELL_SIZE * +
               gridPosition v2y f>s i st CELL+ @ GRID_CELL_SIZE * +
               GRID_CELL_SIZE dup LIGHTGRAY DrawRectangle
            loop
         else firstUndoIndex @ lastUndoIndex @ > if
            currentUndoIndex @ MAX_UNDO_STATES < currentUndoIndex @ lastUndoIndex @ > and if
               currentUndoIndex @ firstUndoIndex @ ?do
                  gridPosition v2x f>s i st @ GRID_CELL_SIZE * +
                  gridPosition v2y f>s i st CELL+ @ GRID_CELL_SIZE * +
                  GRID_CELL_SIZE dup LIGHTGRAY DrawRectangle
               loop
            else
               MAX_UNDO_STATES firstUndoIndex @ ?do
                  gridPosition v2x f>s i st @ GRID_CELL_SIZE * +
                  gridPosition v2y f>s i st CELL+ @ GRID_CELL_SIZE * +
                  GRID_CELL_SIZE dup LIGHTGRAY DrawRectangle
               loop
               currentUndoIndex @ 0 ?do
                  gridPosition v2x f>s i st @ GRID_CELL_SIZE * +
                  gridPosition v2y f>s i st CELL+ @ GRID_CELL_SIZE * +
                  GRID_CELL_SIZE dup LIGHTGRAY DrawRectangle
               loop
            then
         then then
         MAX_GRID_CELLS_Y 1+ 0 ?do
            gridPosition v2x f>s
            gridPosition v2y f>s i GRID_CELL_SIZE * +
            gridPosition v2x f>s MAX_GRID_CELLS_X GRID_CELL_SIZE * +
            gridPosition v2y f>s i GRID_CELL_SIZE * +
            GRAY DrawLine
         loop
         MAX_GRID_CELLS_X 1+ 0 ?do
            gridPosition v2x f>s i GRID_CELL_SIZE * +
            gridPosition v2y f>s
            gridPosition v2x f>s i GRID_CELL_SIZE * +
            gridPosition v2y f>s MAX_GRID_CELLS_Y GRID_CELL_SIZE * +
            GRAY DrawLine
         loop
         gridPosition v2x f>s ply-x @ GRID_CELL_SIZE * +
         gridPosition v2y f>s ply-y @ GRID_CELL_SIZE * +
         GRID_CELL_SIZE 1+ dup ply-c @ DrawRectangle
         z" UNDO STATES:" undoInfoPos v2x f>s 85 -  undoInfoPos v2y f>s 9 +  10 DARKGRAY DrawText
         draw-undo
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
