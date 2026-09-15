\ Port of raylib examples/shapes/shapes_bullet_hell.c
\ MAX_BULLETS reduced for Forth inner-loop cost.

800 CONSTANT screenWidth
450 CONSTANT screenHeight
20000 CONSTANT MAXB
10 CONSTANT bulletRadius

\ Bullet: pos(8) acc(8) disabled(8) color(8) = 32
32 CONSTANT /B
CREATE bullets MAXB /B * ALLOT
VARIABLE bulletCount
VARIABLE bulletDisabled
FVARIABLE bulletSpeed
VARIABLE bulletRows
CREATE bcol 2 CELLS ALLOT
FVARIABLE baseDir
VARIABLE angleInc
FVARIABLE spawnCD
FVARIABLE spawnTimer
FVARIABLE magicRot
CREATE bulletTex 48 ALLOT
VARIABLE perfMode
CREATE rec 16 ALLOT
CREATE orig 8 ALLOT

: b ( i -- a ) /B * bullets + ;
: b.pos ( a -- a ) ;
: b.acc ( a -- a ) 8 + ;
: b.dis ( a -- a ) 16 + ;
: b.col ( a -- a ) 24 + ;

: example
   screenWidth screenHeight z" raylib [shapes] example - bullet hell" InitWindow
   bullets MAXB /B * erase
   0 bulletCount !  0 bulletDisabled !
   3e bulletSpeed !  6 bulletRows !
   RED bcol !  BLUE bcol cell+ !
   0e baseDir !  5 angleInc !
   2e spawnCD f!  spawnCD f@ spawnTimer f!
   0e magicRot f!
   bulletTex 24 24 LoadRenderTexture drop
   bulletTex BeginTextureMode
      12 12 bulletRadius s>f WHITE DrawCircle
      12 12 bulletRadius s>f BLACK DrawCircleLines
   EndTextureMode
   true perfMode !
   60 SetTargetFPS
   begin
      bulletCount @ MAXB >= if 0 bulletCount ! 0 bulletDisabled ! then
      spawnTimer f@ 1e f- spawnTimer f!
      spawnTimer f@ f0< if
         spawnCD f@ spawnTimer f!
         360e bulletRows @ s>f f/
         bulletRows @ 0 do
            bulletCount @ MAXB < if
               screenWidth 2/ s>f screenHeight 2/ s>f bulletCount @ b b.pos Vector2!
               false bulletCount @ b b.dis !
               bcol i 2 mod cells + @ bulletCount @ b b.col !
               baseDir f@ fover i s>f f* f+
               fdup deg>rad fcos bulletSpeed f@ f*
               fswap deg>rad fsin bulletSpeed f@ f*
               bulletCount @ b b.acc Vector2!
               1 bulletCount +!
            then
         loop
         fdrop
         baseDir f@ angleInc @ s>f f+ baseDir f!
      then
      bulletCount @ 0 > if
      bulletCount @ 0 do
         i b b.dis @ 0= if
            i b b.pos v2x i b b.acc v2x f+ i b b.pos sf!
            i b b.pos v2y i b b.acc v2y f+ i b b.pos 4 + sf!
            i b b.pos v2x bulletRadius -2 * s>f f<
            i b b.pos v2x screenWidth bulletRadius 2 * + s>f f> or
            i b b.pos v2y bulletRadius -2 * s>f f< or
            i b b.pos v2y screenHeight bulletRadius 2 * + s>f f> or
            if true i b b.dis !  1 bulletDisabled +! then
         then
      loop then
      KEY_RIGHT IsKeyPressed KEY_D IsKeyPressed or  bulletRows @ 359 < and if 1 bulletRows +! then
      KEY_LEFT IsKeyPressed KEY_A IsKeyPressed or  bulletRows @ 1 > and if -1 bulletRows +! then
      KEY_UP IsKeyPressed KEY_W IsKeyPressed or if bulletSpeed f@ 0.25e f+ bulletSpeed f! then
      KEY_DOWN IsKeyPressed KEY_S IsKeyPressed or  bulletSpeed f@ 0.50e f> and if
         bulletSpeed f@ 0.25e f- bulletSpeed f! then
      KEY_Z IsKeyPressed spawnCD f@ 1e f> and if spawnCD f@ 1e f- spawnCD f! then
      KEY_X IsKeyPressed if spawnCD f@ 1e f+ spawnCD f! then
      KEY_ENTER IsKeyPressed if perfMode @ 0= perfMode ! then
      KEY_SPACE down if angleInc @ 1+ 360 mod angleInc ! then
      KEY_C IsKeyPressed if 0 bulletCount ! 0 bulletDisabled ! then
      BeginDrawing
         RAYWHITE ClearBackground
         magicRot f@ 1e f+ magicRot f!
         screenWidth 2/ s>f screenHeight 2/ s>f 120e 120e rec Rectangle!
         60e 60e orig Vector2!
         rec orig magicRot f@ PURPLE DrawRectanglePro
         rec orig magicRot f@ 45e f+ PURPLE DrawRectanglePro
         screenWidth 2/ screenHeight 2/ 70e BLACK DrawCircleLines
         screenWidth 2/ screenHeight 2/ 50e BLACK DrawCircleLines
         screenWidth 2/ screenHeight 2/ 30e BLACK DrawCircleLines
         perfMode @ if
            bulletCount @ 0 > if
            bulletCount @ 0 do
               i b b.dis @ 0= if
                  bulletTex rtex
                  i b b.pos v2x bulletTex rtex.w s>f 0.5e f* f- f>s
                  i b b.pos v2y bulletTex rtex.h s>f 0.5e f* f- f>s
                  i b b.col @ DrawTexture
               then
            loop then
         else
            bulletCount @ 0 > if
            bulletCount @ 0 do
               i b b.dis @ 0= if
                  i b b.pos bulletRadius s>f i b b.col @ DrawCircleV
                  i b b.pos bulletRadius s>f BLACK DrawCircleLinesV
               then
            loop then
         then
         10 10 280 150 0 0 0 200 RGBA DrawRectangle
         z" Controls:" 20 20 10 LIGHTGRAY DrawText
         z" - Right/Left or A/D: Change rows number" 40 40 10 LIGHTGRAY DrawText
         z" - Up/Down or W/S: Change bullet speed" 40 60 10 LIGHTGRAY DrawText
         z" - Z or X: Change spawn cooldown" 40 80 10 LIGHTGRAY DrawText
         z" - Space (Hold): Change the angle increment" 40 100 10 LIGHTGRAY DrawText
         z" - Enter: Switch draw method (Performance)" 40 120 10 LIGHTGRAY DrawText
         z" - C: Clear bullets" 40 140 10 LIGHTGRAY DrawText
         610 10 170 30 0 0 0 200 RGBA DrawRectangle
         perfMode @ if
            z" Draw method: DrawTexture(*)" 620 20 10 GREEN DrawText
         else
            z" Draw method: DrawCircle(*)" 620 20 10 RED DrawText
         then
         135 410 530 30 0 0 0 200 RGBA DrawRectangle
         z" FPS/Bullets/Rows shown in FPS widget" 155 420 10 GREEN DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   bulletTex UnloadRenderTexture
   CloseWindow ;

example-end
