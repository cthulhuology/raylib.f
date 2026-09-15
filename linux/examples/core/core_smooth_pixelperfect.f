\ Port of raylib examples/core/core_smooth_pixelperfect.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
160 CONSTANT virtualScreenWidth
90 CONSTANT virtualScreenHeight

CREATE worldSpaceCamera 24 ALLOT
CREATE screenSpaceCamera 24 ALLOT
CREATE target 44 ALLOT
CREATE rec01 16 ALLOT
CREATE rec02 16 ALLOT
CREATE rec03 16 ALLOT
CREATE sourceRec 16 ALLOT
CREATE destRec 16 ALLOT
CREATE origin 8 ALLOT
0e fvalue rotation
0e fvalue cameraX
0e fvalue cameraY
0e fvalue virtualRatio

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: cam-tgt ( c -- a ) 8 + ;
: cam-zoom ( c -- a ) 20 + ;

: example
   screenWidth s>f virtualScreenWidth s>f f/ to virtualRatio
   worldSpaceCamera 24 erase  screenSpaceCamera 24 erase
   1e worldSpaceCamera cam-zoom sf!
   1e screenSpaceCamera cam-zoom sf!
   70e 35e 20e 20e rec01 Rectangle!
   90e 55e 30e 10e rec02 Rectangle!
   80e 65e 15e 25e rec03 Rectangle!
   0e 0e origin Vector2!
   0e to rotation
   screenWidth screenHeight z" raylib [core] example - smooth pixelperfect" InitWindow
   target virtualScreenWidth virtualScreenHeight LoadRenderTexture drop
   0e 0e
   target 8 + l@ s>f
   target 12 + l@ s>f fnegate
   sourceRec Rectangle!
   virtualRatio fnegate fdup
   screenWidth s>f virtualRatio 2e f* f+
   screenHeight s>f virtualRatio 2e f* f+
   destRec Rectangle!
   60 SetTargetFPS
   begin
      rotation 60e GetFrameTime f* f+ to rotation
      GetTime fsin 50e f* 10e f- to cameraX
      GetTime fcos 30e f* to cameraY
      cameraX cameraY screenSpaceCamera cam-tgt Vector2!
      screenSpaceCamera cam-tgt sf@ ftrunc worldSpaceCamera cam-tgt sf!
      screenSpaceCamera cam-tgt sf@ worldSpaceCamera cam-tgt sf@ f- virtualRatio f* screenSpaceCamera cam-tgt sf!
      screenSpaceCamera cam-tgt 4 + sf@ ftrunc worldSpaceCamera cam-tgt 4 + sf!
      screenSpaceCamera cam-tgt 4 + sf@ worldSpaceCamera cam-tgt 4 + sf@ f- virtualRatio f* screenSpaceCamera cam-tgt 4 + sf!
      target BeginTextureMode
         RAYWHITE ClearBackground
         worldSpaceCamera BeginMode2D
            rec01 origin rotation BLACK DrawRectanglePro
            rec02 origin rotation fnegate RED DrawRectanglePro
            rec03 origin rotation 45e f+ BLUE DrawRectanglePro
         EndMode2D
      EndTextureMode
      BeginDrawing
         RED ClearBackground
         screenSpaceCamera BeginMode2D
            target 4 + sourceRec destRec origin 0e WHITE DrawTexturePro
         EndMode2D
         z" Screen resolution: 800x450" 10 10 20 DARKBLUE DrawText
         z" World resolution: 160x90" 10 40 20 DARKGREEN DrawText
         GetScreenWidth 95 - 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   target UnloadRenderTexture
   CloseWindow ;

example-end
