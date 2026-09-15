\ Port of raylib examples/audio/audio_sound_positioning.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 5e 5e :Camera.position
   0e 0e 0e :Camera.target
   0e 1e 0e :Camera.up
   60e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE sound 48 ALLOT
CREATE spherePos 16 ALLOT

: SetSoundPosition ( cam snd pos -- ) ( F: maxDist -- )
   locals| pos snd cam |
   v3a pos cam Camera.position Vector3Subtract drop
   v3a Vector3Length
   fswap f/ 1e f+ 1e fswap f/  0e 1e ClampF
   v3b v3a Vector3Normalize drop
   v3c cam Camera.target cam Camera.position Vector3Subtract drop
   v3c dup Vector3Normalize drop
   v3d cam Camera.up v3c Vector3Cross drop
   v3d dup Vector3Normalize drop
   v3c v3b Vector3DotProduct
   fdup 0e f< if  0.5e f* 1e f+ f*  else  fdrop  then
   v3b v3d Vector3DotProduct 0.5e f* 0.5e f+
   fswap
   snd SetSoundVolume
   snd SetSoundPan ;

: example
   screenWidth screenHeight z" raylib [audio] example - sound positioning" InitWindow
   InitAudioDevice
   sound z" /home/dave/Code/raylib/examples/audio/resources/coin.wav" LoadSound drop
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FREE UpdateCamera
      GetTime fdup fcos 5e f*  0e  fswap fsin 5e f* spherePos Vector3!
      camera sound spherePos 20e SetSoundPosition
      sound IsSoundPlaying 0= if sound PlaySound then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            spherePos 0.5e RED DrawSphere
            10 1e DrawGrid
         EndMode3D
         z" Coin sound follows the red sphere" 10 10 20 DARKGRAY DrawText
         10 40 DrawFPS
      EndDrawing
   WindowShouldClose until
   sound UnloadSound
   CloseAudioDevice
   CloseWindow ;

example-end
