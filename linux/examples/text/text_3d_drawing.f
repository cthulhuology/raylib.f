\ Port of raylib examples/text/text_3d_drawing.c
\ Partial: 3D camera + cube + 2D text overlay. rlgl per-glyph 3D quads / wave / alpha-discard not ported.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE camera 64 ALLOT
CREATE cubePosition 16 ALLOT
CREATE cubeSize 16 ALLOT
CREATE font 64 ALLOT
CREATE pos 16 ALLOT
CREATE dropped 32 ALLOT
VARIABLE spin
VARIABLE camera-mode
VARIABLE light
VARIABLE dark
FVARIABLE fontSize

: example
   FLAG_MSAA_4X_HINT FLAG_VSYNC_HINT or SetConfigFlags
   screenWidth screenHeight z" raylib [text] example - 3d drawing" InitWindow
   1 spin !
   -10e 15e -10e camera Vector3!
   0e 0e 0e camera Camera.target Vector3!
   0e 1e 0e camera Camera.up Vector3!
   45e camera Camera.fovy sf!
   CAMERA_PERSPECTIVE camera Camera.proj l!
   CAMERA_ORBITAL camera-mode !
   0e 1e 0e cubePosition Vector3!
   2e 2e 2e cubeSize Vector3!
   font GetFontDefault drop
   0.8e fontSize f!
   MAROON light !
   RED dark !
   DisableCursor
   60 SetTargetFPS
   begin
      camera camera-mode @ UpdateCamera
      IsFileDropped if
         dropped LoadDroppedFiles drop
         dropped filePathList_paths @ @ z" .ttf" IsFileExtension if
            font UnloadFont
            font dropped filePathList_paths @ @ 32 0 0 LoadFontEx drop
         else dropped filePathList_paths @ @ z" .fnt" IsFileExtension if
            font UnloadFont
            font dropped filePathList_paths @ @ LoadFont drop
         then then
         dropped UnloadDroppedFiles
      then
      KEY_F3 IsKeyPressed if
         spin @ 0= spin !
         0e 0e 0e camera Camera.target Vector3!
         0e 1e 0e camera Camera.up Vector3!
         45e camera Camera.fovy sf!
         CAMERA_PERSPECTIVE camera Camera.proj l!
         spin @ if
            -10e 15e -10e camera Vector3!
            CAMERA_ORBITAL camera-mode !
         else
            10e 10e -10e camera Vector3!
            CAMERA_FREE camera-mode !
         then
      then
      MOUSE_BUTTON_LEFT IsMouseButtonPressed if
         0 255 GetRandomValue 0 255 GetRandomValue 0 255 GetRandomValue 255 RGBA light !
         0 255 GetRandomValue 0 255 GetRandomValue 0 255 GetRandomValue 255 RGBA dark !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            cubePosition cubeSize v3x cubeSize v3y cubeSize v3z dark @ DrawCube
            cubePosition cubeSize v3x cubeSize v3y cubeSize v3z light @ DrawCubeWires
            10 1e DrawGrid
         EndMode3D
         z" Hello World in 3D!" 20 40 30 MAROON DrawText
         font z" Drop a .ttf to load a font" 20e 80e pos Vector2! pos 20e 1e DARKGRAY DrawTextEx
         z" Partial: 3D glyph quads / wave text / alpha-discard shader not ported" 10 screenHeight 50 - 10 ORANGE DrawText
         z" F3: toggle camera   click: random cube colors   mouse: orbit/free" 10 screenHeight 30 - 10 DARKGRAY DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
