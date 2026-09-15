\ Port of raylib examples/core/core_vr_simulator.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE device 60 ALLOT
CREATE config 304 ALLOT
CREATE distortion 16 ALLOT
CREATE target 44 ALLOT
CREATE sourceRec 16 ALLOT
CREATE destRec 16 ALLOT
CREATE origin 8 ALLOT
CREATE cubePosition 12 ALLOT

Camera: camera
   5.0e 2.0e 5.0e :Camera.position
   0.0e 2.0e 0.0e :Camera.target
   0.0e 1.0e 0.0e :Camera.up
   60.0e          :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: sf4! ( addr F: a b c d -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: init-device
   device 60 erase
   2160 device l!
   1200 device 4 + l!
   0.133793e device 8 + sf!
   0.0669e   device 12 + sf!
   0.041e    device 16 + sf!
   0.07e     device 20 + sf!
   0.07e     device 24 + sf!
   1.0e 0.22e 0.24e 0.0e device 28 + sf4!
   0.996e -0.004e 1.014e 0.0e device 44 + sf4! ;

: shader-set-vec2 ( shader zname addr -- )
   >r  2dup GetShaderLocation  r> SHADER_UNIFORM_VEC2 SetShaderValue ;

: example
   init-device
   0e 0e 0e cubePosition Vector3!
   0e 0e origin Vector2!
   screenWidth screenHeight z" raylib [core] example - vr simulator" InitWindow
   config device LoadVrStereoConfig drop
   distortion 0 z" /home/dave/Code/raylib/examples/core/resources/shaders/glsl330/distortion.fs" LoadShader drop
   distortion z" leftLensCenter"  config vrStereoConfig_leftLensCenter  shader-set-vec2
   distortion z" rightLensCenter" config vrStereoConfig_rightLensCenter shader-set-vec2
   distortion z" leftScreenCenter" config vrStereoConfig_leftScreenCenter shader-set-vec2
   distortion z" rightScreenCenter" config vrStereoConfig_rightScreenCenter shader-set-vec2
   distortion z" scale" config vrStereoConfig_scale shader-set-vec2
   distortion z" scaleIn" config vrStereoConfig_scaleIn shader-set-vec2
   distortion dup z" deviceWarpParam" GetShaderLocation device 28 + SHADER_UNIFORM_VEC4 SetShaderValue
   distortion dup z" chromaAbParam" GetShaderLocation device 44 + SHADER_UNIFORM_VEC4 SetShaderValue
   target 2160 1200 LoadRenderTexture drop
   0e 0e target 8 + l@ s>f target 12 + l@ s>f fnegate sourceRec Rectangle!
   0e 0e GetScreenWidth s>f GetScreenHeight s>f destRec Rectangle!
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FIRST_PERSON UpdateCamera
      target BeginTextureMode
         RAYWHITE ClearBackground
         config BeginVrStereoMode
            camera BeginMode3D
               cubePosition 2e 2e 2e RED DrawCube
               cubePosition 2e 2e 2e MAROON DrawCubeWires
               40 1e DrawGrid
            EndMode3D
         EndVrStereoMode
      EndTextureMode
      BeginDrawing
         RAYWHITE ClearBackground
         distortion BeginShaderMode
            target 4 + sourceRec destRec origin 0e WHITE DrawTexturePro
         EndShaderMode
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   config UnloadVrStereoConfig
   target UnloadRenderTexture
   distortion UnloadShader
   CloseWindow ;

example-end
