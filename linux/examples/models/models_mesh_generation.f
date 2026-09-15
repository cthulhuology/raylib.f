\ Port of raylib examples/models/models_mesh_generation.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
9 CONSTANT NUM_MODELS

Camera: camera
   5e 5e 5e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE img 32 ALLOT
CREATE tex 32 ALLOT
CREATE models 9 128 * ALLOT
CREATE meshes 9 128 * ALLOT
0e 0e 0e Vector3: position
VARIABLE currentModel

: mdl-i ( i -- a ) 128 * models + ;
: mesh-i ( i -- a ) 128 * meshes + ;

: model-name ( i -- z )
   dup 0 = if drop z" PLANE" else
   dup 1 = if drop z" CUBE" else
   dup 2 = if drop z" SPHERE" else
   dup 3 = if drop z" HEMISPHERE" else
   dup 4 = if drop z" CYLINDER" else
   dup 5 = if drop z" TORUS" else
   dup 6 = if drop z" KNOT" else
   dup 7 = if drop z" POLY" else
              drop z" Custom (cone)" then then then then then then then then ;

: example
   0 currentModel !
   screenWidth screenHeight z" raylib [models] example - mesh generation" InitWindow
   img 2 2 1 1 RED GREEN GenImageChecked drop
   tex img LoadTextureFromImage drop
   img UnloadImage
   0 mesh-i 2e 2e 4 3 GenMeshPlane drop
   1 mesh-i 2e 1e 2e GenMeshCube drop
   2 mesh-i 2e 32 32 GenMeshSphere drop
   3 mesh-i 2e 16 16 GenMeshHemiSphere drop
   4 mesh-i 1e 2e 16 GenMeshCylinder drop
   5 mesh-i 0.25e 4e 16 32 GenMeshTorus drop
   6 mesh-i 1e 2e 16 128 GenMeshKnot drop
   7 mesh-i 5 2e GenMeshPoly drop
   8 mesh-i 1e 2e 16 GenMeshCone drop
   NUM_MODELS 0 do
      i mdl-i  i mesh-i LoadModelFromMesh drop
      i mdl-i tex set-diffuse
   loop
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      MOUSE_BUTTON_LEFT IsMouseButtonPressed if
         currentModel @ 1+ NUM_MODELS mod currentModel ! then
      KEY_RIGHT IsKeyPressed if currentModel @ 1+ NUM_MODELS mod currentModel ! then
      KEY_LEFT IsKeyPressed if currentModel @ NUM_MODELS + 1- NUM_MODELS mod currentModel ! then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            currentModel @ mdl-i position 1e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
         30 400 310 30 SKYBLUE 0.5e Fade DrawRectangle
         30 400 310 30 DARKBLUE 0.5e Fade DrawRectangleLines
         z" MOUSE LEFT BUTTON to CYCLE PROCEDURAL MODELS" 40 410 10 BLUE DrawText
         currentModel @ model-name 680 10 20 DARKBLUE DrawText
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   NUM_MODELS 0 do i mdl-i UnloadModel loop
   CloseWindow ;

example-end
