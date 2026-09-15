\ Port of raylib examples/models/models_cubicmap_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   16e 14e 16e :Camera.position
   0e  0e  0e  :Camera.target
   0e  1e  0e  :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE img  32 ALLOT
CREATE cubicmap 32 ALLOT
CREATE mesh 128 ALLOT
CREATE mdl  128 ALLOT
CREATE tex  32 ALLOT
1e 1e 1e Vector3: cubeSize
-16e 0e -8e Vector3: mapPosition
CREATE pos2 8 ALLOT
VARIABLE pause

: example
   0 pause !
   screenWidth screenHeight z" raylib [models] example - cubicmap rendering" InitWindow
   img z" /home/dave/Code/raylib/examples/models/resources/cubicmap.png" LoadImage drop
   cubicmap img LoadTextureFromImage drop
   mesh img cubeSize GenMeshCubicmap drop
   mdl mesh LoadModelFromMesh drop
   tex z" /home/dave/Code/raylib/examples/models/resources/cubicmap_atlas.png" LoadTexture drop
   mdl tex set-diffuse
   img UnloadImage
   60 SetTargetFPS
   begin
      KEY_P IsKeyPressed if pause @ 0= pause ! then
      pause @ 0= if camera CAMERA_ORBITAL UpdateCamera then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl mapPosition 1e WHITE DrawModel
         EndMode3D
         screenWidth s>f cubicmap tex.w s>f 4e f* f- 20e f-  20e pos2 Vector2!
         cubicmap pos2 0e 4e WHITE DrawTextureEx
         screenWidth cubicmap tex.w 4 * - 20 -  20
            cubicmap tex.w 4 *  cubicmap tex.h 4 *  GREEN DrawRectangleLines
         z" cubicmap image used to" 658 90 10 GRAY DrawText
         z" generate map 3d model" 658 104 10 GRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   cubicmap UnloadTexture
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
