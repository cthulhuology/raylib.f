\ Port of raylib examples/models/models_waving_cubes.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
15 CONSTANT numBlocks

Camera: camera
   30e 20e 30e :Camera.position
   0e  0e  0e  :Camera.target
   0e  1e  0e  :Camera.up
   70e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE cubePos 16 ALLOT
CREATE scale 4 ALLOT
VARIABLE bx
VARIABLE by
VARIABLE bz

: draw-one ( -- )
   bx @ by @ bz @ + + s>f 30e f/             \ F: blockScale
   fdup 20e f* GetTime 4e f* f+ fsin          \ F: blockScale scatter
   bx @ numBlocks 2/ - s>f scale sf@ 3e f* f* fover f+
   by @ numBlocks 2/ - s>f scale sf@ 2e f* f* fover f+
   bz @ numBlocks 2/ - s>f scale sf@ 3e f* f* fover f+
   cubePos Vector3!                           \ F: blockScale scatter
   fswap 2.4e scale sf@ f- f*                 \ F: scatter cubeSize
   fswap fdrop                                \ F: cubeSize
   cubePos
   bx @ by @ bz @ + + 18 * 360 mod s>f 0.75e 0.9e ColorFromHSV
   fdup fdup DrawCube ;

: draw-cubes
   0 bx !
   begin bx @ numBlocks < while
      0 by !
      begin by @ numBlocks < while
         0 bz !
         begin bz @ numBlocks < while
            draw-one
            1 bz +!
         repeat
         1 by +!
      repeat
      1 bx +!
   repeat ;

: example
   screenWidth screenHeight z" raylib [models] example - waving cubes" InitWindow
   60 SetTargetFPS
   begin
      GetTime fdup fsin 2e f+ 0.7e f* scale sf!
      0.3e f* fdup fcos 40e f* camera sf!
      fsin 40e f* camera 8 + sf!
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            10 5e DrawGrid
            draw-cubes
         EndMode3D
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
