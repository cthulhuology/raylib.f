\ Port of raylib examples/textures/textures_npatch_drawing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE nPatchTexture 32 ALLOT
CREATE origin 16 ALLOT
CREATE dstRec1 16 ALLOT
CREATE dstRec2 16 ALLOT
CREATE dstRecH 16 ALLOT
CREATE dstRecV 16 ALLOT
CREATE ninePatchInfo1 48 ALLOT
CREATE ninePatchInfo2 48 ALLOT
CREATE h3PatchInfo 48 ALLOT
CREATE v3PatchInfo 48 ALLOT

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: NPatch! ( F: x y w h  left top right bottom layout np -- )
   >r
   r@ Rec!
   r@ npatchinfo_layer l!
   r@ npatchinfo_bottom l!
   r@ npatchinfo_right l!
   r@ npatchinfo_top l!
   r> npatchinfo_left l! ;

: rec-w! ( rec F: w -- ) 8 + sf! ;
: rec-h! ( rec F: h -- ) 12 + sf! ;
: rec-x ( rec -- ) ( F: -- x ) sf@ ;
: rec-y ( rec -- ) ( F: -- y ) 4 + sf@ ;

: clamp1-300 ( F: v -- v )
   fdup 1e f< if fdrop 1e then
   fdup 300e f> if fdrop 300e then ;

: clamp1 ( F: v -- v )
   fdup 1e f< if fdrop 1e then ;

: example
   screenWidth screenHeight z" raylib [textures] example - npatch drawing" InitWindow
   nPatchTexture z" /home/dave/Code/raylib/examples/textures/resources/ninepatch_button.png" LoadTexture drop
   0e 0e origin Vector2!
   480e 160e 32e 32e dstRec1 Rec!
   160e 160e 32e 32e dstRec2 Rec!
   160e 93e 32e 32e dstRecH Rec!
   92e 160e 32e 32e dstRecV Rec!
   0e 0e 64e 64e 12 40 12 12 NPATCH_NINE_PATCH ninePatchInfo1 NPatch!
   0e 128e 64e 64e 16 16 16 16 NPATCH_NINE_PATCH ninePatchInfo2 NPatch!
   0e 64e 64e 64e 8 8 8 8 NPATCH_THREE_PATCH_HORIZONTAL h3PatchInfo NPatch!
   0e 192e 64e 64e 6 6 6 6 NPATCH_THREE_PATCH_VERTICAL v3PatchInfo NPatch!
   60 SetTargetFPS
   begin
      mouse@ v2x dstRec1 rec-x f- clamp1-300 dstRec1 rec-w!
      mouse@ v2y dstRec1 rec-y f- clamp1 dstRec1 rec-h!
      mouse@ v2x dstRec2 rec-x f- clamp1-300 dstRec2 rec-w!
      mouse@ v2y dstRec2 rec-y f- clamp1 dstRec2 rec-h!
      mouse@ v2x dstRecH rec-x f- clamp1 dstRecH rec-w!
      mouse@ v2y dstRecV rec-y f- clamp1 dstRecV rec-h!
      BeginDrawing
         RAYWHITE ClearBackground
         nPatchTexture ninePatchInfo2 dstRec2 origin 0e WHITE DrawTextureNPatch
         nPatchTexture ninePatchInfo1 dstRec1 origin 0e WHITE DrawTextureNPatch
         nPatchTexture h3PatchInfo dstRecH origin 0e WHITE DrawTextureNPatch
         nPatchTexture v3PatchInfo dstRecV origin 0e WHITE DrawTextureNPatch
         5 88 74 266 BLUE DrawRectangleLines
         nPatchTexture 10 93 WHITE DrawTexture
         z" TEXTURE" 15 360 10 DARKGRAY DrawText
         z" Move the mouse to stretch or shrink the n-patches" 10 20 20 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   nPatchTexture UnloadTexture
   CloseWindow ;

example-end
