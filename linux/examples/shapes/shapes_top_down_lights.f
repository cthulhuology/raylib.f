\ Port of raylib examples/shapes/shapes_top_down_lights.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

20  CONSTANT MAX_BOXES
60  CONSTANT MAX_SHADOWS       \ MAX_BOXES * 3
16  CONSTANT MAX_LIGHTS

\ LightInfo struct layout (per light):
\   +0   active       cell (4 bytes)
\   +4   dirty        cell (4 bytes)
\   +8   valid        cell (4 bytes)
\  +12   position     Vector2  (8 bytes)
\  +20   mask         RenderTexture (44 bytes)
\  +64   outerRadius  float (4 bytes)
\  +68   bounds       Rectangle (16 bytes)
\  +84   shadowCount  cell (4 bytes)
\  +88   shadows      MAX_SHADOWS * 32 bytes  (each = 4 * Vector2 = 32)
\ Total per light = 88 + 60*32 = 2008 bytes

2008 CONSTANT /LIGHT
  88 CONSTANT SHADOW_OFF      \ offset to shadows[] array
  32 CONSTANT /SHADOW         \ bytes per ShadowGeometry (4 Vector2)

CREATE lights[] MAX_LIGHTS /LIGHT * ALLOT
CREATE boxes MAX_BOXES 16 * ALLOT
VARIABLE boxCount
VARIABLE nextLight
VARIABLE showLines
VARIABLE dirtyLights

\ Scratch Vector2 buffers for math
CREATE (spv) 8 ALLOT
CREATE (epv) 8 ALLOT
CREATE (tmp) 8 ALLOT

\ Scratch Rectangle for drawing
CREATE lmrec 16 ALLOT

\ Background image/texture
CREATE img 24 ALLOT
CREATE bgtex 20 ALLOT

\ Global light mask render texture
CREATE lightMask 48 ALLOT

\ -------------------------------------------------------
\ Light accessors  ( slot -- addr )
\ -------------------------------------------------------
: li ( slot -- a )  /LIGHT * lights[] + ;
: L.active     ( a -- a )  ;
: L.dirty      ( a -- a )  4 + ;
: L.valid      ( a -- a )  8 + ;
: L.position   ( a -- a )  12 + ;
: L.mask       ( a -- a )  20 + ;
: L.outerRadius ( a -- a )  64 + ;
: L.bounds     ( a -- a )  68 + ;
: L.shadowCount ( a -- a )  84 + ;
: L.shadows    ( a -- a )  88 + ;

\ Shadow[i] address within a light (a = light base addr)
: shadow@ ( a i -- sa )  /SHADOW * + L.shadows ;
\ Vertex[j] address within a shadow
: sv@ ( sa j -- va )  8 * + ;

\ -------------------------------------------------------
\ SetupBoxes
\ -------------------------------------------------------
: setup-boxes ( -- )
   150e  80e 40e 40e  0 boxes 16 * + Rectangle!
   1200e 700e 40e 40e  1 boxes 16 * + Rectangle!
   200e  600e 40e 40e  2 boxes 16 * + Rectangle!
   1000e  50e 40e 40e  3 boxes 16 * + Rectangle!
   500e  350e 40e 40e  4 boxes 16 * + Rectangle!
   MAX_BOXES 5 do
      0 GetScreenWidth  GetRandomValue s>f
      0 GetScreenHeight GetRandomValue s>f
      10 100 GetRandomValue s>f
      10 100 GetRandomValue s>f
      i boxes 16 * + Rectangle!
   loop
   MAX_BOXES boxCount ! ;

\ -------------------------------------------------------
\ MoveLight ( slot F: x y -- )
\ -------------------------------------------------------
FVARIABLE (ml-x)  FVARIABLE (ml-y)

: MoveLight ( slot F: x y -- )
   locals| slot |
   (ml-y) f!  (ml-x) f!               \ save x, y
   (ml-x) f@  (ml-y) f@  slot li L.position Vector2!
   (ml-x) f@ slot li L.outerRadius sf@ f- slot li L.bounds sf!
   (ml-y) f@ slot li L.outerRadius sf@ f- slot li L.bounds 4 + sf!
   true slot li L.dirty ! ;

\ -------------------------------------------------------
\ ComputeShadowVolumeForEdge ( slot sp ep -- )
\   sp, ep are Vector2 addresses
\ -------------------------------------------------------
FVARIABLE (ext)

: ComputeShadowVolumeForEdge ( slot sp ep -- )
   locals| ep sp slot |
   slot li L.shadowCount @ MAX_SHADOWS >= if exit then

   \ extension = outerRadius * 2
   slot li L.outerRadius sf@ 2e f* (ext) f!

   \ spVector = Normalize(sp - light.position), store in (tmp)
   (tmp) sp slot li L.position Vector2Subtract drop
   (spv) (tmp) Vector2Normalize drop
   \ spProjection = sp + spVector * extension, store in (spv)
   (spv) v2x (ext) f@ f*  sp v2x f+
   (spv) v2y (ext) f@ f*  sp v2y f+
   (spv) Vector2!                          \ spProjection in (spv)

   \ epVector = Normalize(ep - light.position), store in (tmp)
   (tmp) ep slot li L.position Vector2Subtract drop
   (epv) (tmp) Vector2Normalize drop
   \ epProjection = ep + epVector * extension, store in (epv)
   (epv) v2x (ext) f@ f*  ep v2x f+
   (epv) v2y (ext) f@ f*  ep v2y f+
   (epv) Vector2!                          \ epProjection in (epv)

   \ Write shadow quad: sc = current shadow index
   slot li L.shadowCount @               \ sc
   slot li swap shadow@                  \ sa = &lights[slot].shadows[sc]
   sp   over 0 sv@  8 move              \ vertices[0] = sp
   ep   over 1 sv@  8 move              \ vertices[1] = ep
   (epv) over 2 sv@  8 move             \ vertices[2] = epProjection
   (spv) over 3 sv@  8 move             \ vertices[3] = spProjection
   drop
   1 slot li L.shadowCount +! ;

\ -------------------------------------------------------
\ DrawLightMask ( slot -- )
\ -------------------------------------------------------
CREATE (wpt) 8 ALLOT   \ scratch for white position

: DrawLightMask ( slot -- )
   locals| slot |
   slot li L.mask BeginTextureMode

      WHITE ClearBackground

      \ Force blend to only set alpha of destination (MIN)
      RLGL_SRC_ALPHA RLGL_SRC_ALPHA RLGL_MIN rlSetBlendFactors
      BLEND_CUSTOM rlSetBlendMode

      \ If valid, draw light radius as alpha gradient
      slot li L.valid @ if
         slot li L.position v2x f>s
         slot li L.position v2y f>s
         slot li L.outerRadius sf@
         WHITE 0e ColorAlpha    \ inner = transparent white
         WHITE                  \ outer = opaque white
         DrawCircleGradient
      then

      rlDrawRenderBatchActive

      \ Switch to MAX blend to cut out shadows (force alpha to 1)
      BLEND_ALPHA rlSetBlendMode
      RLGL_SRC_ALPHA RLGL_SRC_ALPHA RLGL_MAX rlSetBlendFactors
      BLEND_CUSTOM rlSetBlendMode

      \ Draw each shadow quad as a triangle fan
      slot li L.shadowCount @ 0 do
         slot li i shadow@   4   WHITE DrawTriangleFan
      loop

      rlDrawRenderBatchActive

      \ Back to normal
      BLEND_ALPHA rlSetBlendMode

   EndTextureMode ;

\ -------------------------------------------------------
\ SetupLight ( slot F: x y radius -- )
\ -------------------------------------------------------
: SetupLight ( slot F: x y radius -- )
   locals| slot |
   fdup slot li L.outerRadius sf!      \ store outerRadius (F: x y r)
   \ bounds.width = radius*2, bounds.height = radius*2
   fdup 2e f*  slot li L.bounds 8 + sf!
   fdup 2e f*  slot li L.bounds 12 + sf!
   fdrop                                \ F: x y  (r consumed)
   true  slot li L.active !
   false slot li L.valid !
   0     slot li L.shadowCount !
   \ Load render texture for this light's mask
   slot li L.mask GetScreenWidth GetScreenHeight LoadRenderTexture drop
   slot MoveLight                       \ sets position + dirty (consumes F: x y)
   slot DrawLightMask ;                 \ initial draw

\ -------------------------------------------------------
\ UpdateLight ( slot boxes count -- dirty? )
\ -------------------------------------------------------
CREATE (sp2) 8 ALLOT
CREATE (ep2) 8 ALLOT
VARIABLE (boxptr)   \ current box address (avoids r-stack conflicts)

: UpdateLight ( slot boxes count -- dirty? )
   locals| count boxes slot |
   slot li L.active @ 0= slot li L.dirty @ 0= or if false exit then

   false slot li L.dirty !
   0     slot li L.shadowCount !
   false slot li L.valid !
   count 0 do
      boxes i 16 * + (boxptr) !

      \ Check if light is inside this box -> not valid, return false
      slot li L.position  (boxptr) @  CheckCollisionPointRec if
         false exit
      then

      \ Only process boxes that overlap the light bounds
      slot li L.bounds  (boxptr) @  CheckCollisionRecs if

         \ Top edge: sp=(x,y)  ep=(x+w,y)
         (boxptr) @ rec.x  (boxptr) @ rec.y  (sp2) Vector2!
         (boxptr) @ rec.x (boxptr) @ rec.w f+  (boxptr) @ rec.y  (ep2) Vector2!
         slot li L.position v2y (ep2) v2y f> if slot (sp2) (ep2) ComputeShadowVolumeForEdge then

         \ Right edge: sp=ep_prev  ep=(x+w,y+h)
         (ep2) (sp2) 8 move
         (boxptr) @ rec.x (boxptr) @ rec.w f+  (boxptr) @ rec.y (boxptr) @ rec.h f+  (ep2) Vector2!
         slot li L.position v2x (ep2) v2x f< if slot (sp2) (ep2) ComputeShadowVolumeForEdge then

         \ Bottom edge: sp=ep_prev  ep=(x,y+h)
         (ep2) (sp2) 8 move
         (boxptr) @ rec.x  (boxptr) @ rec.y (boxptr) @ rec.h f+  (ep2) Vector2!
         slot li L.position v2y (ep2) v2y f< if slot (sp2) (ep2) ComputeShadowVolumeForEdge then

         \ Left edge: sp=ep_prev  ep=(x,y)
         (ep2) (sp2) 8 move
         (boxptr) @ rec.x  (boxptr) @ rec.y  (ep2) Vector2!
         slot li L.position v2x (ep2) v2x f> if slot (sp2) (ep2) ComputeShadowVolumeForEdge then

         \ The box itself as a shadow quad: (x,y),(x,y+h),(x+w,y+h),(x+w,y)
         slot li L.shadowCount @ MAX_SHADOWS < if
            slot li L.shadowCount @  slot li swap shadow@    \ sa
            (boxptr) @ rec.x  (boxptr) @ rec.y
            dup 0 sv@ Vector2!
            (boxptr) @ rec.x  (boxptr) @ rec.y (boxptr) @ rec.h f+
            dup 1 sv@ Vector2!
            (boxptr) @ rec.x (boxptr) @ rec.w f+  (boxptr) @ rec.y (boxptr) @ rec.h f+
            dup 2 sv@ Vector2!
            (boxptr) @ rec.x (boxptr) @ rec.w f+  (boxptr) @ rec.y
            dup 3 sv@ Vector2!
            drop
            1 slot li L.shadowCount +!
         then

      then
   loop

   true  slot li L.valid !
   slot DrawLightMask
   true ;

\ -------------------------------------------------------
\ Main example
\ -------------------------------------------------------
: example
   screenWidth screenHeight z" raylib [shapes] example - top down lights" InitWindow

   setup-boxes

   \ Checkerboard background texture
   img 64 64 32 32 DARKBROWN DARKGRAY GenImageChecked drop
   bgtex img LoadTextureFromImage drop
   img UnloadImage

   \ Global light mask
   lightMask GetScreenWidth GetScreenHeight LoadRenderTexture drop

   \ Setup first light
   0 nextLight !
   0  600e 400e 300e SetupLight
   1 nextLight !

   false showLines !
   60 SetTargetFPS

   begin
      \ Drag light 0 with left mouse button
      MOUSE_BUTTON_LEFT IsMouseButtonDown if
         mouse@ v2x mouse@ v2y  0 MoveLight
      then

      \ Add new light with right mouse button
      MOUSE_BUTTON_RIGHT IsMouseButtonPressed nextLight @ MAX_LIGHTS < and if
         nextLight @  mouse@ v2x  mouse@ v2y  200e SetupLight
         1 nextLight +!
      then

      \ Toggle debug lines
      KEY_F1 IsKeyPressed if showLines @ 0= showLines ! then

      \ Update all lights, track if any were dirty
      false dirtyLights !
      MAX_LIGHTS 0 do
         i boxes boxCount @ UpdateLight if true dirtyLights ! then
      loop

      \ Rebuild global light mask if any light changed
      dirtyLights @ if
         lightMask BeginTextureMode

            BLACK ClearBackground

            \ Blend mode: only set alpha of destination (MIN)
            RLGL_SRC_ALPHA RLGL_SRC_ALPHA RLGL_MIN rlSetBlendFactors
            BLEND_CUSTOM rlSetBlendMode

            \ Merge all active light masks (flipped Y for render texture)
            MAX_LIGHTS 0 do
               i li L.active @ if
                  i li L.mask rtex
                  i li L.mask lmrec flip-rt
                  origin2 WHITE DrawTextureRec
               then
            loop

            rlDrawRenderBatchActive

            \ Back to normal blend
            BLEND_ALPHA rlSetBlendMode

         EndTextureMode
      then

      BeginDrawing
         BLACK ClearBackground

         \ Draw tile background (full screen): src rect covers whole texture
         0e 0e GetScreenWidth s>f GetScreenHeight s>f reca Rectangle!
         bgtex reca origin2 WHITE DrawTextureRec

         \ Overlay global light mask (flipped Y)
         showLines @ if 0.75e else 1.0e then
         WHITE ColorAlpha >r
         lightMask rtex
         lightMask lmrec flip-rt
         origin2 r> DrawTextureRec

         \ Draw light position markers
         MAX_LIGHTS 0 do
            i li L.active @ if
               i li L.position v2x f>s
               i li L.position v2y f>s
               10e
               i 0 = if YELLOW else WHITE then
               DrawCircle
            then
         loop

         \ Debug: show shadow volumes for light 0
         showLines @ if
            0 li L.shadowCount @ 0 do
               0 li i shadow@   4   DARKPURPLE DrawTriangleFan
            loop

            boxCount @ 0 do
               boxes i 16 * + >r
               r@  0 li L.bounds CheckCollisionRecs if
                  r@  PURPLE DrawRectangleRec
               then
               r@ rec.x f>s  r@ rec.y f>s  r@ rec.w f>s  r@ rec.h f>s
               DARKBLUE DrawRectangleLines
               r> drop
            loop

            z" (F1) Hide Shadow Volumes" 10 50 10 GREEN DrawText
         else
            z" (F1) Show Shadow Volumes" 10 50 10 GREEN DrawText
         then

         screenWidth 80 - 10 DrawFPS
         z" Drag to move light #1" 10 10 10 DARKGREEN DrawText
         z" Right click to add new light" 10 30 10 DARKGREEN DrawText
      EndDrawing
   WindowShouldClose until

   \ Cleanup
   bgtex UnloadTexture
   lightMask UnloadRenderTexture
   MAX_LIGHTS 0 do
      i li L.active @ if i li L.mask UnloadRenderTexture then
   loop
   CloseWindow ;

example-end
