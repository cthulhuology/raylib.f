\ Port of raylib examples/shaders/shaders_shadowmap_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
1024 CONSTANT SHADOWMAP_RESOLUTION
10   CONSTANT texSlot           \ shadow depth texture active slot

\ player camera
Camera: camera
   10e 10e 10e :Camera.position
   0e  0e  0e  :Camera.target
   0e  1e  0e  :Camera.up
   45e          :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

\ light camera (orthographic; position filled each frame from lightDir)
Camera: lightCam
   0e 0e 0e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   20e       :Camera.fovy
   CAMERA_ORTHOGRAPHIC :Camera.proj

\ shader, mesh, and model buffers
CREATE shd      16 ALLOT   \ Shader (id u64 + locs ptr u64 = 16 bytes)
CREATE cubeMesh 128 ALLOT  \ Mesh for generated cube (120 bytes)
CREATE cubeMdl  128 ALLOT  \ Model for cube (120 bytes)
CREATE robotMdl 128 ALLOT  \ Model for robot (120 bytes)

\ shadow-map render texture  (RenderTexture2D = 44 bytes, padded to 64)
\ layout: fbo-id[4] | texture.id[4] .w[4] .h[4] .mm[4] .fmt[4] | depth.id[4] .w[4] .h[4] .mm[4] .fmt[4]
\ offsets:     0          4        8     12    16    20         24       28    32    36    40
CREATE sm 64 ALLOT

\ light direction (mutable unit Vector3)
CREATE lightDir 12 ALLOT

\ matrix buffers for shadow pass
CREATE lightView     64 ALLOT
CREATE lightProj     64 ALLOT
CREATE lightViewProj 64 ALLOT

\ reusable scratch buffers
CREATE fvec3a 12 ALLOT
CREATE fvec4a 16 ALLOT
CREATE ivalb   4 ALLOT

\ shader uniform locations (int)
VARIABLE lightDirLoc
VARIABLE lightColLoc
VARIABLE ambientLoc
VARIABLE lightVPLoc
VARIABLE shadowMapLoc
VARIABLE shadowMapResLoc

\ animation state
VARIABLE animsCount
VARIABLE anims
VARIABLE frameCounter

\ sm buffer field accessors
: sm.fbo-id    ( -- a ) sm ;
: sm.depth-id  ( -- a ) sm 24 + ;
: sm.depth-w   ( -- a ) sm 28 + ;
: sm.depth-h   ( -- a ) sm 32 + ;
: sm.depth-mm  ( -- a ) sm 36 + ;
: sm.depth-fmt ( -- a ) sm 40 + ;

\ Copy the shader into every material of a model (Material[i].shader at offset 0)
: set-all-mat-shaders ( mdl shd -- )
   locals| shd mdl |
   mdl mdl.materialCount 0 ?do
      shd mdl i material[] 16 move
   loop ;

\ Column-major 4x4 matrix element address: m + (row + col*4)*4 bytes
: mxaddr ( m row col -- addr )  4 * + 4 * swap + ;

\ Dot product of row r of A with column c of B (both 4x4 column-major)
: mx-dot ( a b r c -- F: dot )
   locals| c r b a |
   0e
   a r 0 mxaddr sf@  b 0 c mxaddr sf@  f* f+
   a r 1 mxaddr sf@  b 1 c mxaddr sf@  f* f+
   a r 2 mxaddr sf@  b 2 c mxaddr sf@  f* f+
   a r 3 mxaddr sf@  b 3 c mxaddr sf@  f* f+ ;

\ dest = A * B  (column-major 4x4 matrix multiply)
\ Inside inner DO loop: I = row (inner), J = col (outer)
: MatrixMultiply ( dest a b -- dest )
   locals| b a dest |
   4 0 do            \ col
      4 0 do          \ row; I=row J=col inside here
         a b i j mx-dot
         dest i j mxaddr sf!
      loop
   loop
   dest ;

\ Build a depth-only FBO and fill the sm buffer like a RenderTexture2D
: LoadShadowmapFBO ( w h -- )
   locals| h w |
   sm 64 erase
   rlLoadFramebuffer  sm.fbo-id l!
   sm.fbo-id l@ 0> if
      sm.fbo-id l@ rlEnableFramebuffer
      w h 0 rlLoadTextureDepth  sm.depth-id l!
      w sm.depth-w l!
      h sm.depth-h l!
      19 sm.depth-fmt l!    \ PIXELFORMAT for 24-bit depth
      1  sm.depth-mm l!
      sm.fbo-id l@  sm.depth-id l@
      RL_ATTACHMENT_DEPTH  RL_ATTACHMENT_TEXTURE2D  0
      rlFramebufferAttach
      sm.fbo-id l@ rlFramebufferComplete drop
      rlDisableFramebuffer
   then ;

\ Set lightCam.position = lightDir * -15
: update-light-cam ( -- )
   lightDir v3x  -15e f*  lightCam Camera.position sf!
   lightDir v3y  -15e f*  lightCam Camera.position 4 + sf!
   lightDir v3z  -15e f*  lightCam Camera.position 8 + sf! ;

\ Draw the scene for both shadow and main passes
: DrawScene ( -- )
   \ floor: cube scaled (10,1,10) at origin
   0e 0e 0e v3a Vector3!
   0e 1e 0e v3b Vector3!
   10e 1e 10e v3c Vector3!
   cubeMdl v3a v3b 0e v3c BLUE DrawModelEx
   \ small cube at (1.5, 1, -1.5)
   1.5e 1e -1.5e v3a Vector3!
   0e 1e 0e v3b Vector3!
   1e 1e 1e v3c Vector3!
   cubeMdl v3a v3b 0e v3c WHITE DrawModelEx
   \ robot at (0, 0.5, 0)
   0e 0.5e 0e v3a Vector3!
   0e 1e 0e v3b Vector3!
   1e 1e 1e v3c Vector3!
   robotMdl v3a v3b 0e v3c RED DrawModelEx ;

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shaders] example - shadowmap rendering" InitWindow

   \ load shadow shader
   shd
      z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/shadowmap.vs"
      z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/shadowmap.fs"
      LoadShader drop

   \ store viewPos location in shader locs array
   shd z" viewPos" GetShaderLocation  shd SHADER_LOC_VECTOR_VIEW shd-loc!

   \ cache other uniform locations
   shd z" lightDir"            GetShaderLocation  lightDirLoc !
   shd z" lightColor"          GetShaderLocation  lightColLoc !
   shd z" ambient"             GetShaderLocation  ambientLoc !
   shd z" lightVP"             GetShaderLocation  lightVPLoc !
   shd z" shadowMap"           GetShaderLocation  shadowMapLoc !
   shd z" shadowMapResolution" GetShaderLocation  shadowMapResLoc !

   \ initial lightDir = normalize(0.35, -1.0, -0.35)
   0.35e fvec3a sf!  -1e fvec3a 4 + sf!  -0.35e fvec3a 8 + sf!
   lightDir fvec3a Vector3Normalize drop
   shd lightDirLoc @ lightDir SHADER_UNIFORM_VEC3 SetShaderValue

   \ lightColor = WHITE = (1,1,1,1)
   1e fvec4a sf!  1e fvec4a 4 + sf!  1e fvec4a 8 + sf!  1e fvec4a 12 + sf!
   shd lightColLoc @ fvec4a SHADER_UNIFORM_VEC4 SetShaderValue

   \ ambient = (0.1, 0.1, 0.1, 1.0)
   0.1e fvec4a sf!  0.1e fvec4a 4 + sf!  0.1e fvec4a 8 + sf!  1e fvec4a 12 + sf!
   shd ambientLoc @ fvec4a SHADER_UNIFORM_VEC4 SetShaderValue

   \ shadowMapResolution uniform
   SHADOWMAP_RESOLUTION ivalb l!
   shd shadowMapResLoc @ ivalb SHADER_UNIFORM_INT SetShaderValue

   \ load cube model
   cubeMesh 1e 1e 1e GenMeshCube drop
   cubeMdl cubeMesh LoadModelFromMesh drop
   cubeMdl shd set-all-mat-shaders

   \ load robot model and animations
   robotMdl z" /home/dave/Code/raylib/examples/shaders/resources/models/robot.glb"
   LoadModel drop
   robotMdl shd set-all-mat-shaders

   0 animsCount !  0 frameCounter !
   z" /home/dave/Code/raylib/examples/shaders/resources/models/robot.glb"
   animsCount LoadModelAnimations  anims !

   \ build depth-only shadow framebuffer
   SHADOWMAP_RESOLUTION SHADOWMAP_RESOLUTION LoadShadowmapFBO

   update-light-cam
   60 SetTargetFPS

   begin
      \ --- update ---
      GetFrameTime   ( F: dt )
      0.05e f*  60e f*   ( F: speed  = 0.05 * 60 * dt )

      \ update camera viewPos uniform
      shd  shd SHADER_LOC_VECTOR_VIEW shd-loc@  camera SHADER_UNIFORM_VEC3 SetShaderValue

      camera CAMERA_ORBITAL UpdateCamera

      \ advance animation
      1 frameCounter +!
      frameCounter @ anims @ 4 + l@ mod frameCounter !
      robotMdl  anims @  frameCounter @  UpdateModelAnimation

      \ adjust light direction with arrow keys
      KEY_LEFT down if
         lightDir v3x  0.6e f< if
            lightDir sf@  fover f+  lightDir sf!
         then
      then
      KEY_RIGHT down if
         lightDir v3x  -0.6e f> if
            lightDir sf@  fover fnegate f+  lightDir sf!
         then
      then
      KEY_UP down if
         lightDir 8 + sf@  0.6e f< if
            lightDir 8 + sf@  fover f+  lightDir 8 + sf!
         then
      then
      KEY_DOWN down if
         lightDir 8 + sf@  -0.6e f> if
            lightDir 8 + sf@  fover fnegate f+  lightDir 8 + sf!
         then
      then
      fdrop   \ discard speed

      \ normalize lightDir, update shader, reposition light camera
      fvec3a lightDir Vector3Normalize drop
      lightDir fvec3a 12 move
      shd lightDirLoc @ lightDir SHADER_UNIFORM_VEC3 SetShaderValue
      update-light-cam

      \ --- shadow pass: render from light's point of view ---
      sm BeginTextureMode
         WHITE ClearBackground
         lightCam BeginMode3D
            lightView rlGetMatrixModelview drop
            lightProj rlGetMatrixProjection drop
            DrawScene
         EndMode3D
      EndTextureMode

      \ compute combined lightViewProj = lightView * lightProj
      lightViewProj lightView lightProj MatrixMultiply drop

      \ --- main pass: render scene to screen with shadow map ---
      BeginDrawing
         RAYWHITE ClearBackground

         shd lightVPLoc @ lightViewProj SetShaderValueMatrix

         texSlot rlActiveTextureSlot
         sm.depth-id l@ rlEnableTexture
         texSlot ivalb l!
         shd shadowMapLoc @ ivalb SHADER_UNIFORM_INT SetShaderValue

         camera BeginMode3D
            DrawScene
         EndMode3D

         rlDisableTexture

         z" Use the arrow keys to rotate the light!" 10 10 30 RED DrawText
         z" Shadows in raylib using the shadowmapping algorithm!"
            screenWidth 280 -  screenHeight 20 -  10 GRAY DrawText

      EndDrawing

      KEY_F IsKeyPressed if z" shaders_shadowmap.png" TakeScreenshot then

   WindowShouldClose until

   \ --- cleanup ---
   shd UnloadShader
   cubeMdl UnloadModel
   robotMdl UnloadModel
   anims @ animsCount @ UnloadModelAnimations
   sm.fbo-id l@ rlUnloadFramebuffer
   CloseWindow ;

example-end
