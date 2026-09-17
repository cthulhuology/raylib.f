\ Port of raylib examples/shaders/shaders_lightmap_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
10  CONSTANT MAP_SIZE

Camera: camera
   4e 6e 8e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE shd  32 ALLOT
CREATE mesh 120 ALLOT
CREATE mat  40 ALLOT
CREATE tex  20 ALLOT
CREATE light 20 ALLOT
CREATE rt   64 ALLOT
CREATE mxid 64 ALLOT

\ texcoords2 data: 4 vertices * 2 floats = 8 floats = 32 bytes
CREATE tc2  32 ALLOT

\ scratch rectangles and vectors for DrawTexturePro
CREATE src  16 ALLOT
CREATE dst  16 ALLOT

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shaders] example - lightmap rendering" InitWindow

   \ load shader
   shd z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/lightmap.vs"
       z" /home/dave/Code/raylib/examples/shaders/resources/shaders/glsl330/lightmap.fs"
       LoadShader drop

   \ generate plane mesh (10x10, 1x1 subdivisions)
   mesh MAP_SIZE s>f MAP_SIZE s>f 1 1 GenMeshPlane drop

   \ build texcoords2: 4 vertices, UV corners
   \ (0,0)  (1,0)  (0,1)  (1,1)
   0e tc2       sf!   0e tc2  4 + sf!
   1e tc2  8 + sf!   0e tc2 12 + sf!
   0e tc2 16 + sf!   1e tc2 20 + sf!
   1e tc2 24 + sf!   1e tc2 28 + sf!

   \ upload texcoords2 as a new vertex buffer and attach to the VAO
   tc2 8 4 * 0 rlLoadVertexBuffer           \ ( vbo-id )
   mesh 112 + @ SHADER_LOC_VERTEX_TEXCOORD02 4 * + l!   \ mesh.vboId[2] = vbo-id
   mesh 108 + l@ rlEnableVertexArray drop   \ enable VAO
   5 2 RL_FLOAT 0 0 0 rlSetVertexAttribute  \ attrib 5: 2 floats, not normalised
   5 rlEnableVertexAttribute
   rlDisableVertexArray

   \ load atlas texture and generate mipmaps
   tex z" /home/dave/Code/raylib/examples/shaders/resources/cubicmap_atlas.png" LoadTexture drop
   tex GenTextureMipmaps
   tex TEXTURE_FILTER_TRILINEAR SetTextureFilter

   \ load flame/light texture
   light z" /home/dave/Code/raylib/examples/shaders/resources/spark_flame.png" LoadTexture drop

   \ load lightmap render texture (MAP_SIZE x MAP_SIZE)
   rt MAP_SIZE MAP_SIZE LoadRenderTexture drop
   rt 4 + TEXTURE_FILTER_TRILINEAR SetTextureFilter

   \ create default material and assign shader + textures
   mat LoadMaterialDefault drop
   shd mat 16 move                         \ mat.shader = shd (Shader is 16 bytes)
   mat MATERIAL_MAP_ALBEDO    tex      SetMaterialTexture
   mat MATERIAL_MAP_METALNESS rt 4 +   SetMaterialTexture

   \ bake lightmap: draw lights into the render texture
   rt BeginTextureMode
      BLACK ClearBackground
      BLEND_ADDITIVE BeginBlendMode
         \ red light: pos (0,0) size 20x20 origin (10,10)
         0e 0e light tex.w s>f light tex.h s>f src Rectangle!
         0e 0e 20e 20e dst Rectangle!
         10e 10e origin2 Vector2!
         light src dst origin2 0e RED DrawTexturePro
         \ blue light: pos (8,4) size 20x20 origin (10,10)
         0e 0e light tex.w s>f light tex.h s>f src Rectangle!
         8e 4e 20e 20e dst Rectangle!
         10e 10e origin2 Vector2!
         light src dst origin2 0e BLUE DrawTexturePro
         \ green light: pos (8,8) size 10x10 origin (5,5)
         0e 0e light tex.w s>f light tex.h s>f src Rectangle!
         8e 8e 10e 10e dst Rectangle!
         5e 5e origin2 Vector2!
         light src dst origin2 0e GREEN DrawTexturePro
      BLEND_ALPHA BeginBlendMode
   EndTextureMode

   mxid MatrixIdentity drop

   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mesh mat mxid DrawMesh
         EndMode3D
         10 10 DrawFPS
         \ draw lightmap preview in top-right corner
         0e 0e MAP_SIZE s>f fnegate MAP_SIZE s>f fnegate src Rectangle!
         GetRenderWidth MAP_SIZE 8 * - 10 - s>f
         10e
         MAP_SIZE 8 * s>f
         MAP_SIZE 8 * s>f
         dst Rectangle!
         0e 0e origin2 Vector2!
         rt 4 + src dst origin2 0e WHITE DrawTexturePro
         z" lightmap"     GetRenderWidth 66 - 16 MAP_SIZE 8 * + 10 GRAY DrawText
         z" 10x10 pixels" GetRenderWidth 76 - 30 MAP_SIZE 8 * + 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until

   shd UnloadShader
   tex UnloadTexture
   light UnloadTexture
   rt UnloadRenderTexture
   mesh UnloadMesh
   CloseWindow ;

example-end
