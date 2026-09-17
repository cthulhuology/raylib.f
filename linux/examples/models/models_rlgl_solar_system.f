\ Port of raylib examples/models/models_rlgl_solar_system.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
4e   fconstant sunRadius
0.6e fconstant earthRadius
8e   fconstant earthOrbitRadius
0.16e fconstant moonRadius
1.5e fconstant moonOrbitRadius

Camera: camera
   16e 16e 16e :Camera.position
   0e  0e  0e  :Camera.target
   0e  1e  0e  :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE earthRot    4 ALLOT
CREATE earthOrbit  4 ALLOT
CREATE moonRot     4 ALLOT
CREATE moonOrbit   4 ALLOT
0.2e fconstant rotationSpeed

\ Pre-allocated Vector3 buffers for DrawCircle3D arguments
0e 0e 0e Vector3: circleCenter
1e 0e 0e Vector3: circleAxis

\ Sphere rendering state (used by DrawSphereBasic)
VARIABLE sph-i
VARIABLE sph-j
FVARIABLE sph-clat0
FVARIABLE sph-slat0
FVARIABLE sph-clat1
FVARIABLE sph-slat1
FVARIABLE sph-clon0
FVARIABLE sph-slon0
FVARIABLE sph-clon1
FVARIABLE sph-slon1

\ Emit one rlVertex3f at (lat_idx, lon_idx) using stored cos/sin values.
\ ( lat_sin lat_cos lon_sin lon_cos -- )  all on F stack would be awkward;
\ instead we call this with the four FVARIABLEs already filled.
\
\ vertex(clat, slat, clon, slon): x=clat*slon  y=slat  z=clat*clon
: sphere-v0j ( -- )   sph-clat0 f@ sph-slon0 f@ f*
                       sph-slat0 f@
                       sph-clat0 f@ sph-clon0 f@ f*  rlVertex3f ;
: sphere-v0j1 ( -- )  sph-clat0 f@ sph-slon1 f@ f*
                       sph-slat0 f@
                       sph-clat0 f@ sph-clon1 f@ f*  rlVertex3f ;
: sphere-v1j ( -- )   sph-clat1 f@ sph-slon0 f@ f*
                       sph-slat1 f@
                       sph-clat1 f@ sph-clon0 f@ f*  rlVertex3f ;
: sphere-v1j1 ( -- )  sph-clat1 f@ sph-slon1 f@ f*
                       sph-slat1 f@
                       sph-clat1 f@ sph-clon1 f@ f*  rlVertex3f ;

\ Compute lat cos/sin for ring index n into (sph-clat0, sph-slat0) or *1.
\ lat_angle = DEG2RAD * (270 + (180/17) * n)
: sphere-lat0 ( n -- )
   s>f 180e 17e f/ f* 270e f+ RPI f* 180e f/ fdup fcos sph-clat0 f! fsin sph-slat0 f! ;
: sphere-lat1 ( n -- )
   s>f 180e 17e f/ f* 270e f+ RPI f* 180e f/ fdup fcos sph-clat1 f! fsin sph-slat1 f! ;

\ Compute lon cos/sin for slice index n into (sph-clon0, sph-slon0) or *1.
\ lon_angle = DEG2RAD * (n * 360/16)
: sphere-lon0 ( n -- )
   s>f 360e 16e f/ f* RPI f* 180e f/ fdup fcos sph-clon0 f! fsin sph-slon0 f! ;
: sphere-lon1 ( n -- )
   s>f 360e 16e f/ f* RPI f* 180e f/ fdup fcos sph-clon1 f! fsin sph-slon1 f! ;

\ Draw unit sphere at origin using rlgl primitives.
\ ( color -- )   color is a packed u32 RGBA raylib Color.
: DrawSphereBasic ( color -- )
   locals| col |
   1728 rlCheckRenderBatchLimit drop
   RL_TRIANGLES rlBegin
      col .red  col .green  col .blue  col .alpha  rlColor4ub
      0 sph-i !
      begin sph-i @ 18 < while
         sph-i @ sphere-lat0
         sph-i @ 1+ sphere-lat1
         0 sph-j !
         begin sph-j @ 16 < while
            sph-j @ sphere-lon0
            sph-j @ 1+ sphere-lon1
            \ Triangle 1: (i,j)  (i+1,j+1)  (i+1,j)
            sphere-v0j   sphere-v1j1   sphere-v1j
            \ Triangle 2: (i,j)  (i,j+1)    (i+1,j+1)
            sphere-v0j   sphere-v0j1   sphere-v1j1
            1 sph-j +!
         repeat
         1 sph-i +!
      repeat
   rlEnd ;

: example
   0e earthRot sf!  0e earthOrbit sf!  0e moonRot sf!  0e moonOrbit sf!
   screenWidth screenHeight z" raylib [models] example - rlgl solar system" InitWindow
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      earthRot sf@   5e rotationSpeed f* f+            earthRot sf!
      earthOrbit sf@ 365e 360e f/ 5e f* rotationSpeed f* rotationSpeed f* f+  earthOrbit sf!
      moonRot sf@    2e rotationSpeed f* f+             moonRot sf!
      moonOrbit sf@  8e rotationSpeed f* f+             moonOrbit sf!
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D

            \ Sun
            rlPushMatrix
               sunRadius sunRadius sunRadius rlScalef
               GOLD DrawSphereBasic
            rlPopMatrix

            \ Earth and Moon
            rlPushMatrix
               earthOrbit sf@ 0e 1e 0e rlRotatef
               earthOrbitRadius 0e 0e rlTranslatef

               rlPushMatrix
                  earthRot sf@ 0.25e 1e 0e rlRotatef
                  earthRadius earthRadius earthRadius rlScalef
                  BLUE DrawSphereBasic
               rlPopMatrix

               moonOrbit sf@ 0e 1e 0e rlRotatef
               moonOrbitRadius 0e 0e rlTranslatef
               moonRot sf@ 0e 1e 0e rlRotatef
               moonRadius moonRadius moonRadius rlScalef
               LIGHTGRAY DrawSphereBasic
            rlPopMatrix

            \ Reference orbit circle and grid
            circleCenter earthOrbitRadius circleAxis 90e RED 0.5e Fade DrawCircle3D
            20 1e DrawGrid

         EndMode3D
         z" EARTH ORBITING AROUND THE SUN!" 400 10 20 MAROON DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
