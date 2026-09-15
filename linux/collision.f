empty
only forth also definitions
include raylib.f
/raylib

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE playerColor
VARIABLE collision

\ Camera looking into the 3d world
Camera: camera
    0.0e 10.0e 10.0e	:Camera.position
    0.0e  0.0e  0.0e	:Camera.target
    0.0e  1.0e  0.0e	:Camera.up
    45.0e		:Camera.fovy
    CAMERA_PERSPECTIVE  :Camera.proj

0.0e 1.0e 2.0e Vector3: playerPosition
1.0e 2.0e 1.0e Vector3: playerSize
GREEN playerColor !

-4.0e 1.0e 0.0e Vector3: enemyBoxPos
2.0e 2.0e 2.0e Vector3: enemyBoxSize

4.0e 0.0e 0.0e Vector3: enemySpherePos
1.5e float: enemySphereSize

0 collision !

0.e 0.e 0.e  0.e 0.e 0.e BoundingBox: playerBounds
0.e 0.e 0.e  0.e 0.e 0.e BoundingBox: enemyBounds

\ Axis-aligned box from a center Vector3 and a size Vector3.
: aabb! ( pos size box -- )
   >r
   over .x  dup .x f2/ f-
   over .y  dup .y f2/ f-
   over .z  dup .z f2/ f-
   over .x  dup .x f2/ f+
   over .y  dup .y f2/ f+
   over .z  dup .z f2/ f+
   2drop r> BoundingBox! ;

: move-player
   KEY_RIGHT down if  0.2e else
   KEY_LEFT  down if -0.2e else 0.e then then
   0.e
   KEY_DOWN  down if  0.2e else
   KEY_UP    down if -0.2e else 0.e then then
   playerPosition Vector3+ ;

: check-collisions
   0 collision !
   playerPosition playerSize playerBounds aabb!
   enemyBoxPos    enemyBoxSize  enemyBounds aabb!
   playerBounds enemyBounds CheckCollisionBoxes if
      1 collision ! then
   playerBounds enemySpherePos enemySphereSize CheckCollisionBoxSphere if
      1 collision ! then
   collision @ if RED else GREEN then playerColor ! ;

: drawPlayer
   playerPosition playerSize playerColor @ DrawCubeV ;

: drawEnemies
   enemyBoxPos enemyBoxSize .x enemyBoxSize .y enemyBoxSize .z GRAY DrawCube
   enemyBoxPos enemyBoxSize .x enemyBoxSize .y enemyBoxSize .z DARKGRAY DrawCubeWires
   enemySpherePos enemySphereSize GRAY DrawSphere
   enemySpherePos enemySphereSize 16 16 DARKGRAY DrawSphereWires ;

: drawField  10 1.0e DrawGrid ;

: scene
   BeginDrawing
      WHITE ClearBackground
      camera BeginMode3D
         drawEnemies
         drawPlayer
         drawField
      EndMode3D
      z" Move player with arrow keys to collide" 220 40 20 GRAY DrawText
      10 10 DrawFPS
   EndDrawing ;

: main
   screenWidth screenHeight z" collisions example" InitWindow
   60 SetTargetFPS
   begin
      move-player
      check-collisions
      scene
   WindowShouldClose until
   CloseWindow ;

' main 'main !
PROGRAM collision
bye
