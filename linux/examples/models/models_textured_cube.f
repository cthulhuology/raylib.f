\ Port of raylib examples/models/models_textured_cube.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 10e 10e :Camera.position
   0e  0e  0e :Camera.target
   0e  1e  0e :Camera.up
   45e        :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE tex 32 ALLOT

\ Float globals reused by cube drawing helpers
0e fvalue cx   0e fvalue cy   0e fvalue cz
0e fvalue cw   0e fvalue ch   0e fvalue cl
0e fvalue stx  0e fvalue sty  0e fvalue stw  0e fvalue sth
0e fvalue stW  0e fvalue stH

\ DrawCubeTexture ( tex pos color F: width height length -- )
\ Draw cube with entire texture applied to each face using rlgl immediate mode.
\ Caller pushes width height length on fp stack, then tex pos color on data stack.
: DrawCubeTexture ( tex pos color F: width height length -- )
   locals| color pos tex |
   to cl  to ch  to cw
   pos .x to cx  pos .y to cy  pos .z to cz
   tex l@ rlSetTexture
   RL_QUADS rlBegin
      color .red  color .green  color .blue  color .alpha  rlColor4ub
      \ Front face  (normal 0 0 1)
      0e 0e 1e rlNormal3f
      0e 0e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      1e 0e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      1e 1e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      0e 1e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      \ Back face  (normal 0 0 -1)
      0e 0e -1e rlNormal3f
      1e 0e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      1e 1e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      0e 1e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      0e 0e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      \ Top face  (normal 0 1 0)
      0e 1e 0e rlNormal3f
      0e 1e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      0e 0e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      1e 0e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      1e 1e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      \ Bottom face  (normal 0 -1 0)
      0e -1e 0e rlNormal3f
      1e 1e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      0e 1e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      0e 0e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      1e 0e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      \ Right face  (normal 1 0 0)
      1e 0e 0e rlNormal3f
      1e 0e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      1e 1e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      0e 1e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      0e 0e rlTexCoord2f  cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      \ Left face  (normal -1 0 0)
      -1e 0e 0e rlNormal3f
      0e 0e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      1e 0e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      1e 1e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      0e 1e rlTexCoord2f  cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
   rlEnd
   0 rlSetTexture ;

\ DrawCubeTextureRec ( tex src pos color F: width height length -- )
\ Draw cube with a region of a texture applied to each face.
\ Caller pushes width height length on fp stack, then tex src pos color on data stack.
: DrawCubeTextureRec ( tex src pos color F: width height length -- )
   locals| color pos src tex |
   to cl  to ch  to cw
   tex l@ rlSetTexture
   tex tex.w s>f to stW  tex tex.h s>f to stH
   src rec.x to stx  src rec.y to sty  src rec.w to stw  src rec.h to sth
   pos .x to cx  pos .y to cy  pos .z to cz
   RL_QUADS rlBegin
      color .red  color .green  color .blue  color .alpha  rlColor4ub
      \ Front face
      0e 0e 1e rlNormal3f
      stx stW f/            sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      stx stw f+ stW f/     sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      stx stw f+ stW f/     sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      stx stW f/            sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      \ Back face
      0e 0e -1e rlNormal3f
      stx stw f+ stW f/     sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      stx stw f+ stW f/     sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      stx stW f/            sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      stx stW f/            sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      \ Top face
      0e 1e 0e rlNormal3f
      stx stW f/            sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      stx stW f/            sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      stx stw f+ stW f/     sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      stx stw f+ stW f/     sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      \ Bottom face
      0e -1e 0e rlNormal3f
      stx stw f+ stW f/     sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      stx stW f/            sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      stx stW f/            sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      stx stw f+ stW f/     sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      \ Right face
      1e 0e 0e rlNormal3f
      stx stw f+ stW f/     sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      stx stw f+ stW f/     sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
      stx stW f/            sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      stx stW f/            sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f+  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      \ Left face
      -1e 0e 0e rlNormal3f
      stx stW f/            sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f-  rlVertex3f
      stx stw f+ stW f/     sty sth f+ stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f-  cz cl 2e f/ f+  rlVertex3f
      stx stw f+ stW f/     sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f+  rlVertex3f
      stx stW f/            sty         stH f/  rlTexCoord2f
         cx cw 2e f/ f-  cy ch 2e f/ f+  cz cl 2e f/ f-  rlVertex3f
   rlEnd
   0 rlSetTexture ;

CREATE src  16 ALLOT
CREATE pos1 16 ALLOT
CREATE pos2 16 ALLOT

: example
   screenWidth screenHeight z" raylib [models] example - textured cube" InitWindow
   tex z" /home/dave/Code/raylib/examples/models/resources/cubicmap_atlas.png" LoadTexture drop
   -2e  2e 0e pos1 Vector3!
    2e  1e 0e pos2 Vector3!
   60 SetTargetFPS
   begin
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            \ DrawCubeTexture: F: width height length, then tex pos color
            2e 4e 2e  tex pos1 WHITE DrawCubeTexture
            \ Build source rect: x=0 y=tex.height/2 w=tex.width/2 h=tex.height/2
            0e  tex tex.h s>f 2e f/  tex tex.w s>f 2e f/  tex tex.h s>f 2e f/
            src Rectangle!
            \ DrawCubeTextureRec: F: width height length, then tex src pos color
            2e 2e 2e  tex src pos2 WHITE DrawCubeTextureRec
            10 1e DrawGrid
         EndMode3D
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   CloseWindow ;

example-end
