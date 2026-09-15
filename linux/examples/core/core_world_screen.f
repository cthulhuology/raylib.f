\ Port of raylib examples/core/core_world_screen.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   10.0e 10.0e 10.0e :Camera.position
    0.0e  0.0e  0.0e :Camera.target
    0.0e  1.0e  0.0e :Camera.up
   45.0e             :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

0.0e 0.0e 0.0e Vector3: cubePosition
CREATE cubeScreenPosition 8 ALLOT
CREATE top 12 ALLOT

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: example
   0e 0e cubeScreenPosition Vector2!
   screenWidth screenHeight z" raylib [core] example - world screen" InitWindow
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_THIRD_PERSON UpdateCamera
      cubePosition .x  cubePosition .y 2.5e f+  cubePosition .z  top Vector3!
      cubeScreenPosition top camera GetWorldToScreen drop
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            cubePosition 2e 2e 2e RED DrawCube
            cubePosition 2e 2e 2e MAROON DrawCubeWires
            10 1e DrawGrid
         EndMode3D
         z" Enemy: 100/100"
         dup 20 MeasureText 2/  cubeScreenPosition v2x f>s swap -
         cubeScreenPosition v2y f>s
         20 BLACK DrawText
         z" Cube position in screen space coordinates: [" 10 10 20 LIME DrawText
         cubeScreenPosition v2x f>s n>z 430 10 20 LIME DrawText
         z" Text 2d should be always on top of the cube" 10 40 20 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
