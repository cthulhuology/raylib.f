\ Port of raylib examples/models/models_mesh_picking.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   20e 20e 20e :Camera.position
   0e  8e  0e  :Camera.target
   0e  1.6e 0e :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE tower 128 ALLOT
CREATE tex 32 ALLOT
0e 0e 0e Vector3: towerPos
CREATE towerBBox 32 ALLOT
-50e 0e -50e Vector3: g0
-50e 0e  50e Vector3: g1
 50e 0e  50e Vector3: g2
 50e 0e -50e Vector3: g3
-25e 0.5e 0e Vector3: ta
-4e 2.5e 1e Vector3: tb
-8e 6.5e 0e Vector3: tc
-30e 5e 5e Vector3: sp
4e fconstant sr
CREATE ray 32 ALLOT
CREATE collision 32 ALLOT
CREATE groundHit 32 ALLOT
CREATE triHit 32 ALLOT
CREATE sphereHit 32 ALLOT
CREATE boxHit 32 ALLOT
CREATE meshHit 32 ALLOT
VARIABLE cursorColor
VARIABLE hitName

: closer? ( hit -- f )
   dup ray_hit l@ 0= if drop 0 exit then
   collision ray_hit l@ 0= if drop 1 exit then
   dup ray_distance sf@ collision ray_distance sf@ f< nip ;

: take-hit ( hit z color -- )
   cursorColor !  hitName !  collision 32 move ;

: example
   WHITE cursorColor !
   z" None" hitName !
   screenWidth screenHeight z" raylib [models] example - mesh picking" InitWindow
   tower z" /home/dave/Code/raylib/examples/models/resources/models/obj/turret.obj" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/models/resources/models/obj/turret_diffuse.png" LoadTexture drop
   tower tex set-diffuse
   towerBBox tower 0 mesh[] GetMeshBoundingBox drop
   60 SetTargetFPS
   begin
      IsCursorHidden if camera CAMERA_FIRST_PERSON UpdateCamera then
      MOUSE_BUTTON_RIGHT IsMouseButtonPressed if
         IsCursorHidden if EnableCursor else DisableCursor then
      then
      0 collision ray_hit l!
      1e30 collision ray_distance sf!
      WHITE cursorColor !
      z" None" hitName !
      ray mouse@ camera GetScreenToWorldRay drop
      groundHit ray g0 g1 g2 g3 GetRayCollisionQuad drop
      groundHit closer? if groundHit z" Ground" GREEN take-hit then
      triHit ray ta tb tc GetRayCollisionTriangle drop
      triHit closer? if triHit z" Triangle" PURPLE take-hit then
      sphereHit ray sp sr GetRayCollisionSphere drop
      sphereHit closer? if sphereHit z" Sphere" ORANGE take-hit then
      boxHit ray towerBBox GetRayCollisionBox drop
      boxHit closer? if
         boxHit z" Box" ORANGE take-hit
         tower mdl.meshCount 0 ?do
            meshHit ray  tower i mesh[]  tower  GetRayCollisionMesh drop
            meshHit ray_hit l@ if
               collision ray_hit l@ 0=  meshHit ray_distance sf@ collision ray_distance sf@ f> or if
                  meshHit z" Mesh" ORANGE take-hit
               then
            then
         loop
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            tower towerPos 1e WHITE DrawModel
            towerBBox GREEN DrawBoundingBox
            g0 g1 g2 DARKGRAY DrawTriangle3D
            g0 g2 g3 DARKGRAY DrawTriangle3D
            ta tb tc cursorColor @ DrawTriangle3D
            sp sr 16 16 cursorColor @ DrawSphereWires
            collision ray_hit l@ if collision ray_point 0.3e 0.3e 0.3e cursorColor @ DrawCube then
            10 1e DrawGrid
         EndMode3D
         z" Right click to toggle camera" 10 10 10 GRAY DrawText
         hitName @ 10 30 10 BLACK DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   tower UnloadModel
   CloseWindow ;

example-end
