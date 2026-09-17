\ Port of raylib examples/shaders/shaders_deferred_rendering.c

36008 CONSTANT RL_READ_FRAMEBUFFER  \ GL_READ_FRAMEBUFFER
36009 CONSTANT RL_DRAW_FRAMEBUFFER  \ GL_DRAW_FRAMEBUFFER
$100  CONSTANT GL_DEPTH_BUFFER_BIT

0 CONSTANT DEFERRED_POSITION
1 CONSTANT DEFERRED_NORMAL
2 CONSTANT DEFERRED_ALBEDO
3 CONSTANT DEFERRED_SHADING

30 CONSTANT MAX_CUBES
0.25e FCONSTANT CUBE_SCALE

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   5e 4e 5e :Camera.position
   0e 1e 0e :Camera.target
   0e 1e 0e :Camera.up
   60e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

\ Shader buffers (Shader struct = 16 bytes on 64-bit: c_long id + ptr locs)
CREATE gbuf-shd 16 ALLOT    \ geometry buffer (G-buffer) shader
CREATE def-shd  16 ALLOT    \ deferred shading shader

\ Model and mesh buffers (120 bytes each)
CREATE plane-mesh 128 ALLOT
CREATE cube-mesh  128 ALLOT
CREATE plane-mdl  128 ALLOT
CREATE cube-mdl   128 ALLOT

\ G-buffer IDs
VARIABLE gbuf-fbo    \ framebuffer object id
VARIABLE gbuf-pos    \ position texture id
VARIABLE gbuf-nrm    \ normal texture id
VARIABLE gbuf-alb    \ albedo+specular texture id
VARIABLE gbuf-dep    \ depth renderbuffer id

\ Display mode (DEFERRED_POSITION/NORMAL/ALBEDO/SHADING)
VARIABLE gmode

\ Cube positions (30 * 12 bytes = 360 bytes) and rotations (30 * 4 bytes = 120 bytes)
CREATE cubePositions 360 ALLOT
CREATE cubeRotations 120 ALLOT

\ Scratch Vector3 buffers for drawing
1e 1e 1e Vector3: cubeAxis
0.25e 0.25e 0.25e Vector3: cubeScaleV
0e 0e 0e Vector3: origin3

\ Scratch Texture2D buffer for DrawTextureRec (id w h mipmaps format = 5*4 = 20 bytes)
CREATE gbuf-texbuf 20 ALLOT

\ Set up a temporary Texture2D struct from a raw id, width, height
: set-tex2d ( id w h -- )
   gbuf-texbuf 8 + l!   \ height at offset 8
   gbuf-texbuf 4 + l!   \ width at offset 4
   gbuf-texbuf l!       \ id at offset 0
   1 gbuf-texbuf 12 + l!  \ mipmaps = 1
   0 gbuf-texbuf 16 + l!  \ format = 0 (unknown, doesn't matter for draw)
;

\ Initialise cube positions and rotations with pseudo-random values
: init-cubes ( -- )
   MAX_CUBES 0 do
      -5 4 GetRandomValue s>f  i 12 * cubePositions + sf!
      0 4  GetRandomValue s>f  i 12 * cubePositions + 4 + sf!
      -5 4 GetRandomValue s>f  i 12 * cubePositions + 8 + sf!
      0 359 GetRandomValue s>f  i 4 * cubeRotations + sf!
   loop ;

\ Draw the deferred shading mode (full lighting pass + depth blit + light spheres)
: draw-deferred-shading ( -- )
   camera BeginMode3D
      rlDisableColorBlend
      def-shd l@ rlEnableShader
         \ Bind G-buffer textures to their sampler slots
         0 rlActiveTextureSlot  gbuf-pos @ rlEnableTexture
         1 rlActiveTextureSlot  gbuf-nrm @ rlEnableTexture
         2 rlActiveTextureSlot  gbuf-alb @ rlEnableTexture
         \ Draw fullscreen quad using deferred shader
         rlLoadDrawQuad
      rlDisableShader
      rlEnableColorBlend
   EndMode3D

   \ Blit depth buffer from G-buffer FBO to default framebuffer
   RL_READ_FRAMEBUFFER gbuf-fbo @ rlBindFramebuffer
   RL_DRAW_FRAMEBUFFER 0 rlBindFramebuffer
   0 0 screenWidth screenHeight 0 0 screenWidth screenHeight GL_DEPTH_BUFFER_BIT rlBlitFramebuffer
   rlDisableFramebuffer

   \ Draw light position spheres using default forward shader
   camera BeginMode3D
      rlGetShaderIdDefault rlEnableShader
         MAX_LIGHTS 0 do
            i light[] L.enabled @ if
               i light[] L.pos 0.2e 8 8 i light[] L.color @ DrawSphereEx
            else
               i light[] L.pos 0.2e 8 8 i light[] L.color @ 0.3e ColorAlpha DrawSphereWires
            then
         loop
      rlDisableShader
   EndMode3D

   z" FINAL RESULT" 10 screenHeight 30 - 20 DARKGREEN DrawText ;

\ Draw one of the G-buffer debug textures fullscreen
: draw-gbuf-texture ( id label -- )
   >r
   screenWidth screenHeight set-tex2d
   0e 0e screenWidth s>f screenHeight s>f fnegate reca Rectangle!
   gbuf-texbuf reca origin2 RAYWHITE DrawTextureRec
   r> 10 screenHeight 30 - 20 DARKGREEN DrawText ;

: example
   lights-reset
   screenWidth screenHeight z" raylib [shaders] example - deferred rendering" InitWindow

   \ Load geometry-buffer shader and deferred shading shader
   gbuf-shd
      z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/gbuffer.vs"
      z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/gbuffer.fs"
      LoadShader drop

   def-shd
      z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/deferred_shading.vs"
      z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/deferred_shading.fs"
      LoadShader drop

   \ Store viewPosition location in deferred shader locs table
   def-shd z" viewPosition" GetShaderLocation  def-shd SHADER_LOC_VECTOR_VIEW shd-loc!

   \ ----- Build G-buffer FBO -----
   rlLoadFramebuffer gbuf-fbo !

   gbuf-fbo @ 0= if
      LOG_WARNING z" Failed to create G-buffer framebuffer" TraceLog
   then

   gbuf-fbo @ rlEnableFramebuffer

   \ Position texture: R16G16B16
   0 screenWidth screenHeight PIXELFORMAT_UNCOMPRESSED_R16G16B16 1 rlLoadTexture gbuf-pos !
   \ Normal texture: R16G16B16
   0 screenWidth screenHeight PIXELFORMAT_UNCOMPRESSED_R16G16B16 1 rlLoadTexture gbuf-nrm !
   \ Albedo+specular texture: R8G8B8A8
   0 screenWidth screenHeight PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 1 rlLoadTexture gbuf-alb !

   \ Activate 3 draw color buffers
   3 rlActiveDrawBuffers

   \ Attach color textures
   gbuf-fbo @ gbuf-pos @ RL_ATTACHMENT_COLOR_CHANNEL0 RL_ATTACHMENT_TEXTURE2D 0 rlFramebufferAttach
   gbuf-fbo @ gbuf-nrm @ RL_ATTACHMENT_COLOR_CHANNEL1 RL_ATTACHMENT_TEXTURE2D 0 rlFramebufferAttach
   gbuf-fbo @ gbuf-alb @ RL_ATTACHMENT_COLOR_CHANNEL2 RL_ATTACHMENT_TEXTURE2D 0 rlFramebufferAttach

   \ Attach depth renderbuffer
   screenWidth screenHeight 1 rlLoadTextureDepth gbuf-dep !
   gbuf-fbo @ gbuf-dep @ RL_ATTACHMENT_DEPTH RL_ATTACHMENT_RENDERBUFFER 0 rlFramebufferAttach

   \ Verify FBO completeness (also unbinds the FBO)
   gbuf-fbo @ rlFramebufferComplete 0= if
      LOG_WARNING z" G-buffer framebuffer is not complete" TraceLog
   then

   \ Set up sampler2D uniforms in deferred shader by binding to known texture units
   \ ival holds the texture unit index as the value-pointer for SetShaderValue
   def-shd l@ rlEnableShader
      def-shd l@ z" gPosition"   rlGetLocationUniform  ( loc )
      0 ival l!  def-shd swap ival SHADER_UNIFORM_SAMPLER2D SetShaderValue
      def-shd l@ z" gNormal"     rlGetLocationUniform  ( loc )
      1 ival l!  def-shd swap ival SHADER_UNIFORM_SAMPLER2D SetShaderValue
      def-shd l@ z" gAlbedoSpec" rlGetLocationUniform  ( loc )
      2 ival l!  def-shd swap ival SHADER_UNIFORM_SAMPLER2D SetShaderValue
   rlDisableShader

   \ Assign G-buffer shader to models
   plane-mesh 10e 10e 3 3 GenMeshPlane drop
   plane-mdl plane-mesh LoadModelFromMesh drop
   plane-mdl gbuf-shd set-mat-shader

   cube-mesh 2e 2e 2e GenMeshCube drop
   cube-mdl cube-mesh LoadModelFromMesh drop
   cube-mdl gbuf-shd set-mat-shader

   \ Create 4 point lights (deferred shader)
   LIGHT_POINT -2e 1e -2e v3a Vector3!  v3a  v3b Vector3Zero YELLOW def-shd CreateLight drop
   LIGHT_POINT  2e 1e  2e v3a Vector3!  v3a  v3b Vector3Zero RED    def-shd CreateLight drop
   LIGHT_POINT -2e 1e  2e v3a Vector3!  v3a  v3b Vector3Zero GREEN  def-shd CreateLight drop
   LIGHT_POINT  2e 1e -2e v3a Vector3!  v3a  v3b Vector3Zero BLUE   def-shd CreateLight drop

   \ Randomise cube positions/rotations
   init-cubes

   \ Start in shading mode
   DEFERRED_SHADING gmode !

   rlEnableDepthTest
   60 SetTargetFPS

   begin
      \ Update camera
      camera CAMERA_ORBITAL UpdateCamera

      \ Update viewPosition uniform in deferred shader
      camera fvec3 12 move
      def-shd  def-shd SHADER_LOC_VECTOR_VIEW shd-loc@  fvec3 SHADER_UNIFORM_VEC3 SetShaderValue

      \ Toggle individual lights
      KEY_Y IsKeyPressed if 0 light[] L.enabled @ 0= 0 light[] L.enabled ! then
      KEY_R IsKeyPressed if 1 light[] L.enabled @ 0= 1 light[] L.enabled ! then
      KEY_G IsKeyPressed if 2 light[] L.enabled @ 0= 2 light[] L.enabled ! then
      KEY_B IsKeyPressed if 3 light[] L.enabled @ 0= 3 light[] L.enabled ! then

      \ Switch G-buffer debug view
      KEY_ONE   IsKeyPressed if DEFERRED_POSITION gmode ! then
      KEY_TWO   IsKeyPressed if DEFERRED_NORMAL   gmode ! then
      KEY_THREE IsKeyPressed if DEFERRED_ALBEDO   gmode ! then
      KEY_FOUR  IsKeyPressed if DEFERRED_SHADING  gmode ! then

      \ Push updated light state to deferred shader
      MAX_LIGHTS 0 do def-shd i light[] UpdateLightValues loop

      BeginDrawing

         \ ----- Geometry pass: render scene into G-buffer -----
         gbuf-fbo @ rlEnableFramebuffer
         0 0 0 0 rlClearColor
         rlClearScreenBuffers

         rlDisableColorBlend
         camera BeginMode3D
            gbuf-shd l@ rlEnableShader
               plane-mdl origin3 1e WHITE DrawModel
               0e 1e 0e v3a Vector3!
               cube-mdl v3a 1e WHITE DrawModel
               MAX_CUBES 0 do
                  i 12 * cubePositions +      ( pos-addr ; F: -- )
                  i 4 * cubeRotations + sf@   ( pos-addr ; F: angle )
                  cube-mdl swap cubeAxis      ( cube-mdl pos-addr cubeAxis ; F: angle )
                  cubeScaleV WHITE DrawModelEx
               loop
            rlDisableShader
         EndMode3D
         rlEnableColorBlend

         \ ----- Lighting / display pass: render to default FBO -----
         rlDisableFramebuffer
         rlClearScreenBuffers

         gmode @ case
            DEFERRED_SHADING  of draw-deferred-shading endof
            DEFERRED_POSITION of gbuf-pos @ z" POSITION TEXTURE" draw-gbuf-texture endof
            DEFERRED_NORMAL   of gbuf-nrm @ z" NORMAL TEXTURE"   draw-gbuf-texture endof
            DEFERRED_ALBEDO   of gbuf-alb @ z" ALBEDO TEXTURE"   draw-gbuf-texture endof
         endcase

         z" Toggle lights keys: [Y][R][G][B]"      10 40 20 DARKGRAY DrawText
         z" Switch G-buffer textures: [1][2][3][4]" 10 70 20 DARKGRAY DrawText
         10 10 DrawFPS

      EndDrawing
   WindowShouldClose until

   \ Cleanup
   gbuf-fbo @ rlUnloadFramebuffer
   gbuf-pos @ rlUnloadTexture
   gbuf-nrm @ rlUnloadTexture
   gbuf-alb @ rlUnloadTexture
   gbuf-dep @ rlUnloadTexture

   def-shd UnloadShader
   gbuf-shd UnloadShader

   plane-mdl UnloadModel
   cube-mdl  UnloadModel

   CloseWindow ;

example-end
