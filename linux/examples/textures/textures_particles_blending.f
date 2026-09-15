\ Port of raylib examples/textures/textures_particles_blending.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
200 CONSTANT MAX_PARTICLES

\ Particle: pos(8) color(4) pad(4) alpha(4) size(4) rotation(4) active(4) = 32
32 CONSTANT /particle
CREATE mouseTail MAX_PARTICLES /particle * ALLOT
CREATE smoke 32 ALLOT
CREATE src 16 ALLOT
CREATE dst 16 ALLOT
CREATE origin 16 ALLOT
FVARIABLE gravity
VARIABLE blending

: p[] ( i -- a ) /particle * mouseTail + ;
: ppos ( a -- a ) ;
: pcol ( a -- a ) 8 + ;
: palpha ( a -- a ) 16 + ;
: psize ( a -- a ) 20 + ;
: prot  ( a -- a ) 24 + ;
: pact  ( a -- a ) 28 + ;

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   screenWidth screenHeight z" raylib [textures] example - particles blending" InitWindow
   MAX_PARTICLES 0 do
      i p[] >r
      0e 0e r@ ppos Vector2!
      0 255 GetRandomValue 0 255 GetRandomValue 0 255 GetRandomValue 255 RGBA r@ pcol l!
      1e r@ palpha sf!
      1 30 GetRandomValue s>f 20e f/ r@ psize sf!
      0 360 GetRandomValue s>f r@ prot sf!
      0 r> pact l!
   loop
   3e gravity f!
   smoke z" /home/dave/Code/raylib/examples/textures/resources/spark_flame.png" LoadTexture drop
   BLEND_ALPHA blending !
   60 SetTargetFPS
   begin
      MAX_PARTICLES 0 do
         i p[] pact l@ 0= if
            1 i p[] pact l!
            1e i p[] palpha sf!
            mouse@ i p[] ppos 8 move
            leave
         then
      loop
      MAX_PARTICLES 0 do
         i p[] pact l@ if
            i p[] ppos v2x  i p[] ppos v2y gravity f@ 2e f/ f+  i p[] ppos Vector2!
            i p[] palpha sf@ 0.005e f- i p[] palpha sf!
            i p[] palpha sf@ f0< i p[] palpha sf@ f0= or if 0 i p[] pact l! then
            i p[] prot sf@ 2e f+ i p[] prot sf!
         then
      loop
      KEY_SPACE IsKeyPressed if
         blending @ BLEND_ALPHA = if BLEND_ADDITIVE else BLEND_ALPHA then blending !
      then
      BeginDrawing
         DARKGRAY ClearBackground
         blending @ BeginBlendMode
            MAX_PARTICLES 0 do
               i p[] pact l@ if
                  0e 0e smoke texture_width l@ s>f smoke texture_height l@ s>f src Rec!
                  i p[] ppos v2x i p[] ppos v2y
                  smoke texture_width l@ s>f i p[] psize sf@ f*
                  smoke texture_height l@ s>f i p[] psize sf@ f*
                  dst Rec!
                  dst 8 + sf@ 2e f/ dst 12 + sf@ 2e f/ origin Vector2!
                  smoke src dst origin i p[] prot sf@  i p[] pcol l@ i p[] palpha sf@ Fade DrawTexturePro
               then
            loop
         EndBlendMode
         z" PRESS SPACE to CHANGE BLENDING MODE" 180 20 20 BLACK DrawText
         blending @ BLEND_ALPHA = if
            z" ALPHA BLENDING" 290 screenHeight 40 - 20 BLACK DrawText
         else
            z" ADDITIVE BLENDING" 280 screenHeight 40 - 20 RAYWHITE DrawText
         then
      EndDrawing
   WindowShouldClose until
   smoke UnloadTexture
   CloseWindow ;

example-end
