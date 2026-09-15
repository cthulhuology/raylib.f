\ Port of raylib examples/textures/textures_polygon_drawing.c
\ Partial: no rlgl DrawTexturePoly; draws rotating texture + polygon outline.

800 CONSTANT screenWidth
450 CONSTANT screenHeight
11 CONSTANT MAX_POINTS

CREATE tex 32 ALLOT
CREATE texcoords MAX_POINTS 8 * ALLOT
CREATE points    MAX_POINTS 8 * ALLOT
CREATE positions MAX_POINTS 8 * ALLOT
CREATE center 16 ALLOT
CREATE pos 16 ALLOT
CREATE vcos 4 ALLOT
CREATE vsin 4 ALLOT
FVARIABLE angle

: v[] ( base i -- a ) 8 * + ;

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: example
   screenWidth screenHeight z" raylib [textures] example - polygon drawing" InitWindow
   0.75e 0.0e   texcoords 0 v[] Vector2!
   0.25e 0.0e   texcoords 1 v[] Vector2!
   0.0e  0.5e   texcoords 2 v[] Vector2!
   0.0e  0.75e  texcoords 3 v[] Vector2!
   0.25e 1.0e   texcoords 4 v[] Vector2!
   0.375e 0.875e texcoords 5 v[] Vector2!
   0.625e 0.875e texcoords 6 v[] Vector2!
   0.75e 1.0e   texcoords 7 v[] Vector2!
   1.0e  0.75e  texcoords 8 v[] Vector2!
   1.0e  0.5e   texcoords 9 v[] Vector2!
   0.75e 0.0e   texcoords 10 v[] Vector2!
   MAX_POINTS 0 do
      texcoords i v[] v2x 0.5e f- 256e f*
      texcoords i v[] v2y 0.5e f- 256e f*
      points i v[] Vector2!
   loop
   points positions MAX_POINTS 8 * move
   tex z" /home/dave/Code/raylib/examples/textures/resources/cat.png" LoadTexture drop
   0e angle f!
   60 SetTargetFPS
   begin
      angle f@ 1e f+ angle f!
      angle f@ deg>rad fdup fcos vcos sf! fsin vsin sf!
      MAX_POINTS 0 do
         points i v[] v2x vcos sf@ f*  points i v[] v2y vsin sf@ f* f-
         points i v[] v2y vcos sf@ f*  points i v[] v2x vsin sf@ f* f+
         positions i v[] Vector2!
      loop
      GetScreenWidth s>f 2e f/ GetScreenHeight s>f 2e f/ center Vector2!
      BeginDrawing
         RAYWHITE ClearBackground
         z" textured polygon" 20 20 20 DARKGRAY DrawText
         \ Fallback: rotate the source texture about the screen center
         tex texture_width l@ 2/ s>f fnegate tex texture_height l@ 2/ s>f fnegate
         center v2x f+ center v2y f+ pos Vector2!
         tex pos angle f@ 1e WHITE DrawTextureEx
         \ Polygon outline of rotated points
         MAX_POINTS 1- 0 do
            positions i v[] v2x center v2x f+ positions i v[] v2y center v2y f+ pos Vector2!
            positions i 1+ v[] v2x center v2x f+ positions i 1+ v[] v2y center v2y f+ v2a Vector2!
            pos v2a DARKGRAY DrawLineV
         loop
         z" Partial: rlgl DrawTexturePoly not bound; outline+textured sprite instead" 10 screenHeight 30 - 10 MAROON DrawText
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   CloseWindow ;

example-end
