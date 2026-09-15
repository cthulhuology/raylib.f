\ Port of raylib examples/core/core_window_letterbox.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

640 CONSTANT gameScreenWidth
480 CONSTANT gameScreenHeight

CREATE target 44 ALLOT
CREATE colors 10 CELLS ALLOT
CREATE vmouse 8 ALLOT
CREATE src 16 ALLOT
CREATE dst 16 ALLOT
CREATE origin 8 ALLOT
0e fvalue scale

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: rand-colors
   10 0 ?do
      100 250 GetRandomValue  50 150 GetRandomValue  10 100 GetRandomValue  255 RGBA
      i CELLS colors + !
   loop ;

: example
   FLAG_WINDOW_RESIZABLE FLAG_VSYNC_HINT or SetConfigFlags
   screenWidth screenHeight z" raylib [core] example - window letterbox" InitWindow
   320 240 SetWindowMinSize
   target gameScreenWidth gameScreenHeight LoadRenderTexture drop
   target 4 + TEXTURE_FILTER_BILINEAR SetTextureFilter
   rand-colors
   0e 0e origin Vector2!
   60 SetTargetFPS
   begin
      GetScreenWidth s>f gameScreenWidth s>f f/
      GetScreenHeight s>f gameScreenHeight s>f f/
      fmin to scale
      KEY_SPACE IsKeyPressed 1 and if rand-colors then
      mouse@ v2x  GetScreenWidth s>f gameScreenWidth s>f scale f* f- 2e f/ f-  scale f/
      mouse@ v2y  GetScreenHeight s>f gameScreenHeight s>f scale f* f- 2e f/ f-  scale f/
      vmouse Vector2!
      vmouse v2x 0e fmax gameScreenWidth s>f fmin
      vmouse v2y 0e fmax gameScreenHeight s>f fmin
      vmouse Vector2!
      target BeginTextureMode
         RAYWHITE ClearBackground
         10 0 ?do
            0  gameScreenHeight 10 / i *  gameScreenWidth  gameScreenHeight 10 /  i CELLS colors + @ DrawRectangle
         loop
         z" If executed inside a window," 10 25 20 WHITE DrawText
         z" you can resize the window," 10 50 20 WHITE DrawText
         z" and see the screen scaling!" 10 75 20 WHITE DrawText
         z" Default Mouse: " 350 25 20 GREEN DrawText
         mouse@ v2x f>s n>z 520 25 20 GREEN DrawText
         z" Virtual Mouse: " 350 55 20 YELLOW DrawText
         vmouse v2x f>s n>z 520 55 20 YELLOW DrawText
      EndTextureMode
      BeginDrawing
         BLACK ClearBackground
         0e 0e
         target 8 + l@ s>f
         target 12 + l@ s>f fnegate
         src Rectangle!
         GetScreenWidth s>f gameScreenWidth s>f scale f* f- 2e f/
         GetScreenHeight s>f gameScreenHeight s>f scale f* f- 2e f/
         gameScreenWidth s>f scale f*
         gameScreenHeight s>f scale f*
         dst Rectangle!
         target 4 + src dst origin 0e WHITE DrawTexturePro
      EndDrawing
   WindowShouldClose until
   target UnloadRenderTexture
   CloseWindow ;

example-end
