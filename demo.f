
empty

include raylib.f
/raylib

$ff000000 constant black


: scene
	BeginDrawing
	black ClearBackground
	10 10 DrawFPS
	EndDrawing ;


: main
	800 600 z" hello world" InitWindow
\	60 SetTargetFPS
	begin
		scene
	WindowShouldClose until
	CloseWindow
	0 ExitProcess ;

' main 'main !
PROGRAM demo.exe
bye	
