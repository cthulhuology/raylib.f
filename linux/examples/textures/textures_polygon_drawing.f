\ Port of raylib examples/textures/textures_polygon_drawing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
11  CONSTANT MAX_POINTS

CREATE tex       32 ALLOT
CREATE texcoords MAX_POINTS 8 * ALLOT
CREATE points    MAX_POINTS 8 * ALLOT
CREATE positions MAX_POINTS 8 * ALLOT
CREATE center    8 ALLOT
FVARIABLE angle

: v[] ( base i -- a ) 8 * + ;

\ Draw textured polygon using rl* primitives.
\ ( positions texcoords pointCount ctr -- )
\ ctr is address of a Vector2 holding the center screen position.
: DrawTexturePoly ( positions texcoords pointCount ctr -- )
   locals| ctr cnt tcs pts |
   cnt 1- 0 do
      0.5e 0.5e rlTexCoord2f
      ctr sf@ ctr 4 + sf@ rlVertex2f
      tcs i v[] sf@      tcs i v[] 4 + sf@      rlTexCoord2f
      pts i v[] sf@ ctr sf@ f+  pts i v[] 4 + sf@ ctr 4 + sf@ f+  rlVertex2f
      tcs i 1+ v[] sf@   tcs i 1+ v[] 4 + sf@   rlTexCoord2f
      pts i 1+ v[] sf@ ctr sf@ f+  pts i 1+ v[] 4 + sf@ ctr 4 + sf@ f+  rlVertex2f
   loop ;

: example
   screenWidth screenHeight z" raylib [textures] example - polygon drawing" InitWindow
   0.75e 0.0e    texcoords 0 v[] Vector2!
   0.25e 0.0e    texcoords 1 v[] Vector2!
   0.0e  0.5e    texcoords 2 v[] Vector2!
   0.0e  0.75e   texcoords 3 v[] Vector2!
   0.25e 1.0e    texcoords 4 v[] Vector2!
   0.375e 0.875e texcoords 5 v[] Vector2!
   0.625e 0.875e texcoords 6 v[] Vector2!
   0.75e 1.0e    texcoords 7 v[] Vector2!
   1.0e  0.75e   texcoords 8 v[] Vector2!
   1.0e  0.5e    texcoords 9 v[] Vector2!
   0.75e 0.0e    texcoords 10 v[] Vector2!
   MAX_POINTS 0 do
      texcoords i v[] sf@      0.5e f- 256e f*
      texcoords i v[] 4 + sf@  0.5e f- 256e f*
      points i v[] Vector2!
   loop
   points positions MAX_POINTS 8 * move
   tex z" /home/dave/Code/raylib/examples/textures/resources/cat.png" LoadTexture drop
   0e angle f!
   60 SetTargetFPS
   begin
      angle f@ 1e f+ angle f!
      MAX_POINTS 0 do
         positions i v[] points i v[] angle f@ deg>rad Vector2Rotate drop
      loop
      GetScreenWidth s>f 2e f/ GetScreenHeight s>f 2e f/ center Vector2!
      BeginDrawing
         RAYWHITE ClearBackground
         z" textured polygon" 20 20 20 DARKGRAY DrawText
         tex l@ rlSetTexture
         RL_TRIANGLES rlBegin
            255 255 255 255 rlColor4ub
            positions texcoords MAX_POINTS center DrawTexturePoly
         rlEnd
         0 rlSetTexture
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   CloseWindow ;

example-end
