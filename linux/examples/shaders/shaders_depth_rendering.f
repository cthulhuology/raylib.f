\ Port of raylib examples/shaders/shaders_depth_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   4e 1e 5e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

\ Custom render texture with depth texture (44 bytes: id + texture{20} + depth{20})
\ rt+0  = FBO id
\ rt+4  = color texture (id w h mipmaps format)
\ rt+24 = depth texture  (id w h mipmaps format)
CREATE rt 64 ALLOT

CREATE shd 32 ALLOT
CREATE cubemesh 128 ALLOT
CREATE floormesh 128 ALLOT
CREATE cube 128 ALLOT
CREATE floor 128 ALLOT

VARIABLE depthLoc
VARIABLE flipLoc
CREATE flipval 4 ALLOT

0e 0e 0e Vector3: cubepos
10e 0e 2e Vector3: floorpos

\ Build a custom RenderTexture with a real depth texture (not renderbuffer)
: LoadRenderTextureDepthTex ( w h -- )
   locals| h w |
   rlLoadFramebuffer rt l!
   rt l@ 0> if
      rt l@ rlEnableFramebuffer
      \ Color texture
      0 w h PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 1 rlLoadTexture  rt 4 + l!
      w rt 8 + l!   h rt 12 + l!   1 rt 16 + l!   PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 rt 20 + l!
      \ Depth texture
      w h 0 rlLoadTextureDepth  rt 24 + l!
      w rt 28 + l!  h rt 32 + l!  1 rt 36 + l!  19 rt 40 + l!
      \ Attach color and depth to FBO
      rt l@ rt 4 + l@  RL_ATTACHMENT_COLOR_CHANNEL0 RL_ATTACHMENT_TEXTURE2D 0 rlFramebufferAttach
      rt l@ rt 24 + l@ RL_ATTACHMENT_DEPTH          RL_ATTACHMENT_TEXTURE2D 0 rlFramebufferAttach
      rt l@ rlFramebufferComplete drop
      rlDisableFramebuffer
   then ;

: UnloadRenderTextureDepthTex ( -- )
   rt l@ 0> if
      rt 4 + l@ rlUnloadTexture
      rt 24 + l@ rlUnloadTexture
      rt l@ rlUnloadFramebuffer
   then ;

: example
   screenWidth screenHeight z" raylib [shaders] example - depth rendering" InitWindow

   screenWidth screenHeight LoadRenderTextureDepthTex

   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/depth_render.fs" LoadShader drop
   shd z" depthTexture" GetShaderLocation depthLoc !
   shd z" flipY" GetShaderLocation flipLoc !
   1 flipval l!
   shd flipLoc @ flipval SHADER_UNIFORM_INT SetShaderValue

   cubemesh 1e 1e 1e GenMeshCube drop
   cube cubemesh LoadModelFromMesh drop

   floormesh 20e 20e 1 1 GenMeshPlane drop
   floor floormesh LoadModelFromMesh drop

   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FREE UpdateCamera
      rt BeginTextureMode
         WHITE ClearBackground
         camera BeginMode3D
            cube cubepos 3e YELLOW DrawModel
            floor floorpos 2e RED DrawModel
         EndMode3D
      EndTextureMode
      BeginDrawing
         RAYWHITE ClearBackground
         shd BeginShaderMode
            shd depthLoc @ rt 24 + SetShaderValueTexture
            rt 24 + 0 0 WHITE DrawTexture
         EndShaderMode
         10 10 320 93 SKYBLUE 0.5e Fade DrawRectangle
         10 10 320 93 BLUE DrawRectangleLines
         z" Camera Controls:" 20 20 10 BLACK DrawText
         z" - WASD to move" 40 40 10 DARKGRAY DrawText
         z" - Mouse Wheel Pressed to Pan" 40 60 10 DARKGRAY DrawText
         z" - Z to zoom to (0, 0, 0)" 40 80 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until

   cube UnloadModel
   floor UnloadModel
   UnloadRenderTextureDepthTex
   shd UnloadShader
   CloseWindow ;

example-end
