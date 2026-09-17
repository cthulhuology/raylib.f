\ Port of raylib examples/shaders/shaders_depth_writing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   4e 4e 4e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

\ Custom render texture with a depth texture attachment
\ rt+0  = FBO id (4 bytes)
\ rt+4  = color texture Texture2D (20 bytes, id/w/h/mips/fmt)
\ rt+24 = depth texture Texture2D (20 bytes)
CREATE rt 64 ALLOT

CREATE shd 32 ALLOT
CREATE cubemesh 128 ALLOT
CREATE floormesh 128 ALLOT
CREATE cube 128 ALLOT
CREATE floor 128 ALLOT

0e 0e 0e Vector3: cubepos
10e 0e 2e Vector3: floorpos

\ Build a RenderTexture with a real depth texture (not renderbuffer)
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
      \ Attach to FBO
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
   screenWidth screenHeight z" raylib [shaders] example - depth writing" InitWindow

   screenWidth screenHeight LoadRenderTextureDepthTex

   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/depth_write.fs"
   LoadShader drop

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
            rt 4 + 0 0 WHITE DrawTexture
         EndShaderMode
         10 10 20 DARKGRAY DrawText z" Depth write to FBO color texture"
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until

   cube UnloadModel
   floor UnloadModel
   UnloadRenderTextureDepthTex
   shd UnloadShader
   CloseWindow ;

example-end
