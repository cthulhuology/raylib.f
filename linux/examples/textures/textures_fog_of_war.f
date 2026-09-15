\ Port of raylib examples/textures/textures_fog_of_war.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
32 CONSTANT MAP_TILE_SIZE
16 CONSTANT PLAYER_SIZE
2 CONSTANT PLAYER_TILE_VISIBILITY

25 CONSTANT tilesX
15 CONSTANT tilesY

CREATE tileIds tilesX tilesY * ALLOT
CREATE tileFog tilesX tilesY * ALLOT
CREATE playerPosition 16 ALLOT
CREATE fogOfWar 64 ALLOT
CREATE src 16 ALLOT
CREATE dst 16 ALLOT
CREATE origin 16 ALLOT
CREATE psz 16 ALLOT
VARIABLE playerTileX
VARIABLE playerTileY

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: n>z ( n -- z ) dup 0< if abs 1 else 0 then >r 0 <# #s r> if [char] - hold then #> zres ;

: example
   screenWidth screenHeight z" raylib [textures] example - fog of war" InitWindow
   tileIds tilesX tilesY * erase
   tileFog tilesX tilesY * erase
   tilesY tilesX * 0 do  0 1 GetRandomValue tileIds i + c!  loop
   180e 130e playerPosition Vector2!
   0 playerTileX !  0 playerTileY !
   fogOfWar tilesX tilesY LoadRenderTexture drop
   fogOfWar render_texture_texture TEXTURE_FILTER_BILINEAR SetTextureFilter
   0e 0e origin Vector2!
   60 SetTargetFPS
   begin
      KEY_RIGHT down if playerPosition v2x 5e f+ playerPosition v2y playerPosition Vector2! then
      KEY_LEFT  down if playerPosition v2x 5e f- playerPosition v2y playerPosition Vector2! then
      KEY_DOWN  down if playerPosition v2x playerPosition v2y 5e f+ playerPosition Vector2! then
      KEY_UP    down if playerPosition v2x playerPosition v2y 5e f- playerPosition Vector2! then
      playerPosition v2x f0< if 0e playerPosition v2y playerPosition Vector2! then
      playerPosition v2x PLAYER_SIZE s>f f+ tilesX MAP_TILE_SIZE * s>f f> if
         tilesX MAP_TILE_SIZE * PLAYER_SIZE - s>f playerPosition v2y playerPosition Vector2!
      then
      playerPosition v2y f0< if playerPosition v2x 0e playerPosition Vector2! then
      playerPosition v2y PLAYER_SIZE s>f f+ tilesY MAP_TILE_SIZE * s>f f> if
         playerPosition v2x tilesY MAP_TILE_SIZE * PLAYER_SIZE - s>f playerPosition Vector2!
      then
      tilesX tilesY * 0 do
         tileFog i + c@ 1 = if 2 tileFog i + c! then
      loop
      playerPosition v2x MAP_TILE_SIZE 2/ s>f f+ MAP_TILE_SIZE s>f f/ f>s playerTileX !
      playerPosition v2y MAP_TILE_SIZE 2/ s>f f+ MAP_TILE_SIZE s>f f/ f>s playerTileY !
      playerTileY @ PLAYER_TILE_VISIBILITY -  playerTileY @ PLAYER_TILE_VISIBILITY +  ?do
         playerTileX @ PLAYER_TILE_VISIBILITY -  playerTileX @ PLAYER_TILE_VISIBILITY +  ?do
            i 0< 0= i tilesX < and j 0< 0= and j tilesY < and if
               1 tileFog j tilesX * i + + c!
            then
         loop
      loop
      fogOfWar BeginTextureMode
         TRANSPARENT ClearBackground
         tilesY 0 do
            tilesX 0 do
               tileFog j tilesX * i + + c@
               dup 0 = if drop i j 1 1 BLACK DrawRectangle else
               2 = if i j 1 1 BLACK 0.8e Fade DrawRectangle else drop then then
            loop
         loop
      EndTextureMode
      BeginDrawing
         RAYWHITE ClearBackground
         tilesY 0 do
            tilesX 0 do
               i MAP_TILE_SIZE * j MAP_TILE_SIZE * MAP_TILE_SIZE MAP_TILE_SIZE
               tileIds j tilesX * i + + c@ 0= if BLUE else BLUE 0.9e Fade then DrawRectangle
               i MAP_TILE_SIZE * j MAP_TILE_SIZE * MAP_TILE_SIZE MAP_TILE_SIZE DARKBLUE 0.5e Fade DrawRectangleLines
            loop
         loop
         PLAYER_SIZE s>f PLAYER_SIZE s>f psz Vector2!
         playerPosition psz RED DrawRectangleV
         0e 0e fogOfWar render_texture_texture texture_width l@ s>f
         fogOfWar render_texture_texture texture_height l@ s>f fnegate src Rec!
         0e 0e tilesX MAP_TILE_SIZE * s>f tilesY MAP_TILE_SIZE * s>f dst Rec!
         fogOfWar render_texture_texture src dst origin 0e WHITE DrawTexturePro
         z" Current tile: [" 10 10 20 RAYWHITE DrawText
         playerTileX @ n>z 160 10 20 RAYWHITE DrawText
         z" ," 190 10 20 RAYWHITE DrawText
         playerTileY @ n>z 210 10 20 RAYWHITE DrawText
         z" ]" 240 10 20 RAYWHITE DrawText
         z" ARROW KEYS to move" 10 screenHeight 25 - 20 RAYWHITE DrawText
      EndDrawing
   WindowShouldClose until
   fogOfWar UnloadRenderTexture
   CloseWindow ;

example-end
