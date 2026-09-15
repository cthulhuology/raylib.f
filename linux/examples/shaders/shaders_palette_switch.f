\ Port of raylib examples/shaders/shaders_palette_switch.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE shd 32 ALLOT
CREATE pal 8 3 * 4 * ALLOT
VARIABLE current
VARIABLE palLoc

: set-rgb ( i r g b -- )
   >r >r >r
   3 * 4 * pal +
   r> over l!  4 +
   r> over l!  4 +
   r> swap l! ;

: load-pal0
   0 0 0 0 set-rgb  1 255 0 0 set-rgb  2 0 255 0 set-rgb  3 0 0 255 set-rgb
   4 0 255 255 set-rgb  5 255 0 255 set-rgb  6 255 255 0 set-rgb  7 255 255 255 set-rgb ;

: example
   0 current !
   screenWidth screenHeight z" raylib [shaders] example - palette switch" InitWindow
   shd 0 z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/palette_switch.fs" LoadShader drop
   shd z" palette" GetShaderLocation palLoc !
   load-pal0
   shd palLoc @ pal SHADER_UNIFORM_IVEC3 8 SetShaderValueV
   60 SetTargetFPS
   begin
      KEY_RIGHT IsKeyPressed if current @ 1+ 3 mod current ! load-pal0
         shd palLoc @ pal SHADER_UNIFORM_IVEC3 8 SetShaderValueV then
      BeginDrawing
         RAYWHITE ClearBackground
         shd BeginShaderMode
            8 0 do
               0 i 50 *  screenWidth 50 i 50 *  255 32 * i +  dup dup RGBA DrawRectangle
            loop
         EndShaderMode
         z" RIGHT to cycle palettes (3-BIT RGB shown)" 10 10 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   shd UnloadShader
   CloseWindow ;

example-end
