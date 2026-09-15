\ Port of raylib examples/models/models_loading.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   50e 50e 50e :Camera.position
   0e  10e  0e :Camera.target
   0e   1e  0e :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
0e 0e 0e Vector3: position
CREATE bounds 32 ALLOT
CREATE dropped 32 ALLOT
CREATE ray 32 ALLOT
CREATE hit 32 ALLOT
VARIABLE selected

: model-ok ( z -- f )
   dup z" .obj" IsFileExtension
   over z" .gltf" IsFileExtension or
   over z" .glb" IsFileExtension or
   over z" .vox" IsFileExtension or
   over z" .iqm" IsFileExtension or
   swap z" .m3d" IsFileExtension or ;

: dropped-path ( -- z ) dropped 8 + @ @ ;

: example
   0 selected !
   screenWidth screenHeight z" raylib [models] example - loading" InitWindow
   mdl z" /home/dave/Code/raylib/examples/models/resources/models/obj/castle.obj" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/models/resources/models/obj/castle_diffuse.png" LoadTexture drop
   mdl tex set-diffuse
   bounds mdl 0 mesh[] GetMeshBoundingBox drop
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FIRST_PERSON UpdateCamera
      IsFileDropped if
         dropped LoadDroppedFiles drop
         dropped 4 + @ 1 = if
            dropped-path model-ok if
               mdl UnloadModel
               mdl dropped-path LoadModel drop
               mdl tex set-diffuse
               bounds mdl 0 mesh[] GetMeshBoundingBox drop
            else
               dropped-path z" .png" IsFileExtension if
                  tex UnloadTexture
                  tex dropped-path LoadTexture drop
                  mdl tex set-diffuse
               then
            then
         then
         dropped UnloadDroppedFiles
      then
      MOUSE_BUTTON_LEFT IsMouseButtonPressed if
         ray mouse@ camera GetScreenToWorldRay drop
         hit ray bounds GetRayCollisionBox drop
         hit @ if selected @ 0= selected ! else 0 selected ! then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position 1e WHITE DrawModel
            20 10e DrawGrid
            selected @ if bounds GREEN DrawBoundingBox then
         EndMode3D
         z" Drag & drop model to load mesh/texture." 10 GetScreenHeight 20 - 10 DARKGRAY DrawText
         selected @ if z" MODEL SELECTED" GetScreenWidth 110 - 10 10 GREEN DrawText then
         z" (c) Castle 3D model by Alberto Cano" screenWidth 200 - screenHeight 20 - 10 GRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
