
include raylib.f
/raylib

$ff808080 CONSTANT GRAY
$ff505050 CONSTANT DARKGRAY
$ff30ef00 CONSTANT GREEN
$ffffffff CONSTANT WHITE
$ff3030ef CONSTANT RED

800 CONSTANT screenWidth
450 CONSTANT screenHeight

\ Define the camera to look into our 3d world
Camera: camera 
    0.0e 10.0e 10.0e	:Camera.position 
    0.0e  0.0e  0.0e	:Camera.target
    0.0e  1.0e  0.0e 	:Camera.up
    45.0e		:Camera.fovy
    CAMERA_PERSPECTIVE  :Camera.proj

\ player on center
0.0e 1.0e 2.0e Vector3: playerPosition 
1.0e 2.0e 1.0e Vector3: playerSize

\ Player color
GREEN value playerColor

\ enemy Box
-4.0e 1.0e 0.0e Vector3: enemyBoxPos
2.0e 2.0e 2.0e Vector3: enemyBoxSize

\ enemy Sphere
4.0e 0.0e 0.0e Vector3: enemySpherePos
1.5e float: enemySphereSize

0 value collision


\ structures for collision detection calls
\ min xyz    \ max xyz
0.e 0.e 0.e  0.e 0.e 0.e BoundingBox: playerBounds
0.e 0.e 0.e  0.e 0.e 0.e BoundingBox: enemyBounds

: move-player
	KEY_RIGHT down if  0.2e else
        KEY_LEFT  down if -0.2e else 
			    0.e then then 	\ delta x
	                    0.e 	  	\ delta y
        KEY_DOWN  down if  0.2e else
        KEY_UP    down if -0.2e else
			    0.e then then 	\ delta z
	playerPosition Vector3+ 
	
	playerPosition .x f. space playerPosition .y f. space playerPosition .z f. cr
	;

: check-collisions
        0 to collision
	playerPosition .x playerSize .x 2/ -
	playerPosition .y playerSize .y 2/ -
	playerPosition .z playerSize .z 2/ -
	playerPosition .x playerSize .x 2/ + 
	playerPosition .y playerSize .y 2/ +
	playerPosition .z playerSize .z 2/ +
	playerBounds BoundingBox!
	
	enemyBoxPos .x enemyBoxSize .x 2/ -
	enemyBoxPos .y enemyBoxSize .y 2/ -
	enemyBoxPos .z enemyBoxSize .z 2/ - 
	enemyBoxPos .x enemyBoxSize .x 2/ + 
	enemyBoxPos .y enemyBoxSize .y 2/ +
	enemyBoxPos .z enemyBoxSize .z 2/ +
	enemyBounds BoundingBox!

	playerBounds enemyBounds CheckCollisionBoxes if 
		1 to collision then

        \ Check collisions player vs enemy-sphere
	playerBounds enemySpherePos enemySphereSize CheckCollisionBoxSphere if
		1 to collision then

        collision if RED else GREEN then to playerColor ;
        

: drawPlayer playerPosition playerSize playerColor DrawCubeV ;
: drawField 10 1.0e DrawGrid ;
: main

    \ initialize the game window
    screenWidth screenHeight z" collisions example" InitWindow
    60 SetTargetFPS

   begin

        \ Move player 
	move-player
        
        \ Check collisions player vs enemy-box
\	check-collisions

	\ Draw
        BeginDrawing

            WHITE ClearBackground

            camera BeginMode3D

                \ Draw enemy-box
\		enemyBoxPos enemyBoxSize .x enemyBoxSize .y enemyBoxSize .z GRAY DrawCube
\		enemyBoxPos enemyBoxSize .x enemyBoxSize .y enemyBoxSize .z DARKGRAY DrawCubeWires
\
\                \ Draw enemy-sphere
\		enemySpherePos enemySphereSize GRAY DrawSphere
\		enemySpherePos enemySphereSize 16 16 DARKGRAY DrawSphereWires
\
	      \ drawPlayer
		drawField

            EndMode3D

            z" Move player with arrow keys to collide" 220 40 20 GRAY DrawText

            10 10 DrawFPS

        EndDrawing
    
    WindowShouldClose until
    CloseWindow ;
