\ Port of raylib examples/shaders/shaders_postprocessing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
12 CONSTANT MAX_POSTPRO

Camera: camera
   2e 3e 2e :Camera.position
   0e 1e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
CREATE shaders 12 32 * ALLOT
CREATE target 64 ALLOT
0e 0e 0e Vector3: position
VARIABLE current

: shd-i ( i -- a ) 32 * shaders + ;

: fx-name ( i -- z )
   dup 0 = if drop z" GRAYSCALE" else
   dup 1 = if drop z" POSTERIZATION" else
   dup 2 = if drop z" DREAM_VISION" else
   dup 3 = if drop z" PIXELIZER" else
   dup 4 = if drop z" CROSS_HATCHING" else
   dup 5 = if drop z" CROSS_STITCHING" else
   dup 6 = if drop z" PREDATOR_VIEW" else
   dup 7 = if drop z" SCANLINES" else
   dup 8 = if drop z" FISHEYE" else
   dup 9 = if drop z" SOBEL" else
   dup 10 = if drop z" BLOOM" else
               drop z" BLUR" then then then then then then then then then then then ;

: load-fx ( i z -- ) swap shd-i 0 rot LoadShader drop ;

: example
   0 current !
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shaders] example - postprocessing" InitWindow
   mdl z" /home/dave/Code/raylib/examples/shaders/resources/models/church.obj" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/shaders/resources/models/church_diffuse.png" LoadTexture drop
   mdl tex set-diffuse
   0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/grayscale.fs" load-fx
   1 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/posterization.fs" load-fx
   2 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/dream_vision.fs" load-fx
   3 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/pixelizer.fs" load-fx
   4 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/cross_hatching.fs" load-fx
   5 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/cross_stitching.fs" load-fx
   6 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/predator.fs" load-fx
   7 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/scanlines.fs" load-fx
   8 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/fisheye.fs" load-fx
   9 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/sobel.fs" load-fx
   10 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/bloom.fs" load-fx
   11 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/blur.fs" load-fx
   target screenWidth screenHeight LoadRenderTexture drop
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      KEY_RIGHT IsKeyPressed if current @ 1+ MAX_POSTPRO mod current ! then
      KEY_LEFT IsKeyPressed if current @ MAX_POSTPRO + 1- MAX_POSTPRO mod current ! then
      target BeginTextureMode
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position 0.1e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
      EndTextureMode
      BeginDrawing
         RAYWHITE ClearBackground
         current @ shd-i BeginShaderMode
            0e 0e target rtex.w s>f target rtex.h s>f fnegate reca Rectangle!
            0e 0e v2a Vector2!
            target rtex reca v2a WHITE DrawTextureRec
         EndShaderMode
         0 9 580 30 LIGHTGRAY 0.7e Fade DrawRectangle
         z" LEFT/RIGHT to cycle postpro shader" 10 15 20 BLACK DrawText
         current @ fx-name 680 15 20 RED DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   MAX_POSTPRO 0 do i shd-i UnloadShader loop
   tex UnloadTexture
   mdl UnloadModel
   target UnloadRenderTexture
   CloseWindow ;

example-end
