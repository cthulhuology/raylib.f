\ Port of raylib examples/models/models_box_collisions.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 10e 10e :Camera.position
   0e  0e  0e :Camera.target
   0e  1e  0e :Camera.up
   45e        :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

0e 1e 2e Vector3: playerPosition
1e 2e 1e Vector3: playerSize
VARIABLE playerColor
-4e 1e 0e Vector3: enemyBoxPos
2e 2e 2e Vector3: enemyBoxSize
4e 0e 0e Vector3: enemySpherePos
1.5e fconstant enemySphereSize
VARIABLE collision
0e 0e 0e  0e 0e 0e BoundingBox: playerBounds
0e 0e 0e  0e 0e 0e BoundingBox: enemyBounds

: aabb! ( pos size box -- )
   >r
   over .x  dup .x f2/ f-
   over .y  dup .y f2/ f-
   over .z  dup .z f2/ f-
   over .x  dup .x f2/ f+
   over .y  dup .y f2/ f+
   over .z  dup .z f2/ f+
   2drop r> BoundingBox! ;

: example
   GREEN playerColor !
   0 collision !
   screenWidth screenHeight z" raylib [models] example - box collisions" InitWindow
   60 SetTargetFPS
   begin
      KEY_RIGHT down if 0.2e else KEY_LEFT down if -0.2e else 0e then then
      0e
      KEY_DOWN down if 0.2e else KEY_UP down if -0.2e else 0e then then
      playerPosition Vector3+
      0 collision !
      playerPosition playerSize playerBounds aabb!
      enemyBoxPos enemyBoxSize enemyBounds aabb!
      playerBounds enemyBounds CheckCollisionBoxes if 1 collision ! then
      playerBounds enemySpherePos enemySphereSize CheckCollisionBoxSphere if 1 collision ! then
      collision @ if RED else GREEN then playerColor !
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            enemyBoxPos enemyBoxSize .x enemyBoxSize .y enemyBoxSize .z GRAY DrawCube
            enemyBoxPos enemyBoxSize .x enemyBoxSize .y enemyBoxSize .z DARKGRAY DrawCubeWires
            enemySpherePos enemySphereSize GRAY DrawSphere
            enemySpherePos enemySphereSize 16 16 DARKGRAY DrawSphereWires
            playerPosition playerSize playerColor @ DrawCubeV
            10 1e DrawGrid
         EndMode3D
         z" Move player with arrow keys to collide" 220 40 20 GRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
