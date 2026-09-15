\ Port of raylib examples/models/models_loading_vox.c
\ Simplified lighting via rlights helpers in common.f

800 CONSTANT screenWidth
450 CONSTANT screenHeight
4 CONSTANT MAX_VOX_FILES

Camera: camera
   10e 10e 10e :Camera.position
   0e  0e  0e  :Camera.target
   0e  1e  0e  :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE models 4 128 * ALLOT
CREATE shd 32 ALLOT
CREATE bb 32 ALLOT
CREATE center 16 ALLOT
0e 0e 0e Vector3: modelpos
0e 0e 0e Vector3: camerarot
0e 0e 0e Vector3: movement
CREATE delta 16 ALLOT
VARIABLE currentModel

: vox0 z" /home/dave/Code/raylib/examples/models/resources/models/vox/chr_knight.vox" ;
: vox1 z" /home/dave/Code/raylib/examples/models/resources/models/vox/chr_sword.vox" ;
: vox2 z" /home/dave/Code/raylib/examples/models/resources/models/vox/monu9.vox" ;
: vox3 z" /home/dave/Code/raylib/examples/models/resources/models/vox/fez.vox" ;

: vox-name ( i -- z )
   dup 0 = if drop vox0 else
   dup 1 = if drop vox1 else
   dup 2 = if drop vox2 else drop vox3 then then then ;

: mdl-i ( i -- a ) 128 * models + ;

: center-model ( mdl -- )
   >r
   bb r@ GetModelBoundingBox drop
   bb sf@  bb 12 + sf@ bb sf@ f- 2e f/ f+
   0e
   bb 8 + sf@  bb 20 + sf@ bb 8 + sf@ f- 2e f/ f+
   center Vector3!
   r@ center .x fnegate  0e  center .z fnegate MatrixTranslate! drop
   r> drop ;

: example
   lights-reset
   0 currentModel !
   screenWidth screenHeight z" raylib [models] example - loading vox" InitWindow
   4 0 do i mdl-i  i vox-name LoadModel drop  i mdl-i center-model loop
   shd z" /home/dave/Code/raylib/examples/models/resources/shaders/glsl330/voxel_lighting.vs"
       z" /home/dave/Code/raylib/examples/models/resources/shaders/glsl330/voxel_lighting.fs" LoadShader drop
   shd z" viewPos" GetShaderLocation shd SHADER_LOC_VECTOR_VIEW shd-loc!
   0.1e 0.1e 0.1e 1e fvec4 Vector4!
   shd dup z" ambient" GetShaderLocation fvec4 SHADER_UNIFORM_VEC4 SetShaderValue
   4 0 do
      i mdl-i mdl.materialCount 0 ?do
         shd  j mdl-i i material[]  16 move
      loop
   loop
   LIGHT_POINT -20e 20e -20e v3a Vector3! v3a v3b Vector3Zero GRAY shd CreateLight drop
   LIGHT_POINT  20e -20e 20e v3a Vector3! v3a v3b Vector3Zero GRAY shd CreateLight drop
   LIGHT_POINT -20e 20e  20e v3a Vector3! v3a v3b Vector3Zero GRAY shd CreateLight drop
   LIGHT_POINT  20e -20e -20e v3a Vector3! v3a v3b Vector3Zero GRAY shd CreateLight drop
   60 SetTargetFPS
   begin
      MOUSE_BUTTON_MIDDLE IsMouseButtonDown if
         delta GetMouseDelta drop
         delta v2x 0.05e f*  delta v2y 0.05e f*  0e camerarot Vector3!
      else
         0e 0e 0e camerarot Vector3!
      then
      KEY_W down KEY_UP down or if 0.1e else 0e then
      KEY_S down KEY_DOWN down or if 0.1e f- then
      KEY_D down KEY_RIGHT down or if 0.1e else 0e then
      KEY_A down KEY_LEFT down or if 0.1e f- then
      0e movement Vector3!
      GetMouseWheelMove -2e f*
      camera movement camerarot UpdateCameraPro
      MOUSE_BUTTON_LEFT IsMouseButtonPressed if
         currentModel @ 1+ MAX_VOX_FILES mod currentModel ! then
      camera fvec3 12 move
      shd shd SHADER_LOC_VECTOR_VIEW shd-loc@ fvec3 SHADER_UNIFORM_VEC3 SetShaderValue
      #lights @ 0 ?do shd i light[] UpdateLightValues loop
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            currentModel @ mdl-i modelpos 1e WHITE DrawModel
            10 1e DrawGrid
            #lights @ 0 ?do
               i light[] L.enabled @ if
                  i light[] L.pos 0.2e 8 8 i light[] L.color @ DrawSphereEx
               then
            loop
         EndMode3D
         10 400 340 60 SKYBLUE 0.5e Fade DrawRectangle
         10 400 340 60 DARKBLUE 0.5e Fade DrawRectangleLines
         z" MOUSE LEFT BUTTON to CYCLE VOX MODELS" 40 410 10 BLUE DrawText
         z" MOUSE MIDDLE BUTTON to ZOOM OR ROTATE CAMERA" 40 420 10 BLUE DrawText
         z" UP-DOWN-LEFT-RIGHT KEYS to MOVE CAMERA" 40 430 10 BLUE DrawText
         currentModel @ vox-name GetFileName 10 10 20 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   4 0 do i mdl-i UnloadModel loop
   shd UnloadShader
   CloseWindow ;

example-end
