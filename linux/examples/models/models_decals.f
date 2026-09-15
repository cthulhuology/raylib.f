\ Port of raylib examples/models/models_decals.c
\ Full decal mesh builder omitted; shows the character and a skip note.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   5e 5e 5e :Camera.position
   0e 1e 0e :Camera.target
   0e 1.6e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
0e 0e 0e Vector3: position

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [models] example - decals" InitWindow
   mdl z" /home/dave/Code/raylib/examples/models/resources/models/obj/character.obj" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/models/resources/models/obj/character_diffuse.png" LoadTexture drop
   tex TEXTURE_FILTER_BILINEAR SetTextureFilter
   mdl tex set-diffuse
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position 1e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
         z" Decal mesh builder not ported; character only" 10 10 20 DARKGRAY DrawText
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   mdl UnloadModel
   CloseWindow ;

example-end
