empty
only forth also definitions
include raylib.f 
/raylib 

$ff000000 constant black
$ffffffff constant white
: hello z" hello world" ;

: scene
	BeginDrawing
	black ClearBackground
	10 10 DrawFPS
	hello 10 40 20 white DrawText
	hello 10 80 40 white DrawText
	hello 10 200 80 white DrawText
	EndDrawing ;

: main
	800 600 z" hello world" InitWindow
	60 SetTargetFPS
	begin
		scene
	WindowShouldClose until
	CloseWindow
	0 ExitProcess ;

' main 'main !
PROGRAM hello.exe
bye
