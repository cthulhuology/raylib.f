\ Port of raylib examples/shaders/shaders_custom_uniform.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   3e 3e 3e :Camera.position
   0e 1.5e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
CREATE shd 32 ALLOT
CREATE target 64 ALLOT
0e 0e 0e Vector3: position
CREATE swirl 8 ALLOT
VARIABLE swirlLoc

: example
   screenWidth screenHeight z" raylib [shaders] example - custom uniform" InitWindow
   mdl z" /home/dave/Code/raylib/examples/shaders/resources/models/barracks.obj" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/shaders/resources/models/barracks_diffuse.png" LoadTexture drop
   mdl tex set-diffuse
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/swirl.fs" LoadShader drop
   shd z" center" GetShaderLocation swirlLoc !
   target screenWidth screenHeight LoadRenderTexture drop
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      mouse@ v2x  screenHeight s>f mouse@ v2y f-  swirl Vector2!
      shd swirlLoc @ swirl SHADER_UNIFORM_VEC2 SetShaderValue
      target BeginTextureMode
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position 0.5e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
         z" TEXT DRAWN IN RENDER TEXTURE" 200 10 30 RED DrawText
      EndTextureMode
      BeginDrawing
         RAYWHITE ClearBackground
         shd BeginShaderMode
            0e 0e target rtex.w s>f target rtex.h s>f fnegate reca Rectangle!
            0e 0e v2a Vector2!
            target rtex reca v2a WHITE DrawTextureRec
         EndShaderMode
         z" (c) Barracks 3D model by Alberto Cano" screenWidth 220 - screenHeight 20 - 10 GRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   tex UnloadTexture
   mdl UnloadModel
   target UnloadRenderTexture
   CloseWindow ;

example-end
