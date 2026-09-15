\ Port of raylib examples/models/models_rlgl_solar_system.c
\ rlgl matrix stack not bound; spheres are placed with trig instead.

800 CONSTANT screenWidth
450 CONSTANT screenHeight
4e  fconstant sunRadius
0.6e fconstant earthRadius
8e  fconstant earthOrbitRadius
0.16e fconstant moonRadius
1.5e fconstant moonOrbitRadius

Camera: camera
   16e 16e 16e :Camera.position
   0e  0e  0e  :Camera.target
   0e  1e  0e  :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE earthRot 4 ALLOT
CREATE earthOrbit 4 ALLOT
CREATE moonRot 4 ALLOT
CREATE moonOrbit 4 ALLOT
0.2e fconstant rotationSpeed
0e 0e 0e Vector3: sunPos
CREATE earthPos 16 ALLOT
CREATE moonPos 16 ALLOT

: example
   0e earthRot sf!  0e earthOrbit sf!  0e moonRot sf!  0e moonOrbit sf!
   screenWidth screenHeight z" raylib [models] example - rlgl solar system" InitWindow
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      earthRot sf@ 5e rotationSpeed f* f+ earthRot sf!
      earthOrbit sf@ 365e 360e f/ 5e f* rotationSpeed f* rotationSpeed f* f+ earthOrbit sf!
      moonRot sf@ 2e rotationSpeed f* f+ moonRot sf!
      moonOrbit sf@ 8e rotationSpeed f* f+ moonOrbit sf!
      earthOrbit sf@ deg>rad fdup fcos earthOrbitRadius f*  0e
         fswap fsin earthOrbitRadius f* earthPos Vector3!
      moonOrbit sf@ deg>rad fdup fcos moonOrbitRadius f* earthPos .x f+
         0e
         fswap fsin moonOrbitRadius f* earthPos .z f+ moonPos Vector3!
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            sunPos sunRadius GOLD DrawSphere
            sunPos sunRadius 16 16 DARKBROWN DrawSphereWires
            earthPos earthRadius BLUE DrawSphere
            moonPos moonRadius LIGHTGRAY DrawSphere
            20 1e DrawGrid
         EndMode3D
         z" SOLAR SYSTEM: simplified (no rlgl matrix stack)" 10 10 20 DARKGRAY DrawText
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
