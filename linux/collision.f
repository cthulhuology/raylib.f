
include raylib.f
/raylib

$ff808080 CONSTANT GRAY
$ff505050 CONSTANT DARKGRAY
$ff30ef00 CONSTANT GREEN
$ffffffff CONSTANT WHITE
$ff3030ef CONSTANT RED

: main
    800 CONSTANT screenWidth
    450 CONSTANT screenHeight

    screenWidth screenHeight z" raylib [models] example - box collisions" InitWindow

    \ Define the camera to look into our 3d world
    Camera: camera 
	    0.0e 10.0e 10.0e	:Camera.position 
	    0.0e  0.0e  0.0e	:Camera.target
	    0.0e  1.0e  0.0e 	:Camera.up
	    45.0e		:Camera.fovy
	    CAMERA_PERSPECTIVE  :Camera.projection

    0.0e 1.0e 2.0e Vector3: playerPosition 

    1.0e 2.0e 1.0e Vector3: playerSize

    GREEN Color: playerColor

    -4.0e 1.0e 0.0e Vector3: enemyBoxPos
    2.0e 2.0e 2.0e Vector3: enemyBoxSize
    4.0e 0.0e 0.0e Vector3: enemySpherePos
    1.5e float: enemySphereSize

    0 value collision

    60 SetTargetFPS

    begin

        \ Move player
        KEY_RIGHT IsKeyDown if playerPosition .x  0.2e f+ playerPosition .x! then
        KEY_LEFT IsKeyDown  if playerPosition .x -0.2e f+ playerPosition .x! then
        KEY_DOWN IsKeyDown  if playerPosition .z  0.2e f+ playerPosition .z! then
        KEY_UP IsKeyDown    if playerPosition .z -0.2e f+ playerPosition .z! then

        0 to collision

        \ Check collisions player vs enemy-box
        if (CheckCollisionBoxes(
            (BoundingBox){(Vector3){ playerPosition.x - playerSize.x/2,
                                     playerPosition.y - playerSize.y/2,
                                     playerPosition.z - playerSize.z/2 },
                          (Vector3){ playerPosition.x + playerSize.x/2,
                                     playerPosition.y + playerSize.y/2,
                                     playerPosition.z + playerSize.z/2 }},
            (BoundingBox){(Vector3){ enemyBoxPos.x - enemyBoxSize.x/2,
                                     enemyBoxPos.y - enemyBoxSize.y/2,
                                     enemyBoxPos.z - enemyBoxSize.z/2 },
                          (Vector3){ enemyBoxPos.x + enemyBoxSize.x/2,
                                     enemyBoxPos.y + enemyBoxSize.y/2,
                                     enemyBoxPos.z + enemyBoxSize.z/2 }})) collision = true;

        // Check collisions player vs enemy-sphere
        if (CheckCollisionBoxSphere(
            (BoundingBox){(Vector3){ playerPosition.x - playerSize.x/2,
                                     playerPosition.y - playerSize.y/2,
                                     playerPosition.z - playerSize.z/2 },
                          (Vector3){ playerPosition.x + playerSize.x/2,
                                     playerPosition.y + playerSize.y/2,
                                     playerPosition.z + playerSize.z/2 }},
            enemySpherePos, enemySphereSize)) collision = true;

        if (collision) playerColor = RED;
        else playerColor = GREEN;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(RAYWHITE);

            camera BeginMode3D

                // Draw enemy-box
		enemyBoxPos enemyBoxSize .x enemyBoxSize .y enemyBoxSize .z GRAY DrawCube
		enemyBoxPos enemyBoxSize .x enemyBoxSize .y enemyBoxSize .z DARKGRAY);
                DrawCubeWires

                // Draw enemy-sphere
		enemySpherePo, enemySphereSize $ff828282 DrawSphere
		enemySpherePos enemySphereSize 16 16 $ff505050 DrawSphereWires \ DARKGRAY

                // Draw player
		playerPosition playerSize playerColor DrawCubeV

                10 1.0e DrawGrid \ draw grid

            EndMode3D

            z" Move player with arrow keys to collide" 220 40 20 $ff828282 DrawText \ GRAY

            10 10 DrawFPS

        EndDrawing
    
    WindowShouldClose until
    CloseWindow ;
