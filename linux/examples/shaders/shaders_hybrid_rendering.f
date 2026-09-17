\ Port of raylib examples/shaders/shaders_hybrid_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0.5e 1.0e 1.5e :Camera.position
   0.0e 0.5e 0.0e :Camera.target
   0.0e 1.0e 0.0e :Camera.up
   45e             :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

\ Shader buffers (Shader struct = uint id + ptr locs = 16 bytes)
CREATE shdrRaymarch 32 ALLOT
CREATE shdrRaster   32 ALLOT

\ Custom render texture with writable depth texture
\ RenderTexture2D layout: id(4) | texture Texture2D(20) | depth Texture2D(20) = 44 bytes
CREATE target 64 ALLOT

\ Shader uniform locations
VARIABLE camPosLoc
VARIABLE camDirLoc
VARIABLE screenCenterLoc

\ Scratch buffers for Vector3 math and uniform passing
CREATE camDir 16 ALLOT
CREATE screenCenterBuf 8 ALLOT
CREATE recFull 16 ALLOT
CREATE pos2d 8 ALLOT

FVARIABLE camDist

\ Load custom render texture with a writable (texture) depth buffer
: load-depth-rt ( -- )
   rlLoadFramebuffer target l!
   target l@ 0> if
      target l@ rlEnableFramebuffer
      \ Color texture
      0 screenWidth screenHeight PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 1 rlLoadTexture
      target 4 + l!                           \ target.texture.id
      screenWidth  target 8 + l!              \ target.texture.width
      screenHeight target 12 + l!             \ target.texture.height
      PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 target 16 + l!  \ target.texture.format
      1 target 20 + l!                        \ target.texture.mipmaps
      \ Depth texture
      screenWidth screenHeight 0 rlLoadTextureDepth
      target 24 + l!                          \ target.depth.id
      screenWidth  target 28 + l!             \ target.depth.width
      screenHeight target 32 + l!             \ target.depth.height
      19 target 36 + l!                       \ target.depth.format (DEPTH_COMPONENT_24BIT)
      1 target 40 + l!                        \ target.depth.mipmaps
      \ Attach color and depth textures to FBO
      target l@ target 4 + l@
      RL_ATTACHMENT_COLOR_CHANNEL0 RL_ATTACHMENT_TEXTURE2D 0
      rlFramebufferAttach
      target l@ target 24 + l@
      RL_ATTACHMENT_DEPTH RL_ATTACHMENT_TEXTURE2D 0
      rlFramebufferAttach
      target l@ rlFramebufferComplete drop
      rlDisableFramebuffer
   then ;

\ Unload custom render texture
: unload-depth-rt ( -- )
   target l@ 0> if
      target 4 + l@ rlUnloadTexture
      target 24 + l@ rlUnloadTexture
      target l@ rlUnloadFramebuffer
   then ;

: example
   screenWidth screenHeight z" raylib [shaders] example - hybrid rendering" InitWindow

   shdrRaymarch 0
   z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/hybrid_raymarch.fs"
   LoadShader drop

   shdrRaster 0
   z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/hybrid_raster.fs"
   LoadShader drop

   \ Get shader uniform locations
   shdrRaymarch z" camPos"       GetShaderLocation camPosLoc !
   shdrRaymarch z" camDir"       GetShaderLocation camDirLoc !
   shdrRaymarch z" screenCenter" GetShaderLocation screenCenterLoc !

   \ Pass screen center to shader (used to compute ray direction)
   screenWidth s>f 2e f/  screenHeight s>f 2e f/  screenCenterBuf Vector2!
   shdrRaymarch screenCenterLoc @ screenCenterBuf SHADER_UNIFORM_VEC2 SetShaderValue

   \ Create custom render texture with writable depth
   load-depth-rt

   \ Pre-compute camera FOV distance: 1 / tan(fovy * 0.5 * DEG2RAD)
   45e 0.5e f* RPI f* 180e f/   \ angle = pi/8
   fdup fsin fswap fcos f/ 1e fswap f/
   camDist f!

   60 SetTargetFPS

   begin
      camera CAMERA_ORBITAL UpdateCamera

      \ Update camPos uniform with current camera position
      shdrRaymarch camPosLoc @ camera SHADER_UNIFORM_VEC3 SetShaderValue

      \ camDir = normalize(target - position) * camDist
      v3a camera Camera.target camera Camera.position Vector3Subtract
      v3b v3a Vector3Normalize drop
      camDist f@ v3b camDir Vector3Scale drop
      shdrRaymarch camDirLoc @ camDir SHADER_UNIFORM_VEC3 SetShaderValue

      \ Draw rasterized + raymarch scene to custom FBO
      target BeginTextureMode
         WHITE ClearBackground
         rlEnableDepthTest
         shdrRaymarch BeginShaderMode
            0e 0e screenWidth s>f screenHeight s>f recFull Rectangle!
            recFull WHITE DrawRectangleRec
         EndShaderMode
         camera BeginMode3D
            shdrRaster BeginShaderMode
               0e 0.5e 1e v3a Vector3!   1e 1e 1e v3b Vector3!
               v3a v3b RED DrawCubeWiresV
               0e 0.5e 1e v3a Vector3!   1e 1e 1e v3b Vector3!
               v3a v3b PURPLE DrawCubeV
               0e 0.5e -1e v3a Vector3!  1e 1e 1e v3b Vector3!
               v3a v3b DARKGREEN DrawCubeWiresV
               0e 0.5e -1e v3a Vector3!  1e 1e 1e v3b Vector3!
               v3a v3b YELLOW DrawCubeV
               10 1e DrawGrid
            EndShaderMode
         EndMode3D
      EndTextureMode

      \ Blit to screen (flip Y: negative height)
      BeginDrawing
         RAYWHITE ClearBackground
         0e 0e screenWidth s>f screenHeight s>f fnegate recFull Rectangle!
         0e 0e pos2d Vector2!
         target 4 + recFull pos2d WHITE DrawTextureRec
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until

   unload-depth-rt
   shdrRaymarch UnloadShader
   shdrRaster UnloadShader
   CloseWindow ;

example-end
