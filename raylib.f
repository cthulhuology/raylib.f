PACKAGE raylib
LIBRARY raylib  \ Loads libraylib.so or raylib.dll or equivalent
PRIVATE

\ Callbacks to hook some internal Module

\ Window-related Module
FUNCTION: InitWindow                       ( i i a -- )             \ Initialize window and OpenGL context : int width, int height, const char *title
FUNCTION: CloseWindow                      ( -- )                   \ Close window and unload OpenGL context : void
FUNCTION: WindowShouldClose                ( -- i )                 \ Check if application should close (KEY_ESCAPE pressed or windows close icon clicked) : void
FUNCTION: IsWindowReady                    ( -- i )                 \ Check if window has been initialized successfully : void
FUNCTION: IsWindowFullscreen               ( -- i )                 \ Check if window is currently fullscreen : void
FUNCTION: IsWindowHidden                   ( -- i )                 \ Check if window is currently hidden : void
FUNCTION: IsWindowMinimized                ( -- i )                 \ Check if window is currently minimized : void
FUNCTION: IsWindowMaximized                ( -- i )                 \ Check if window is currently maximized : void
FUNCTION: IsWindowFocused                  ( -- i )                 \ Check if window is currently focused : void
FUNCTION: IsWindowResized                  ( -- i )                 \ Check if window has been resized last frame : void
FUNCTION: IsWindowState                    ( u -- i )               \ Check if one specific window flag is enabled : unsigned int flag
FUNCTION: SetWindowState                   ( u -- )                 \ Set window configuration state using flags : unsigned int flags
FUNCTION: ClearWindowState                 ( u -- )                 \ Clear window configuration state flags : unsigned int flags
FUNCTION: ToggleFullscreen                 ( -- )                   \ Toggle window state: fullscreen/windowed, resizes monitor to match window resolution : void
FUNCTION: ToggleBorderlessWindowed         ( -- )                   \ Toggle window state: borderless windowed, resizes window to match monitor resolution : void
FUNCTION: MaximizeWindow                   ( -- )                   \ Set window state: maximized, if resizable : void
FUNCTION: MinimizeWindow                   ( -- )                   \ Set window state: minimized, if resizable : void
FUNCTION: RestoreWindow                    ( -- )                   \ Set window state: not minimized/maximized : void
FUNCTION: SetWindowIcon                    ( a -- )                 \ Set icon for window (single image, RGBA 32bit) : Image image
FUNCTION: SetWindowIcons                   ( a i -- )               \ Set icon for window (multiple images, RGBA 32bit) : Image *images, int count
FUNCTION: SetWindowTitle                   ( a -- )                 \ Set title for window : const char *title
FUNCTION: SetWindowPosition                ( i i -- )               \ Set window position on screen : int x, int y
FUNCTION: SetWindowMonitor                 ( i -- )                 \ Set monitor for the current window : int monitor
FUNCTION: SetWindowMinSize                 ( i i -- )               \ Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE) : int width, int height
FUNCTION: SetWindowMaxSize                 ( i i -- )               \ Set window maximum dimensions (for FLAG_WINDOW_RESIZABLE) : int width, int height
FUNCTION: SetWindowSize                    ( i i -- )               \ Set window dimensions : int width, int height
FUNCTION: SetWindowOpacity                 ( %f -- )                \ Set window opacity [0.0f..1.0f] : float opacity
FUNCTION: SetWindowFocused                 ( -- )                   \ Set window focused : void
FUNCTION: GetWindowHandle                  ( -- a )                 \ Get native window handle : void
FUNCTION: GetScreenWidth                   ( -- i )                 \ Get current screen width : void
FUNCTION: GetScreenHeight                  ( -- i )                 \ Get current screen height : void
FUNCTION: GetRenderWidth                   ( -- i )                 \ Get current render width (it considers HiDPI) : void
FUNCTION: GetRenderHeight                  ( -- i )                 \ Get current render height (it considers HiDPI) : void
FUNCTION: GetMonitorCount                  ( -- i )                 \ Get number of connected monitors : void
FUNCTION: GetCurrentMonitor                ( -- i )                 \ Get current monitor where window is placed : void
FUNCTION: GetMonitorPosition               ( i -- a )               \ Get specified monitor position : int monitor
FUNCTION: GetMonitorWidth                  ( i -- i )               \ Get specified monitor width (current video mode used by monitor) : int monitor
FUNCTION: GetMonitorHeight                 ( i -- i )               \ Get specified monitor height (current video mode used by monitor) : int monitor
FUNCTION: GetMonitorPhysicalWidth          ( i -- i )               \ Get specified monitor physical width in millimetres : int monitor
FUNCTION: GetMonitorPhysicalHeight         ( i -- i )               \ Get specified monitor physical height in millimetres : int monitor
FUNCTION: GetMonitorRefreshRate            ( i -- i )               \ Get specified monitor refresh rate : int monitor
FUNCTION: GetWindowPosition                ( -- a )                 \ Get window position XY on monitor : void
FUNCTION: GetWindowScaleDPI                ( -- a )                 \ Get window scale DPI factor : void
FUNCTION: GetMonitorName                   ( i -- a )               \ Get the human-readable, UTF-8 encoded name of the specified monitor : int monitor
FUNCTION: SetClipboardText                 ( a -- )                 \ Set clipboard text content : const char *text
FUNCTION: GetClipboardText                 ( -- a )                 \ Get clipboard text content : void
FUNCTION: GetClipboardImage                ( -- a )                 \ Get clipboard image content : void
FUNCTION: EnableEventWaiting               ( -- )                   \ Enable waiting for events on EndDrawing(), no automatic event polling : void
FUNCTION: DisableEventWaiting              ( -- )                   \ Disable waiting for events on EndDrawing(), automatic events polling : void

\ Cursor-related Module
FUNCTION: ShowCursor                       ( -- )                   \ Shows cursor : void
FUNCTION: HideCursor                       ( -- )                   \ Hides cursor : void
FUNCTION: IsCursorHidden                   ( -- i )                 \ Check if cursor is not visible : void
FUNCTION: EnableCursor                     ( -- )                   \ Enables cursor (unlock cursor) : void
FUNCTION: DisableCursor                    ( -- )                   \ Disables cursor (lock cursor) : void
FUNCTION: IsCursorOnScreen                 ( -- i )                 \ Check if cursor is on the screen : void

\ Drawing-related Module
FUNCTION: ClearBackground                  ( u -- )                 \ Set background color (framebuffer clear color) : Color color
FUNCTION: BeginDrawing                     ( -- )                   \ Setup canvas (framebuffer) to start drawing : void
FUNCTION: EndDrawing                       ( -- )                   \ End canvas drawing and swap buffers (double buffering) : void
FUNCTION: BeginMode2D                      ( a -- )                 \ Begin 2D mode with custom camera (2D) : Camera2D camera
FUNCTION: EndMode2D                        ( -- )                   \ Ends 2D mode with custom camera : void
FUNCTION: BeginMode3D                      ( a -- )                 \ Begin 3D mode with custom camera (3D) : Camera3D camera
FUNCTION: EndMode3D                        ( -- )                   \ Ends 3D mode and returns to default 2D orthographic mode : void
FUNCTION: BeginTextureMode                 ( a -- )                 \ Begin drawing to render texture : RenderTexture2D target
FUNCTION: EndTextureMode                   ( -- )                   \ Ends drawing to render texture : void
FUNCTION: BeginShaderMode                  ( a -- )                 \ Begin custom shader drawing : Shader shader
FUNCTION: EndShaderMode                    ( -- )                   \ End custom shader drawing (use default shader) : void
FUNCTION: BeginBlendMode                   ( i -- )                 \ Begin blending mode (alpha, additive, multiplied, subtract, custom) : int mode
FUNCTION: EndBlendMode                     ( -- )                   \ End blending mode (reset to default: alpha blending) : void
FUNCTION: BeginScissorMode                 ( i i i i -- )           \ Begin scissor mode (define screen area for following drawing) : int x, int y, int width, int height
FUNCTION: EndScissorMode                   ( -- )                   \ End scissor mode : void
FUNCTION: BeginVrStereoMode                ( a -- )                 \ Begin stereo rendering (requires VR simulator) : VrStereoConfig config
FUNCTION: EndVrStereoMode                  ( -- )                   \ End stereo rendering (requires VR simulator) : void

\ VR stereo config Module for VR simulator
FUNCTION: LoadVrStereoConfig               ( a -- a )               \ Load VR stereo config for VR simulator device parameters : VrDeviceInfo device
FUNCTION: UnloadVrStereoConfig             ( a -- )                 \ Unload VR stereo config : VrStereoConfig config

\ Shader management Module
FUNCTION: LoadShader                       ( a a -- a )             \ Load shader from files and bind default locations : const char *vsFileName, const char *fsFileName
FUNCTION: LoadShaderFromMemory             ( a a -- a )             \ Load shader from code strings and bind default locations : const char *vsCode, const char *fsCode
FUNCTION: IsShaderValid                    ( a -- i )               \ Check if a shader is valid (loaded on GPU) : Shader shader
FUNCTION: GetShaderLocation                ( a a -- i )             \ Get shader uniform location : Shader shader, const char *uniformName
FUNCTION: GetShaderLocationAttrib          ( a a -- i )             \ Get shader attribute location : Shader shader, const char *attribName
FUNCTION: SetShaderValue                   ( a i a i -- )           \ Set shader uniform value : Shader shader, int locIndex, const void *value, int uniformType
FUNCTION: SetShaderValueV                  ( a i a i i -- )         \ Set shader uniform value vector : Shader shader, int locIndex, const void *value, int uniformType, int count
FUNCTION: SetShaderValueMatrix             ( a i a -- )             \ Set shader uniform value (matrix 4x4) : Shader shader, int locIndex, Matrix mat
FUNCTION: SetShaderValueTexture            ( a i a -- )             \ Set shader uniform value for texture (sampler2d) : Shader shader, int locIndex, Texture2D texture
FUNCTION: UnloadShader                     ( a -- )                 \ Unload shader from GPU memory (VRAM) : Shader shader

\ Screen-space-related Module
FUNCTION: GetScreenToWorldRay              ( a a -- a )             \ Get a ray trace from screen position (i.e mouse) : Vector2 position, Camera camera
FUNCTION: GetScreenToWorldRayEx            ( a a i i -- a )         \ Get a ray trace from screen position (i.e mouse) in a viewport : Vector2 position, Camera camera, int width, int height
FUNCTION: GetWorldToScreen                 ( a a -- a )             \ Get the screen space position for a 3d world space position : Vector3 position, Camera camera
FUNCTION: GetWorldToScreenEx               ( a a i i -- a )         \ Get size position for a 3d world space position : Vector3 position, Camera camera, int width, int height
FUNCTION: GetWorldToScreen2D               ( a a -- a )             \ Get the screen space position for a 2d camera world space position : Vector2 position, Camera2D camera
FUNCTION: GetScreenToWorld2D               ( a a -- a )             \ Get the world space position for a 2d camera screen space position : Vector2 position, Camera2D camera
FUNCTION: GetCameraMatrix                  ( a -- a )               \ Get camera transform matrix (view matrix) : Camera camera
FUNCTION: GetCameraMatrix2D                ( a -- a )               \ Get camera 2d transform matrix : Camera2D camera

\ Timing-related Module
FUNCTION: SetTargetFPS                     ( i -- )                 \ Set target FPS (maximum) : int fps
FUNCTION: GetFrameTime                     ( -- %f )                \ Get time in seconds for last frame drawn (delta time) : void
FUNCTION: GetTime                          ( -- %%d )               \ Get elapsed time in seconds since InitWindow() : void
FUNCTION: GetFPS                           ( -- i )                 \ Get current FPS : void

\ Custom frame control Module

\ NOTE: Those Module are intended for advanced users that want full control over the frame processing
FUNCTION: SwapScreenBuffer                 ( -- )                   \ Swap back buffer with front buffer (screen drawing) : void
FUNCTION: PollInputEvents                  ( -- )                   \ Register all input events : void
FUNCTION: WaitTime                         ( %%d -- )               \ Wait for some time (halt program execution) : double seconds

\ Random values generation Module
FUNCTION: SetRandomSeed                    ( u -- )                 \ Set the seed for the random number generator : unsigned int seed
FUNCTION: GetRandomValue                   ( i i -- i )             \ Get a random value between min and max (both included) : int min, int max
FUNCTION: LoadRandomSequence               ( u i i -- a )           \ Load random values sequence, no values repeated : unsigned int count, int min, int max
FUNCTION: UnloadRandomSequence             ( a -- )                 \ Unload random values sequence : int *sequence

\ Misc. Module
FUNCTION: TakeScreenshot                   ( a -- )                 \ Takes a screenshot of current screen (filename extension defines format) : const char *fileName
FUNCTION: SetConfigFlags                   ( u -- )                 \ Setup init configuration flags (view FLAGS) : unsigned int flags
FUNCTION: OpenURL                          ( a -- )                 \ Open URL with default system browser (if available) : const char *url

\ NOTE: Following Module implemented in module [utils]
FUNCTION: TraceLog                         ( i a -- )               \ Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...) : int logLevel, const char *text, ...
FUNCTION: SetTraceLogLevel                 ( i -- )                 \ Set the current threshold (minimum) log level : int logLevel
FUNCTION: MemAlloc                         ( u -- a )               \ Internal memory allocator : unsigned int size
FUNCTION: MemRealloc                       ( a u -- a )             \ Internal memory reallocator : void *ptr, unsigned int size
FUNCTION: MemFree                          ( a -- )                 \ Internal memory free : void *ptr
FUNCTION: SetTraceLogCallback              ( a -- )                 \ Set custom trace log : TraceLogCallback callback
FUNCTION: SetLoadFileDataCallback          ( a -- )                 \ Set custom file binary data loader : LoadFileDataCallback callback
FUNCTION: SetSaveFileDataCallback          ( a -- )                 \ Set custom file binary data saver : SaveFileDataCallback callback
FUNCTION: SetLoadFileTextCallback          ( a -- )                 \ Set custom file text data loader : LoadFileTextCallback callback
FUNCTION: SetSaveFileTextCallback          ( a -- )                 \ Set custom file text data saver : SaveFileTextCallback callback

\ Files management Module
FUNCTION: LoadFileData                     ( a a -- a )             \ Load file data as byte array (read) : const char *fileName, int *dataSize
FUNCTION: UnloadFileData                   ( a -- )                 \ Unload file data allocated by LoadFileData() : unsigned char *data
FUNCTION: SaveFileData                     ( a a i -- i )           \ Save data to file from byte array (write), returns true on success : const char *fileName, void *data, int dataSize
FUNCTION: ExportDataAsCode                 ( a i a -- i )           \ Export data to code (.h), returns true on success : const unsigned char *data, int dataSize, const char *fileName
FUNCTION: LoadFileText                     ( a -- a )               \ Load text data from file (read), returns a '\0' terminated string : const char *fileName
FUNCTION: UnloadFileText                   ( a -- )                 \ Unload file text data allocated by LoadFileText() : char *text
FUNCTION: SaveFileText                     ( a a -- i )             \ Save text data to file (write), string must be '\0' terminated, returns true on success : const char *fileName, char *text

\ File system Module
FUNCTION: FileExists                       ( a -- i )               \ Check if file exists : const char *fileName
FUNCTION: DirectoryExists                  ( a -- i )               \ Check if a directory path exists : const char *dirPath
FUNCTION: IsFileExtension                  ( a a -- i )             \ Check file extension (including point: .png, .wav) : const char *fileName, const char *ext
FUNCTION: GetFileLength                    ( a -- i )               \ Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h) : const char *fileName
FUNCTION: GetFileExtension                 ( a -- a )               \ Get pointer to extension for a filename string (includes dot: '.png') : const char *fileName
FUNCTION: GetFileName                      ( a -- a )               \ Get pointer to filename for a path string : const char *filePath
FUNCTION: GetFileNameWithoutExt            ( a -- a )               \ Get filename string without extension (uses static string) : const char *filePath
FUNCTION: GetDirectoryPath                 ( a -- a )               \ Get full path for a given fileName with path (uses static string) : const char *filePath
FUNCTION: GetPrevDirectoryPath             ( a -- a )               \ Get previous directory path for a given path (uses static string) : const char *dirPath
FUNCTION: GetWorkingDirectory              ( -- a )                 \ Get current working directory (uses static string) : void
FUNCTION: GetApplicationDirectory          ( -- a )                 \ Get the directory of the running application (uses static string) : void
FUNCTION: MakeDirectory                    ( a -- i )               \ Create directories (including full path requested), returns 0 on success : const char *dirPath
FUNCTION: ChangeDirectory                  ( a -- i )               \ Change working directory, return true on success : const char *dir
FUNCTION: IsPathFile                       ( a -- i )               \ Check if a given path is a file or a directory : const char *path
FUNCTION: IsFileNameValid                  ( a -- i )               \ Check if fileName is valid for the platform/OS : const char *fileName
FUNCTION: LoadDirectoryFiles               ( a -- a )               \ Load directory filepaths : const char *dirPath
FUNCTION: LoadDirectoryFilesEx             ( a a i -- a )           \ Load directory filepaths with extension filtering and recursive directory scan. Use 'DIR' in the filter string to include directories in the result : const char *basePath, const char *filter, bool scanSubdirs
FUNCTION: UnloadDirectoryFiles             ( a -- )                 \ Unload filepaths : FilePathList files
FUNCTION: IsFileDropped                    ( -- i )                 \ Check if a file has been dropped into window : void
FUNCTION: LoadDroppedFiles                 ( -- a )                 \ Load dropped filepaths : void
FUNCTION: UnloadDroppedFiles               ( a -- )                 \ Unload dropped filepaths : FilePathList files
FUNCTION: GetFileModTime                   ( a -- a )               \ Get file modification time (last write time) : const char *fileName
FUNCTION: CompressData                     ( a i a -- a )           \ Compress data (DEFLATE algorithm), memory must be MemFree() : const unsigned char *data, int dataSize, int *compDataSize
FUNCTION: DecompressData                   ( a i a -- a )           \ Decompress data (DEFLATE algorithm), memory must be MemFree() : const unsigned char *compData, int compDataSize, int *dataSize
FUNCTION: EncodeDataBase64                 ( a i a -- a )           \ Encode data to Base64 string, memory must be MemFree() : const unsigned char *data, int dataSize, int *outputSize
FUNCTION: DecodeDataBase64                 ( a a -- a )             \ Decode Base64 string data, memory must be MemFree() : const unsigned char *data, int *outputSize
FUNCTION: ComputeCRC32                     ( a i -- u )             \ Compute CRC32 hash code : unsigned char *data, int dataSize
FUNCTION: ComputeMD5                       ( a i -- a )             \ Compute MD5 hash code, returns static int[4] (16 bytes) : unsigned char *data, int dataSize
FUNCTION: ComputeSHA1                      ( a i -- a )             \ Compute SHA1 hash code, returns static int[5] (20 bytes) : unsigned char *data, int dataSize
FUNCTION: LoadAutomationEventList          ( a -- a )               \ Load automation events list from file, NULL for empty list, capacity = MAX_AUTOMATION_EVENTS : const char *fileName
FUNCTION: UnloadAutomationEventList        ( a -- )                 \ Unload automation events list from file : AutomationEventList list
FUNCTION: ExportAutomationEventList        ( a a -- i )             \ Export automation events list as text file : AutomationEventList list, const char *fileName
FUNCTION: SetAutomationEventList           ( a -- )                 \ Set automation event list to record to : AutomationEventList *list
FUNCTION: SetAutomationEventBaseFrame      ( i -- )                 \ Set automation event internal base frame to start recording : int frame
FUNCTION: StartAutomationEventRecording    ( -- )                   \ Start recording automation events (AutomationEventList must be set) : void
FUNCTION: StopAutomationEventRecording     ( -- )                   \ Stop recording automation events : void
FUNCTION: PlayAutomationEvent              ( a -- )                 \ Play a recorded automation event : AutomationEvent event

\ Input-related Module: keyboard
FUNCTION: IsKeyPressed                     ( i -- i )               \ Check if a key has been pressed once : int key
FUNCTION: IsKeyPressedRepeat               ( i -- i )               \ Check if a key has been pressed again : int key
FUNCTION: IsKeyDown                        ( i -- i )               \ Check if a key is being pressed : int key
FUNCTION: IsKeyReleased                    ( i -- i )               \ Check if a key has been released once : int key
FUNCTION: IsKeyUp                          ( i -- i )               \ Check if a key is NOT being pressed : int key
FUNCTION: GetKeyPressed                    ( -- i )                 \ Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty : void
FUNCTION: GetCharPressed                   ( -- i )                 \ Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty : void
FUNCTION: SetExitKey                       ( i -- )                 \ Set a custom key to exit program (default is ESC) : int key

\ Input-related Module: gamepads
FUNCTION: IsGamepadAvailable               ( i -- i )               \ Check if a gamepad is available : int gamepad
FUNCTION: GetGamepadName                   ( i -- a )               \ Get gamepad internal name id : int gamepad
FUNCTION: IsGamepadButtonPressed           ( i i -- i )             \ Check if a gamepad button has been pressed once : int gamepad, int button
FUNCTION: IsGamepadButtonDown              ( i i -- i )             \ Check if a gamepad button is being pressed : int gamepad, int button
FUNCTION: IsGamepadButtonReleased          ( i i -- i )             \ Check if a gamepad button has been released once : int gamepad, int button
FUNCTION: IsGamepadButtonUp                ( i i -- i )             \ Check if a gamepad button is NOT being pressed : int gamepad, int button
FUNCTION: GetGamepadButtonPressed          ( -- i )                 \ Get the last gamepad button pressed : void
FUNCTION: GetGamepadAxisCount              ( i -- i )               \ Get gamepad axis count for a gamepad : int gamepad
FUNCTION: GetGamepadAxisMovement           ( i i -- %f )            \ Get axis movement value for a gamepad axis : int gamepad, int axis
FUNCTION: SetGamepadMappings               ( a -- i )               \ Set internal gamepad mappings (SDL_GameControllerDB) : const char *mappings
FUNCTION: SetGamepadVibration              ( i %f %f %f -- )        \ Set gamepad vibration for both motors (duration in seconds) : int gamepad, float leftMotor, float rightMotor, float duration

\ Input-related Module: mouse
FUNCTION: IsMouseButtonPressed             ( i -- i )               \ Check if a mouse button has been pressed once : int button
FUNCTION: IsMouseButtonDown                ( i -- i )               \ Check if a mouse button is being pressed : int button
FUNCTION: IsMouseButtonReleased            ( i -- i )               \ Check if a mouse button has been released once : int button
FUNCTION: IsMouseButtonUp                  ( i -- i )               \ Check if a mouse button is NOT being pressed : int button
FUNCTION: GetMouseX                        ( -- i )                 \ Get mouse position X : void
FUNCTION: GetMouseY                        ( -- i )                 \ Get mouse position Y : void
FUNCTION: GetMousePosition                 ( -- a )                 \ Get mouse position XY : void
FUNCTION: GetMouseDelta                    ( -- a )                 \ Get mouse delta between frames : void
FUNCTION: SetMousePosition                 ( i i -- )               \ Set mouse position XY : int x, int y
FUNCTION: SetMouseOffset                   ( i i -- )               \ Set mouse offset : int offsetX, int offsetY
FUNCTION: SetMouseScale                    ( %f %f -- )             \ Set mouse scaling : float scaleX, float scaleY
FUNCTION: GetMouseWheelMove                ( -- %f )                \ Get mouse wheel movement for X or Y, whichever is larger : void
FUNCTION: GetMouseWheelMoveV               ( -- a )                 \ Get mouse wheel movement for both X and Y : void
FUNCTION: SetMouseCursor                   ( i -- )                 \ Set mouse cursor : int cursor

\ Input-related Module: touch
FUNCTION: GetTouchX                        ( -- i )                 \ Get touch position X for touch point 0 (relative to screen size) : void
FUNCTION: GetTouchY                        ( -- i )                 \ Get touch position Y for touch point 0 (relative to screen size) : void
FUNCTION: GetTouchPosition                 ( i -- a )               \ Get touch position XY for a touch point index (relative to screen size) : int index
FUNCTION: GetTouchPointId                  ( i -- i )               \ Get touch point identifier for given index : int index
FUNCTION: GetTouchPointCount               ( -- i )                 \ Get number of touch points : void
FUNCTION: SetGesturesEnabled               ( u -- )                 \ Enable a set of gestures using flags : unsigned int flags
FUNCTION: IsGestureDetected                ( u -- i )               \ Check if a gesture have been detected : unsigned int gesture
FUNCTION: GetGestureDetected               ( -- i )                 \ Get latest detected gesture : void
FUNCTION: GetGestureHoldDuration           ( -- %f )                \ Get gesture hold time in seconds : void
FUNCTION: GetGestureDragVector             ( -- a )                 \ Get gesture drag vector : void
FUNCTION: GetGestureDragAngle              ( -- %f )                \ Get gesture drag angle : void
FUNCTION: GetGesturePinchVector            ( -- a )                 \ Get gesture pinch delta : void
FUNCTION: GetGesturePinchAngle             ( -- %f )                \ Get gesture pinch angle : void
FUNCTION: UpdateCamera                     ( a i -- )               \ Update camera position for selected mode : Camera *camera, int mode
FUNCTION: UpdateCameraPro                  ( a a a %f -- )          \ Update camera movement/rotation : Camera *camera, Vector3 movement, Vector3 rotation, float zoom
FUNCTION: SetShapesTexture                 ( a a -- )               \ Set texture and rectangle to be used on shapes drawing : Texture2D texture, Rectangle source
FUNCTION: GetShapesTexture                 ( -- a )                 \ Get texture that is used for shapes drawing : void
FUNCTION: GetShapesTextureRectangle        ( -- a )                 \ Get texture source rectangle that is used for shapes drawing : void

\ Basic shapes drawing Module
FUNCTION: DrawPixel                        ( i i u -- )             \ Draw a pixel using geometry [Can be slow, use with care] : int posX, int posY, Color color
FUNCTION: DrawPixelV                       ( a u -- )               \ Draw a pixel using geometry (Vector version) [Can be slow, use with care] : Vector2 position, Color color
FUNCTION: DrawLine                         ( i i i i u -- )         \ Draw a line : int startPosX, int startPosY, int endPosX, int endPosY, Color color
FUNCTION: DrawLineV                        ( a a u -- )             \ Draw a line (using gl lines) : Vector2 startPos, Vector2 endPos, Color color
FUNCTION: DrawLineEx                       ( a a %f u -- )          \ Draw a line (using triangles/quads) : Vector2 startPos, Vector2 endPos, float thick, Color color
FUNCTION: DrawLineStrip                    ( a i u -- )             \ Draw lines sequence (using gl lines) : const Vector2 *points, int pointCount, Color color
FUNCTION: DrawLineBezier                   ( a a %f u -- )          \ Draw line segment cubic-bezier in-out interpolation : Vector2 startPos, Vector2 endPos, float thick, Color color
FUNCTION: DrawCircle                       ( i i %f u -- )          \ Draw a color-filled circle : int centerX, int centerY, float radius, Color color
FUNCTION: DrawCircleSector                 ( a %f %f %f i u -- )    \ Draw a piece of a circle : Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color
FUNCTION: DrawCircleSectorLines            ( a %f %f %f i u -- )    \ Draw circle sector outline : Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color
FUNCTION: DrawCircleGradient               ( i i %f u u -- )        \ Draw a gradient-filled circle : int centerX, int centerY, float radius, Color inner, Color outer
FUNCTION: DrawCircleV                      ( a %f u -- )            \ Draw a color-filled circle (Vector version) : Vector2 center, float radius, Color color
FUNCTION: DrawCircleLines                  ( i i %f u -- )          \ Draw circle outline : int centerX, int centerY, float radius, Color color
FUNCTION: DrawCircleLinesV                 ( a %f u -- )            \ Draw circle outline (Vector version) : Vector2 center, float radius, Color color
FUNCTION: DrawEllipse                      ( i i %f %f u -- )       \ Draw ellipse : int centerX, int centerY, float radiusH, float radiusV, Color color
FUNCTION: DrawEllipseLines                 ( i i %f %f u -- )       \ Draw ellipse outline : int centerX, int centerY, float radiusH, float radiusV, Color color
FUNCTION: DrawRing                         ( a %f %f %f %f i u -- ) \ Draw ring : Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color
FUNCTION: DrawRingLines                    ( a %f %f %f %f i u -- ) \ Draw ring outline : Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color
FUNCTION: DrawRectangle                    ( i i i i u -- )         \ Draw a color-filled rectangle : int posX, int posY, int width, int height, Color color
FUNCTION: DrawRectangleV                   ( a a u -- )             \ Draw a color-filled rectangle (Vector version) : Vector2 position, Vector2 size, Color color
FUNCTION: DrawRectangleRec                 ( a u -- )               \ Draw a color-filled rectangle : Rectangle rec, Color color
FUNCTION: DrawRectanglePro                 ( a a %f u -- )          \ Draw a color-filled rectangle with pro parameters : Rectangle rec, Vector2 origin, float rotation, Color color
FUNCTION: DrawRectangleGradientV           ( i i i i u u -- )       \ Draw a vertical-gradient-filled rectangle : int posX, int posY, int width, int height, Color top, Color bottom
FUNCTION: DrawRectangleGradientH           ( i i i i u u -- )       \ Draw a horizontal-gradient-filled rectangle : int posX, int posY, int width, int height, Color left, Color right
FUNCTION: DrawRectangleGradientEx          ( a u u u u -- )         \ Draw a gradient-filled rectangle with custom vertex colors : Rectangle rec, Color topLeft, Color bottomLeft, Color topRight, Color bottomRight
FUNCTION: DrawRectangleLines               ( i i i i u -- )         \ Draw rectangle outline : int posX, int posY, int width, int height, Color color
FUNCTION: DrawRectangleLinesEx             ( a %f u -- )            \ Draw rectangle outline with extended parameters : Rectangle rec, float lineThick, Color color
FUNCTION: DrawRectangleRounded             ( a %f i u -- )          \ Draw rectangle with rounded edges : Rectangle rec, float roundness, int segments, Color color
FUNCTION: DrawRectangleRoundedLines        ( a %f i u -- )          \ Draw rectangle lines with rounded edges : Rectangle rec, float roundness, int segments, Color color
FUNCTION: DrawRectangleRoundedLinesEx      ( a %f i %f u -- )       \ Draw rectangle with rounded edges outline : Rectangle rec, float roundness, int segments, float lineThick, Color color
FUNCTION: DrawTriangle                     ( a a a u -- )           \ Draw a color-filled triangle (vertex in counter-clockwise order!) : Vector2 v1, Vector2 v2, Vector2 v3, Color color
FUNCTION: DrawTriangleLines                ( a a a u -- )           \ Draw triangle outline (vertex in counter-clockwise order!) : Vector2 v1, Vector2 v2, Vector2 v3, Color color
FUNCTION: DrawTriangleFan                  ( a i u -- )             \ Draw a triangle fan defined by points (first vertex is the center) : const Vector2 *points, int pointCount, Color color
FUNCTION: DrawTriangleStrip                ( a i u -- )             \ Draw a triangle strip defined by points : const Vector2 *points, int pointCount, Color color
FUNCTION: DrawPoly                         ( a i %f %f u -- )       \ Draw a regular polygon (Vector version) : Vector2 center, int sides, float radius, float rotation, Color color
FUNCTION: DrawPolyLines                    ( a i %f %f u -- )       \ Draw a polygon outline of n sides : Vector2 center, int sides, float radius, float rotation, Color color
FUNCTION: DrawPolyLinesEx                  ( a i %f %f %f u -- )    \ Draw a polygon outline of n sides with extended parameters : Vector2 center, int sides, float radius, float rotation, float lineThick, Color color

\ Splines drawing Module
FUNCTION: DrawSplineLinear                 ( a i %f u -- )          \ Draw spline: Linear, minimum 2 points : const Vector2 *points, int pointCount, float thick, Color color
FUNCTION: DrawSplineBasis                  ( a i %f u -- )          \ Draw spline: B-Spline, minimum 4 points : const Vector2 *points, int pointCount, float thick, Color color
FUNCTION: DrawSplineCatmullRom             ( a i %f u -- )          \ Draw spline: Catmull-Rom, minimum 4 points : const Vector2 *points, int pointCount, float thick, Color color
FUNCTION: DrawSplineBezierQuadratic        ( a i %f u -- )          \ Draw spline: Quadratic Bezier, minimum 3 points (1 control point): [p1, c2, p3, c4...] : const Vector2 *points, int pointCount, float thick, Color color
FUNCTION: DrawSplineBezierCubic            ( a i %f u -- )          \ Draw spline: Cubic Bezier, minimum 4 points (2 control points): [p1, c2, c3, p4, c5, c6...] : const Vector2 *points, int pointCount, float thick, Color color
FUNCTION: DrawSplineSegmentLinear          ( a a %f u -- )          \ Draw spline segment: Linear, 2 points : Vector2 p1, Vector2 p2, float thick, Color color
FUNCTION: DrawSplineSegmentBasis           ( a a a a %f u -- )      \ Draw spline segment: B-Spline, 4 points : Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4, float thick, Color color
FUNCTION: DrawSplineSegmentCatmullRom      ( a a a a %f u -- )      \ Draw spline segment: Catmull-Rom, 4 points : Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4, float thick, Color color
FUNCTION: DrawSplineSegmentBezierQuadratic ( a a a %f u -- )        \ Draw spline segment: Quadratic Bezier, 2 points, 1 control point : Vector2 p1, Vector2 c2, Vector2 p3, float thick, Color color
FUNCTION: DrawSplineSegmentBezierCubic     ( a a a a %f u -- )      \ Draw spline segment: Cubic Bezier, 2 points, 2 control points : Vector2 p1, Vector2 c2, Vector2 c3, Vector2 p4, float thick, Color color

\ Spline segment point evaluation Module, for a given t [0.0f .. 1.0f]
FUNCTION: GetSplinePointLinear             ( a a %f -- a )          \ Get (evaluate) spline point: Linear : Vector2 startPos, Vector2 endPos, float t
FUNCTION: GetSplinePointBasis              ( a a a a %f -- a )      \ Get (evaluate) spline point: B-Spline : Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4, float t
FUNCTION: GetSplinePointCatmullRom         ( a a a a %f -- a )      \ Get (evaluate) spline point: Catmull-Rom : Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4, float t
FUNCTION: GetSplinePointBezierQuad         ( a a a %f -- a )        \ Get (evaluate) spline point: Quadratic Bezier : Vector2 p1, Vector2 c2, Vector2 p3, float t
FUNCTION: GetSplinePointBezierCubic        ( a a a a %f -- a )      \ Get (evaluate) spline point: Cubic Bezier : Vector2 p1, Vector2 c2, Vector2 c3, Vector2 p4, float t

\ Basic shapes collision detection Module
FUNCTION: CheckCollisionRecs               ( a a -- i )             \ Check collision between two rectangles : Rectangle rec1, Rectangle rec2
FUNCTION: CheckCollisionCircles            ( a %f a %f -- i )       \ Check collision between two circles : Vector2 center1, float radius1, Vector2 center2, float radius2
FUNCTION: CheckCollisionCircleRec          ( a %f a -- i )          \ Check collision between circle and rectangle : Vector2 center, float radius, Rectangle rec
FUNCTION: CheckCollisionCircleLine         ( a %f a a -- i )        \ Check if circle collides with a line created betweeen two points [p1] and [p2] : Vector2 center, float radius, Vector2 p1, Vector2 p2
FUNCTION: CheckCollisionPointRec           ( a a -- i )             \ Check if point is inside rectangle : Vector2 point, Rectangle rec
FUNCTION: CheckCollisionPointCircle        ( a a %f -- i )          \ Check if point is inside circle : Vector2 point, Vector2 center, float radius
FUNCTION: CheckCollisionPointTriangle      ( a a a a -- i )         \ Check if point is inside a triangle : Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3
FUNCTION: CheckCollisionPointLine          ( a a a i -- i )         \ Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold] : Vector2 point, Vector2 p1, Vector2 p2, int threshold
FUNCTION: CheckCollisionPointPoly          ( a a i -- i )           \ Check if point is within a polygon described by array of vertices : Vector2 point, const Vector2 *points, int pointCount
FUNCTION: CheckCollisionLines              ( a a a a a -- i )       \ Check the collision between two lines defined by two points each, returns collision point by reference : Vector2 startPos1, Vector2 endPos1, Vector2 startPos2, Vector2 endPos2, Vector2 *collisionPoint
FUNCTION: GetCollisionRec                  ( a a -- a )             \ Get collision rectangle for two rectangles collision : Rectangle rec1, Rectangle rec2

\ Image loading Module

\ NOTE: These Module do not require GPU access
FUNCTION: LoadImage                        ( a -- a )               \ Load image from file into CPU memory (RAM) : const char *fileName
FUNCTION: LoadImageRaw                     ( a i i i i -- a )       \ Load image from RAW file data : const char *fileName, int width, int height, int format, int headerSize
FUNCTION: LoadImageAnim                    ( a a -- a )             \ Load image sequence from file (frames appended to image.data) : const char *fileName, int *frames
FUNCTION: LoadImageAnimFromMemory          ( a a i a -- a )         \ Load image sequence from memory buffer : const char *fileType, const unsigned char *fileData, int dataSize, int *frames
FUNCTION: LoadImageFromMemory              ( a a i -- a )           \ Load image from memory buffer, fileType refers to extension: i.e. '.png' : const char *fileType, const unsigned char *fileData, int dataSize
FUNCTION: LoadImageFromTexture             ( a -- a )               \ Load image from GPU texture data : Texture2D texture
FUNCTION: LoadImageFromScreen              ( -- a )                 \ Load image from screen buffer and (screenshot) : void
FUNCTION: IsImageValid                     ( a -- i )               \ Check if an image is valid (data and parameters) : Image image
FUNCTION: UnloadImage                      ( a -- )                 \ Unload image from CPU memory (RAM) : Image image
FUNCTION: ExportImage                      ( a a -- i )             \ Export image data to file, returns true on success : Image image, const char *fileName
FUNCTION: ExportImageToMemory              ( a a a -- a )           \ Export image to memory buffer : Image image, const char *fileType, int *fileSize
FUNCTION: ExportImageAsCode                ( a a -- i )             \ Export image as code file defining an array of bytes, returns true on success : Image image, const char *fileName

\ Image generation Module
FUNCTION: GenImageColor                    ( i i u -- a )           \ Generate image: plain color : int width, int height, Color color
FUNCTION: GenImageGradientLinear           ( i i i u u -- a )       \ Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient : int width, int height, int direction, Color start, Color end
FUNCTION: GenImageGradientRadial           ( i i %f u u -- a )      \ Generate image: radial gradient : int width, int height, float density, Color inner, Color outer
FUNCTION: GenImageGradientSquare           ( i i %f u u -- a )      \ Generate image: square gradient : int width, int height, float density, Color inner, Color outer
FUNCTION: GenImageChecked                  ( i i i i u u -- a )     \ Generate image: checked : int width, int height, int checksX, int checksY, Color col1, Color col2
FUNCTION: GenImageWhiteNoise               ( i i %f -- a )          \ Generate image: white noise : int width, int height, float factor
FUNCTION: GenImagePerlinNoise              ( i i i i %f -- a )      \ Generate image: perlin noise : int width, int height, int offsetX, int offsetY, float scale
FUNCTION: GenImageCellular                 ( i i i -- a )           \ Generate image: cellular algorithm, bigger tileSize means bigger cells : int width, int height, int tileSize
FUNCTION: GenImageText                     ( i i a -- a )           \ Generate image: grayscale image from text data : int width, int height, const char *text

\ Image manipulation Module
FUNCTION: ImageCopy                        ( a -- a )               \ Create an image duplicate (useful for transformations) : Image image
FUNCTION: ImageFromImage                   ( a a -- a )             \ Create an image from another image piece : Image image, Rectangle rec
FUNCTION: ImageFromChannel                 ( a i -- a )             \ Create an image from a selected channel of another image (GRAYSCALE) : Image image, int selectedChannel
FUNCTION: ImageText                        ( a i u -- a )           \ Create an image from text (default font) : const char *text, int fontSize, Color color
FUNCTION: ImageTextEx                      ( a a %f %f u -- a )     \ Create an image from text (custom sprite font) : Font font, const char *text, float fontSize, float spacing, Color tint
FUNCTION: ImageFormat                      ( a i -- )               \ Convert image data to desired format : Image *image, int newFormat
FUNCTION: ImageToPOT                       ( a u -- )               \ Convert image to POT (power-of-two) : Image *image, Color fill
FUNCTION: ImageCrop                        ( a a -- )               \ Crop an image to a defined rectangle : Image *image, Rectangle crop
FUNCTION: ImageAlphaCrop                   ( a %f -- )              \ Crop image depending on alpha value : Image *image, float threshold
FUNCTION: ImageAlphaClear                  ( a u %f -- )            \ Clear alpha channel to desired color : Image *image, Color color, float threshold
FUNCTION: ImageAlphaMask                   ( a a -- )               \ Apply alpha mask to image : Image *image, Image alphaMask
FUNCTION: ImageAlphaPremultiply            ( a -- )                 \ Premultiply alpha channel : Image *image
FUNCTION: ImageBlurGaussian                ( a i -- )               \ Apply Gaussian blur using a box blur approximation : Image *image, int blurSize
FUNCTION: ImageKernelConvolution           ( a a i -- )             \ Apply custom square convolution kernel to image : Image *image, const float *kernel, int kernelSize
FUNCTION: ImageResize                      ( a i i -- )             \ Resize image (Bicubic scaling algorithm) : Image *image, int newWidth, int newHeight
FUNCTION: ImageResizeNN                    ( a i i -- )             \ Resize image (Nearest-Neighbor scaling algorithm) : Image *image, int newWidth,int newHeight
FUNCTION: ImageResizeCanvas                ( a i i i i u -- )       \ Resize canvas and fill with color : Image *image, int newWidth, int newHeight, int offsetX, int offsetY, Color fill
FUNCTION: ImageMipmaps                     ( a -- )                 \ Compute all mipmap levels for a provided image : Image *image
FUNCTION: ImageDither                      ( a i i i i -- )         \ Dither image data to 16bpp or lower (Floyd-Steinberg dithering) : Image *image, int rBpp, int gBpp, int bBpp, int aBpp
FUNCTION: ImageFlipVertical                ( a -- )                 \ Flip image vertically : Image *image
FUNCTION: ImageFlipHorizontal              ( a -- )                 \ Flip image horizontally : Image *image
FUNCTION: ImageRotate                      ( a i -- )               \ Rotate image by input angle in degrees (-359 to 359) : Image *image, int degrees
FUNCTION: ImageRotateCW                    ( a -- )                 \ Rotate image clockwise 90deg : Image *image
FUNCTION: ImageRotateCCW                   ( a -- )                 \ Rotate image counter-clockwise 90deg : Image *image
FUNCTION: ImageColorTint                   ( a u -- )               \ Modify image color: tint : Image *image, Color color
FUNCTION: ImageColorInvert                 ( a -- )                 \ Modify image color: invert : Image *image
FUNCTION: ImageColorGrayscale              ( a -- )                 \ Modify image color: grayscale : Image *image
FUNCTION: ImageColorContrast               ( a %f -- )              \ Modify image color: contrast (-100 to 100) : Image *image, float contrast
FUNCTION: ImageColorBrightness             ( a i -- )               \ Modify image color: brightness (-255 to 255) : Image *image, int brightness
FUNCTION: ImageColorReplace                ( a u u -- )             \ Modify image color: replace color : Image *image, Color color, Color replace
FUNCTION: LoadImageColors                  ( a -- a )               \ Load color data from image as a Color array (RGBA - 32bit) : Image image
FUNCTION: LoadImagePalette                 ( a i a -- a )           \ Load colors palette from image as a Color array (RGBA - 32bit) : Image image, int maxPaletteSize, int *colorCount
FUNCTION: UnloadImageColors                ( a -- )                 \ Unload color data loaded with LoadImageColors() : Color *colors
FUNCTION: UnloadImagePalette               ( a -- )                 \ Unload colors palette loaded with LoadImagePalette() : Color *colors
FUNCTION: GetImageAlphaBorder              ( a %f -- a )            \ Get image alpha border rectangle : Image image, float threshold
FUNCTION: GetImageColor                    ( a i i -- u )           \ Get image pixel color at (x, y) position : Image image, int x, int y

\ Image drawing Module

\ NOTE: Image software-rendering Module (CPU)
FUNCTION: ImageClearBackground             ( a u -- )               \ Clear image background with given color : Image *dst, Color color
FUNCTION: ImageDrawPixel                   ( a i i u -- )           \ Draw pixel within an image : Image *dst, int posX, int posY, Color color
FUNCTION: ImageDrawPixelV                  ( a a u -- )             \ Draw pixel within an image (Vector version) : Image *dst, Vector2 position, Color color
FUNCTION: ImageDrawLine                    ( a i i i i u -- )       \ Draw line within an image : Image *dst, int startPosX, int startPosY, int endPosX, int endPosY, Color color
FUNCTION: ImageDrawLineV                   ( a a a u -- )           \ Draw line within an image (Vector version) : Image *dst, Vector2 start, Vector2 end, Color color
FUNCTION: ImageDrawLineEx                  ( a a a i u -- )         \ Draw a line defining thickness within an image : Image *dst, Vector2 start, Vector2 end, int thick, Color color
FUNCTION: ImageDrawCircle                  ( a i i i u -- )         \ Draw a filled circle within an image : Image *dst, int centerX, int centerY, int radius, Color color
FUNCTION: ImageDrawCircleV                 ( a a i u -- )           \ Draw a filled circle within an image (Vector version) : Image *dst, Vector2 center, int radius, Color color
FUNCTION: ImageDrawCircleLines             ( a i i i u -- )         \ Draw circle outline within an image : Image *dst, int centerX, int centerY, int radius, Color color
FUNCTION: ImageDrawCircleLinesV            ( a a i u -- )           \ Draw circle outline within an image (Vector version) : Image *dst, Vector2 center, int radius, Color color
FUNCTION: ImageDrawRectangle               ( a i i i i u -- )       \ Draw rectangle within an image : Image *dst, int posX, int posY, int width, int height, Color color
FUNCTION: ImageDrawRectangleV              ( a a a u -- )           \ Draw rectangle within an image (Vector version) : Image *dst, Vector2 position, Vector2 size, Color color
FUNCTION: ImageDrawRectangleRec            ( a a u -- )             \ Draw rectangle within an image : Image *dst, Rectangle rec, Color color
FUNCTION: ImageDrawRectangleLines          ( a a i u -- )           \ Draw rectangle lines within an image : Image *dst, Rectangle rec, int thick, Color color
FUNCTION: ImageDrawTriangle                ( a a a a u -- )         \ Draw triangle within an image : Image *dst, Vector2 v1, Vector2 v2, Vector2 v3, Color color
FUNCTION: ImageDrawTriangleEx              ( a a a a u u u -- )     \ Draw triangle with interpolated colors within an image : Image *dst, Vector2 v1, Vector2 v2, Vector2 v3, Color c1, Color c2, Color c3
FUNCTION: ImageDrawTriangleLines           ( a a a a u -- )         \ Draw triangle outline within an image : Image *dst, Vector2 v1, Vector2 v2, Vector2 v3, Color color
FUNCTION: ImageDrawTriangleFan             ( a a i u -- )           \ Draw a triangle fan defined by points within an image (first vertex is the center) : Image *dst, Vector2 *points, int pointCount, Color color
FUNCTION: ImageDrawTriangleStrip           ( a a i u -- )           \ Draw a triangle strip defined by points within an image : Image *dst, Vector2 *points, int pointCount, Color color
FUNCTION: ImageDraw                        ( a a a a u -- )         \ Draw a source image within a destination image (tint applied to source) : Image *dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint
FUNCTION: ImageDrawText                    ( a a i i i u -- )       \ Draw text (using default font) within an image (destination) : Image *dst, const char *text, int posX, int posY, int fontSize, Color color
FUNCTION: ImageDrawTextEx                  ( a a a a %f %f u -- )   \ Draw text (custom sprite font) within an image (destination) : Image *dst, Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint

\ Texture loading Module

\ NOTE: These Module require GPU access
FUNCTION: LoadTexture                      ( a -- a )               \ Load texture from file into GPU memory (VRAM) : const char *fileName
FUNCTION: LoadTextureFromImage             ( a -- a )               \ Load texture from image data : Image image
FUNCTION: LoadTextureCubemap               ( a i -- a )             \ Load cubemap from image, multiple image cubemap layouts supported : Image image, int layout
FUNCTION: LoadRenderTexture                ( i i -- a )             \ Load texture for rendering (framebuffer) : int width, int height
FUNCTION: IsTextureValid                   ( a -- i )               \ Check if a texture is valid (loaded in GPU) : Texture2D texture
FUNCTION: UnloadTexture                    ( a -- )                 \ Unload texture from GPU memory (VRAM) : Texture2D texture
FUNCTION: IsRenderTextureValid             ( a -- i )               \ Check if a render texture is valid (loaded in GPU) : RenderTexture2D target
FUNCTION: UnloadRenderTexture              ( a -- )                 \ Unload render texture from GPU memory (VRAM) : RenderTexture2D target
FUNCTION: UpdateTexture                    ( a a -- )               \ Update GPU texture with new data : Texture2D texture, const void *pixels
FUNCTION: UpdateTextureRec                 ( a a a -- )             \ Update GPU texture rectangle with new data : Texture2D texture, Rectangle rec, const void *pixels

\ Texture configuration Module
FUNCTION: GenTextureMipmaps                ( a -- )                 \ Generate GPU mipmaps for a texture : Texture2D *texture
FUNCTION: SetTextureFilter                 ( a i -- )               \ Set texture scaling filter mode : Texture2D texture, int filter
FUNCTION: SetTextureWrap                   ( a i -- )               \ Set texture wrapping mode : Texture2D texture, int wrap

\ Texture drawing Module
FUNCTION: DrawTexture                      ( a i i u -- )           \ Draw a Texture2D : Texture2D texture, int posX, int posY, Color tint
FUNCTION: DrawTextureV                     ( a a u -- )             \ Draw a Texture2D with position defined as Vector2 : Texture2D texture, Vector2 position, Color tint
FUNCTION: DrawTextureEx                    ( a a %f %f u -- )       \ Draw a Texture2D with extended parameters : Texture2D texture, Vector2 position, float rotation, float scale, Color tint
FUNCTION: DrawTextureRec                   ( a a a u -- )           \ Draw a part of a texture defined by a rectangle : Texture2D texture, Rectangle source, Vector2 position, Color tint
FUNCTION: DrawTexturePro                   ( a a a a %f u -- )      \ Draw a part of a texture defined by a rectangle with 'pro' parameters : Texture2D texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint
FUNCTION: DrawTextureNPatch                ( a a a a %f u -- )      \ Draws a texture (or part of it) that stretches or shrinks nicely : Texture2D texture, NPatchInfo nPatchInfo, Rectangle dest, Vector2 origin, float rotation, Color tint

\ Color/pixel related Module
FUNCTION: ColorIsEqual                     ( u u -- i )             \ Check if two colors are equal : Color col1, Color col2
FUNCTION: Fade                             ( u %f -- u )            \ Get color with alpha applied, alpha goes from 0.0f to 1.0f : Color color, float alpha
FUNCTION: ColorToInt                       ( u -- i )               \ Get hexadecimal value for a Color (0xRRGGBBAA) : Color color
FUNCTION: ColorNormalize                   ( u -- a )               \ Get Color normalized as float [0..1] : Color color
FUNCTION: ColorFromNormalized              ( a -- u )               \ Get Color from normalized values [0..1] : Vector4 normalized
FUNCTION: ColorToHSV                       ( u -- a )               \ Get HSV values for a Color, hue [0..360], saturation/value [0..1] : Color color
FUNCTION: ColorFromHSV                     ( %f %f %f -- u )        \ Get a Color from HSV values, hue [0..360], saturation/value [0..1] : float hue, float saturation, float value
FUNCTION: ColorTint                        ( u u -- u )             \ Get color multiplied with another color : Color color, Color tint
FUNCTION: ColorBrightness                  ( u %f -- u )            \ Get color with brightness correction, brightness factor goes from -1.0f to 1.0f : Color color, float factor
FUNCTION: ColorContrast                    ( u %f -- u )            \ Get color with contrast correction, contrast values between -1.0f and 1.0f : Color color, float contrast
FUNCTION: ColorAlpha                       ( u %f -- u )            \ Get color with alpha applied, alpha goes from 0.0f to 1.0f : Color color, float alpha
FUNCTION: ColorAlphaBlend                  ( u u u -- u )           \ Get src alpha-blended into dst color with tint : Color dst, Color src, Color tint
FUNCTION: ColorLerp                        ( u u %f -- u )          \ Get color lerp interpolation between two colors, factor [0.0f..1.0f] : Color color1, Color color2, float factor
FUNCTION: GetColor                         ( u -- u )               \ Get Color structure from hexadecimal value : unsigned int hexValue
FUNCTION: GetPixelColor                    ( a i -- u )             \ Get Color from a source pixel pointer of certain format : void *srcPtr, int format
FUNCTION: SetPixelColor                    ( a u i -- )             \ Set color formatted into destination pixel pointer : void *dstPtr, Color color, int format
FUNCTION: GetPixelDataSize                 ( i i i -- i )           \ Get pixel data size in bytes for certain format : int width, int height, int format

\ Font loading/unloading Module
FUNCTION: GetFontDefault                   ( -- a )                 \ Get the default Font : void
FUNCTION: LoadFont                         ( a -- a )               \ Load font from file into GPU memory (VRAM) : const char *fileName
FUNCTION: LoadFontEx                       ( a i a i -- a )         \ Load font from file with extended parameters, use NULL for codepoints and 0 for codepointCount to load the default character set, font size is provided in pixels height : const char *fileName, int fontSize, int *codepoints, int codepointCount
FUNCTION: LoadFontFromImage                ( a u i -- a )           \ Load font from Image (XNA style) : Image image, Color key, int firstChar
FUNCTION: LoadFontFromMemory               ( a a i i a i -- a )     \ Load font from memory buffer, fileType refers to extension: i.e. '.ttf' : const char *fileType, const unsigned char *fileData, int dataSize, int fontSize, int *codepoints, int codepointCount
FUNCTION: IsFontValid                      ( a -- i )               \ Check if a font is valid (font data loaded, WARNING: GPU texture not checked) : Font font
FUNCTION: LoadFontData                     ( a i i a i i -- a )     \ Load font data for further use : const unsigned char *fileData, int dataSize, int fontSize, int *codepoints, int codepointCount, int type
FUNCTION: GenImageFontAtlas                ( a a i i i i -- a )     \ Generate image font atlas using chars info : const GlyphInfo *glyphs, Rectangle **glyphRecs, int glyphCount, int fontSize, int padding, int packMethod
FUNCTION: UnloadFontData                   ( a i -- )               \ Unload font chars info data (RAM) : GlyphInfo *glyphs, int glyphCount
FUNCTION: UnloadFont                       ( a -- )                 \ Unload font from GPU memory (VRAM) : Font font
FUNCTION: ExportFontAsCode                 ( a a -- i )             \ Export font as code file, returns true on success : Font font, const char *fileName

\ Text drawing Module
FUNCTION: DrawFPS                          ( i i -- )               \ Draw current FPS : int posX, int posY
FUNCTION: DrawText                         ( a i i i u -- )         \ Draw text (using default font) : const char *text, int posX, int posY, int fontSize, Color color
FUNCTION: DrawTextEx                       ( a a a %f %f u -- )     \ Draw text using font and additional parameters : Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint
FUNCTION: DrawTextPro                      ( a a a a %f %f %f u -- ) \ Draw text using Font and pro parameters (rotation) : Font font, const char *text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, Color tint
FUNCTION: DrawTextCodepoint                ( a i a %f u -- )        \ Draw one character (codepoint) : Font font, int codepoint, Vector2 position, float fontSize, Color tint
FUNCTION: DrawTextCodepoints               ( a a i a %f %f u -- )   \ Draw multiple character (codepoint) : Font font, const int *codepoints, int codepointCount, Vector2 position, float fontSize, float spacing, Color tint

\ Text font info Module
FUNCTION: SetTextLineSpacing               ( i -- )                 \ Set vertical line spacing when drawing with line-breaks : int spacing
FUNCTION: MeasureText                      ( a i -- i )             \ Measure string width for default font : const char *text, int fontSize
FUNCTION: MeasureTextEx                    ( a a %f %f -- a )       \ Measure string size for Font : Font font, const char *text, float fontSize, float spacing
FUNCTION: GetGlyphIndex                    ( a i -- i )             \ Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found : Font font, int codepoint
FUNCTION: GetGlyphInfo                     ( a i -- a )             \ Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found : Font font, int codepoint
FUNCTION: GetGlyphAtlasRec                 ( a i -- a )             \ Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found : Font font, int codepoint

\ Text codepoints management Module (unicode characters)
FUNCTION: LoadUTF8                         ( a i -- a )             \ Load UTF-8 text encoded from codepoints array : const int *codepoints, int length
FUNCTION: UnloadUTF8                       ( a -- )                 \ Unload UTF-8 text encoded from codepoints array : char *text
FUNCTION: LoadCodepoints                   ( a a -- a )             \ Load all codepoints from a UTF-8 text string, codepoints count returned by parameter : const char *text, int *count
FUNCTION: UnloadCodepoints                 ( a -- )                 \ Unload codepoints data from memory : int *codepoints
FUNCTION: GetCodepointCount                ( a -- i )               \ Get total number of codepoints in a UTF-8 encoded string : const char *text
FUNCTION: GetCodepoint                     ( a a -- i )             \ Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure : const char *text, int *codepointSize
FUNCTION: GetCodepointNext                 ( a a -- i )             \ Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure : const char *text, int *codepointSize
FUNCTION: GetCodepointPrevious             ( a a -- i )             \ Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure : const char *text, int *codepointSize
FUNCTION: CodepointToUTF8                  ( i a -- a )             \ Encode one codepoint into UTF-8 byte array (array length returned as parameter) : int codepoint, int *utf8Size

\ Text strings management Module (no UTF-8 strings, only byte chars)
FUNCTION: TextCopy                         ( a a -- i )             \ Copy one string to another, returns bytes copied : char *dst, const char *src
FUNCTION: TextIsEqual                      ( a a -- i )             \ Check if two text string are equal : const char *text1, const char *text2
FUNCTION: TextLength                       ( a -- u )               \ Get text length, checks for '\0' ending : const char *text
FUNCTION: TextFormat                       ( a -- a )               \ Text formatting with variables (sprintf() style) : const char *text, ...
FUNCTION: TextSubtext                      ( a i i -- a )           \ Get a piece of a text string : const char *text, int position, int length
FUNCTION: TextReplace                      ( a a a -- a )           \ Replace text string (WARNING: memory must be freed!) : const char *text, const char *replace, const char *by
FUNCTION: TextInsert                       ( a a i -- a )           \ Insert text in a position (WARNING: memory must be freed!) : const char *text, const char *insert, int position
FUNCTION: TextJoin                         ( a i a -- a )           \ Join text strings with delimiter : const char **textList, int count, const char *delimiter
FUNCTION: TextSplit                        ( a a a -- *a )          \ Split text into multiple strings : const char *text, char delimiter, int *count
FUNCTION: TextAppend                       ( a a a -- )             \ Append text at specific position and move cursor! : char *text, const char *append, int *position
FUNCTION: TextFindIndex                    ( a a -- i )             \ Find first text occurrence within a string : const char *text, const char *find
FUNCTION: TextToUpper                      ( a -- a )               \ Get upper case version of provided string : const char *text
FUNCTION: TextToLower                      ( a -- a )               \ Get lower case version of provided string : const char *text
FUNCTION: TextToPascal                     ( a -- a )               \ Get Pascal case notation version of provided string : const char *text
FUNCTION: TextToSnake                      ( a -- a )               \ Get Snake case notation version of provided string : const char *text
FUNCTION: TextToCamel                      ( a -- a )               \ Get Camel case notation version of provided string : const char *text
FUNCTION: TextToInteger                    ( a -- i )               \ Get integer value from text (negative values not supported) : const char *text
FUNCTION: TextToFloat                      ( a -- %f )              \ Get float value from text (negative values not supported) : const char *text

\ Basic geometric 3D shapes drawing Module
FUNCTION: DrawLine3D                       ( a a u -- )             \ Draw a line in 3D world space : Vector3 startPos, Vector3 endPos, Color color
FUNCTION: DrawPoint3D                      ( a u -- )               \ Draw a point in 3D space, actually a small line : Vector3 position, Color color
FUNCTION: DrawCircle3D                     ( a %f a %f u -- )       \ Draw a circle in 3D world space : Vector3 center, float radius, Vector3 rotationAxis, float rotationAngle, Color color
FUNCTION: DrawTriangle3D                   ( a a a u -- )           \ Draw a color-filled triangle (vertex in counter-clockwise order!) : Vector3 v1, Vector3 v2, Vector3 v3, Color color
FUNCTION: DrawTriangleStrip3D              ( a i u -- )             \ Draw a triangle strip defined by points : const Vector3 *points, int pointCount, Color color
FUNCTION: DrawCube                         ( a %f %f %f u -- )      \ Draw cube : Vector3 position, float width, float height, float length, Color color
FUNCTION: DrawCubeV                        ( a a u -- )             \ Draw cube (Vector version) : Vector3 position, Vector3 size, Color color
FUNCTION: DrawCubeWires                    ( a %f %f %f u -- )      \ Draw cube wires : Vector3 position, float width, float height, float length, Color color
FUNCTION: DrawCubeWiresV                   ( a a u -- )             \ Draw cube wires (Vector version) : Vector3 position, Vector3 size, Color color
FUNCTION: DrawSphere                       ( a %f u -- )            \ Draw sphere : Vector3 centerPos, float radius, Color color
FUNCTION: DrawSphereEx                     ( a %f i i u -- )        \ Draw sphere with extended parameters : Vector3 centerPos, float radius, int rings, int slices, Color color
FUNCTION: DrawSphereWires                  ( a %f i i u -- )        \ Draw sphere wires : Vector3 centerPos, float radius, int rings, int slices, Color color
FUNCTION: DrawCylinder                     ( a %f %f %f i u -- )    \ Draw a cylinder/cone : Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color
FUNCTION: DrawCylinderEx                   ( a a %f %f i u -- )     \ Draw a cylinder with base at startPos and top at endPos : Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color
FUNCTION: DrawCylinderWires                ( a %f %f %f i u -- )    \ Draw a cylinder/cone wires : Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color
FUNCTION: DrawCylinderWiresEx              ( a a %f %f i u -- )     \ Draw a cylinder wires with base at startPos and top at endPos : Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color
FUNCTION: DrawCapsule                      ( a a %f i i u -- )      \ Draw a capsule with the center of its sphere caps at startPos and endPos : Vector3 startPos, Vector3 endPos, float radius, int slices, int rings, Color color
FUNCTION: DrawCapsuleWires                 ( a a %f i i u -- )      \ Draw capsule wireframe with the center of its sphere caps at startPos and endPos : Vector3 startPos, Vector3 endPos, float radius, int slices, int rings, Color color
FUNCTION: DrawPlane                        ( a a u -- )             \ Draw a plane XZ : Vector3 centerPos, Vector2 size, Color color
FUNCTION: DrawRay                          ( a u -- )               \ Draw a ray line : Ray ray, Color color
FUNCTION: DrawGrid                         ( i %f -- )              \ Draw a grid (centered at (0, 0, 0)) : int slices, float spacing

\ Model management Module
FUNCTION: LoadModel                        ( a -- a )               \ Load model from files (meshes and materials) : const char *fileName
FUNCTION: LoadModelFromMesh                ( a -- a )               \ Load model from generated mesh (default material) : Mesh mesh
FUNCTION: IsModelValid                     ( a -- i )               \ Check if a model is valid (loaded in GPU, VAO/VBOs) : Model model
FUNCTION: UnloadModel                      ( a -- )                 \ Unload model (including meshes) from memory (RAM and/or VRAM) : Model model
FUNCTION: GetModelBoundingBox              ( a -- a )               \ Compute model bounding box limits (considers all meshes) : Model model

\ Model drawing Module
FUNCTION: DrawModel                        ( a a %f u -- )          \ Draw a model (with texture if set) : Model model, Vector3 position, float scale, Color tint
FUNCTION: DrawModelEx                      ( a a a %f a u -- )      \ Draw a model with extended parameters : Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint
FUNCTION: DrawModelWires                   ( a a %f u -- )          \ Draw a model wires (with texture if set) : Model model, Vector3 position, float scale, Color tint
FUNCTION: DrawModelWiresEx                 ( a a a %f a u -- )      \ Draw a model wires (with texture if set) with extended parameters : Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint
FUNCTION: DrawModelPoints                  ( a a %f u -- )          \ Draw a model as points : Model model, Vector3 position, float scale, Color tint
FUNCTION: DrawModelPointsEx                ( a a a %f a u -- )      \ Draw a model as points with extended parameters : Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint
FUNCTION: DrawBoundingBox                  ( a u -- )               \ Draw bounding box (wires) : BoundingBox box, Color color
FUNCTION: DrawBillboard                    ( a a a %f u -- )        \ Draw a billboard texture : Camera camera, Texture2D texture, Vector3 position, float scale, Color tint
FUNCTION: DrawBillboardRec                 ( a a a a a u -- )       \ Draw a billboard texture defined by source : Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector2 size, Color tint
FUNCTION: DrawBillboardPro                 ( a a a a a a a %f u -- ) \ Draw a billboard texture defined by source and rotation : Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint

\ Mesh management Module
FUNCTION: UploadMesh                       ( a i -- )               \ Upload mesh vertex data in GPU and provide VAO/VBO ids : Mesh *mesh, bool dynamic
FUNCTION: UpdateMeshBuffer                 ( a i a i i -- )         \ Update mesh vertex data in GPU for a specific buffer index : Mesh mesh, int index, const void *data, int dataSize, int offset
FUNCTION: UnloadMesh                       ( a -- )                 \ Unload mesh data from CPU and GPU : Mesh mesh
FUNCTION: DrawMesh                         ( a a a -- )             \ Draw a 3d mesh with material and transform : Mesh mesh, Material material, Matrix transform
FUNCTION: DrawMeshInstanced                ( a a a i -- )           \ Draw multiple mesh instances with material and different transforms : Mesh mesh, Material material, const Matrix *transforms, int instances
FUNCTION: GetMeshBoundingBox               ( a -- a )               \ Compute mesh bounding box limits : Mesh mesh
FUNCTION: GenMeshTangents                  ( a -- )                 \ Compute mesh tangents : Mesh *mesh
FUNCTION: ExportMesh                       ( a a -- i )             \ Export mesh data to file, returns true on success : Mesh mesh, const char *fileName
FUNCTION: ExportMeshAsCode                 ( a a -- i )             \ Export mesh as code file (.h) defining multiple arrays of vertex attributes : Mesh mesh, const char *fileName

\ Mesh generation Module
FUNCTION: GenMeshPoly                      ( i %f -- a )            \ Generate polygonal mesh : int sides, float radius
FUNCTION: GenMeshPlane                     ( %f %f i i -- a )       \ Generate plane mesh (with subdivisions) : float width, float length, int resX, int resZ
FUNCTION: GenMeshCube                      ( %f %f %f -- a )        \ Generate cuboid mesh : float width, float height, float length
FUNCTION: GenMeshSphere                    ( %f i i -- a )          \ Generate sphere mesh (standard sphere) : float radius, int rings, int slices
FUNCTION: GenMeshHemiSphere                ( %f i i -- a )          \ Generate half-sphere mesh (no bottom cap) : float radius, int rings, int slices
FUNCTION: GenMeshCylinder                  ( %f %f i -- a )         \ Generate cylinder mesh : float radius, float height, int slices
FUNCTION: GenMeshCone                      ( %f %f i -- a )         \ Generate cone/pyramid mesh : float radius, float height, int slices
FUNCTION: GenMeshTorus                     ( %f %f i i -- a )       \ Generate torus mesh : float radius, float size, int radSeg, int sides
FUNCTION: GenMeshKnot                      ( %f %f i i -- a )       \ Generate trefoil knot mesh : float radius, float size, int radSeg, int sides
FUNCTION: GenMeshHeightmap                 ( a a -- a )             \ Generate heightmap mesh from image data : Image heightmap, Vector3 size
FUNCTION: GenMeshCubicmap                  ( a a -- a )             \ Generate cubes-based map mesh from image data : Image cubicmap, Vector3 cubeSize

\ Material loading/unloading Module
FUNCTION: LoadMaterials                    ( a a -- a )             \ Load materials from model file : const char *fileName, int *materialCount
FUNCTION: LoadMaterialDefault              ( -- a )                 \ Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps) : void
FUNCTION: IsMaterialValid                  ( a -- i )               \ Check if a material is valid (shader assigned, map textures loaded in GPU) : Material material
FUNCTION: UnloadMaterial                   ( a -- )                 \ Unload material from GPU memory (VRAM) : Material material
FUNCTION: SetMaterialTexture               ( a i a -- )             \ Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...) : Material *material, int mapType, Texture2D texture
FUNCTION: SetModelMeshMaterial             ( a i i -- )             \ Set material for a mesh : Model *model, int meshId, int materialId

\ Model animations loading/unloading Module
FUNCTION: LoadModelAnimations              ( a a -- a )             \ Load model animations from file : const char *fileName, int *animCount
FUNCTION: UpdateModelAnimation             ( a a i -- )             \ Update model animation pose (CPU) : Model model, ModelAnimation anim, int frame
FUNCTION: UpdateModelAnimationBones        ( a a i -- )             \ Update model animation mesh bone matrices (GPU skinning) : Model model, ModelAnimation anim, int frame
FUNCTION: UnloadModelAnimation             ( a -- )                 \ Unload animation data : ModelAnimation anim
FUNCTION: UnloadModelAnimations            ( a i -- )               \ Unload animation array data : ModelAnimation *animations, int animCount
FUNCTION: IsModelAnimationValid            ( a a -- i )             \ Check model animation skeleton match : Model model, ModelAnimation anim

\ Collision detection Module
FUNCTION: CheckCollisionSpheres            ( a %f a %f -- i )       \ Check collision between two spheres : Vector3 center1, float radius1, Vector3 center2, float radius2
FUNCTION: CheckCollisionBoxes              ( a a -- i )             \ Check collision between two bounding boxes : BoundingBox box1, BoundingBox box2
FUNCTION: CheckCollisionBoxSphere          ( a a %f -- i )          \ Check collision between box and sphere : BoundingBox box, Vector3 center, float radius
FUNCTION: GetRayCollisionSphere            ( a a %f -- a )          \ Get collision info between ray and sphere : Ray ray, Vector3 center, float radius
FUNCTION: GetRayCollisionBox               ( a a -- a )             \ Get collision info between ray and box : Ray ray, BoundingBox box
FUNCTION: GetRayCollisionMesh              ( a a a -- a )           \ Get collision info between ray and mesh : Ray ray, Mesh mesh, Matrix transform
FUNCTION: GetRayCollisionTriangle          ( a a a a -- a )         \ Get collision info between ray and triangle : Ray ray, Vector3 p1, Vector3 p2, Vector3 p3
FUNCTION: GetRayCollisionQuad              ( a a a a a -- a )       \ Get collision info between ray and quad : Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4

\ Audio device management Module
FUNCTION: InitAudioDevice                  ( -- )                   \ Initialize audio device and context : void
FUNCTION: CloseAudioDevice                 ( -- )                   \ Close the audio device and context : void
FUNCTION: IsAudioDeviceReady               ( -- i )                 \ Check if audio device has been initialized successfully : void
FUNCTION: SetMasterVolume                  ( %f -- )                \ Set master volume (listener) : float volume
FUNCTION: GetMasterVolume                  ( -- %f )                \ Get master volume (listener) : void

\ Wave/Sound loading/unloading Module
FUNCTION: LoadWave                         ( a -- a )               \ Load wave data from file : const char *fileName
FUNCTION: LoadWaveFromMemory               ( a a i -- a )           \ Load wave from memory buffer, fileType refers to extension: i.e. '.wav' : const char *fileType, const unsigned char *fileData, int dataSize
FUNCTION: IsWaveValid                      ( a -- i )               \ Checks if wave data is valid (data loaded and parameters) : Wave wave
FUNCTION: LoadSound                        ( a -- a )               \ Load sound from file : const char *fileName
FUNCTION: LoadSoundFromWave                ( a -- a )               \ Load sound from wave data : Wave wave
FUNCTION: LoadSoundAlias                   ( a -- a )               \ Create a new sound that shares the same sample data as the source sound, does not own the sound data : Sound source
FUNCTION: IsSoundValid                     ( a -- i )               \ Checks if a sound is valid (data loaded and buffers initialized) : Sound sound
FUNCTION: UpdateSound                      ( a a i -- )             \ Update sound buffer with new data : Sound sound, const void *data, int sampleCount
FUNCTION: UnloadWave                       ( a -- )                 \ Unload wave data : Wave wave
FUNCTION: UnloadSound                      ( a -- )                 \ Unload sound : Sound sound
FUNCTION: UnloadSoundAlias                 ( a -- )                 \ Unload a sound alias (does not deallocate sample data) : Sound alias
FUNCTION: ExportWave                       ( a a -- i )             \ Export wave data to file, returns true on success : Wave wave, const char *fileName
FUNCTION: ExportWaveAsCode                 ( a a -- i )             \ Export wave sample data to code (.h), returns true on success : Wave wave, const char *fileName

\ Wave/Sound management Module
FUNCTION: PlaySound                        ( a -- )                 \ Play a sound : Sound sound
FUNCTION: StopSound                        ( a -- )                 \ Stop playing a sound : Sound sound
FUNCTION: PauseSound                       ( a -- )                 \ Pause a sound : Sound sound
FUNCTION: ResumeSound                      ( a -- )                 \ Resume a paused sound : Sound sound
FUNCTION: IsSoundPlaying                   ( a -- i )               \ Check if a sound is currently playing : Sound sound
FUNCTION: SetSoundVolume                   ( a %f -- )              \ Set volume for a sound (1.0 is max level) : Sound sound, float volume
FUNCTION: SetSoundPitch                    ( a %f -- )              \ Set pitch for a sound (1.0 is base level) : Sound sound, float pitch
FUNCTION: SetSoundPan                      ( a %f -- )              \ Set pan for a sound (0.5 is center) : Sound sound, float pan
FUNCTION: WaveCopy                         ( a -- a )               \ Copy a wave to a new wave : Wave wave
FUNCTION: WaveCrop                         ( a i i -- )             \ Crop a wave to defined frames range : Wave *wave, int initFrame, int finalFrame
FUNCTION: WaveFormat                       ( a i i i -- )           \ Convert wave data to desired format : Wave *wave, int sampleRate, int sampleSize, int channels
FUNCTION: LoadWaveSamples                  ( a -- a )               \ Load samples data from wave as a 32bit float data array : Wave wave
FUNCTION: UnloadWaveSamples                ( a -- )                 \ Unload samples data loaded with LoadWaveSamples() : float *samples

\ Music management Module
FUNCTION: LoadMusicStream                  ( a -- a )               \ Load music stream from file : const char *fileName
FUNCTION: LoadMusicStreamFromMemory        ( a a i -- a )           \ Load music stream from data : const char *fileType, const unsigned char *data, int dataSize
FUNCTION: IsMusicValid                     ( a -- i )               \ Checks if a music stream is valid (context and buffers initialized) : Music music
FUNCTION: UnloadMusicStream                ( a -- )                 \ Unload music stream : Music music
FUNCTION: PlayMusicStream                  ( a -- )                 \ Start music playing : Music music
FUNCTION: IsMusicStreamPlaying             ( a -- i )               \ Check if music is playing : Music music
FUNCTION: UpdateMusicStream                ( a -- )                 \ Updates buffers for music streaming : Music music
FUNCTION: StopMusicStream                  ( a -- )                 \ Stop music playing : Music music
FUNCTION: PauseMusicStream                 ( a -- )                 \ Pause music playing : Music music
FUNCTION: ResumeMusicStream                ( a -- )                 \ Resume playing paused music : Music music
FUNCTION: SeekMusicStream                  ( a %f -- )              \ Seek music to a position (in seconds) : Music music, float position
FUNCTION: SetMusicVolume                   ( a %f -- )              \ Set volume for music (1.0 is max level) : Music music, float volume
FUNCTION: SetMusicPitch                    ( a %f -- )              \ Set pitch for a music (1.0 is base level) : Music music, float pitch
FUNCTION: SetMusicPan                      ( a %f -- )              \ Set pan for a music (0.5 is center) : Music music, float pan
FUNCTION: GetMusicTimeLength               ( a -- %f )              \ Get music time length (in seconds) : Music music
FUNCTION: GetMusicTimePlayed               ( a -- %f )              \ Get current music time played (in seconds) : Music music

\ AudioStream management Module
FUNCTION: LoadAudioStream                  ( u u u -- a )           \ Load audio stream (to stream raw audio pcm data) : unsigned int sampleRate, unsigned int sampleSize, unsigned int channels
FUNCTION: IsAudioStreamValid               ( a -- i )               \ Checks if an audio stream is valid (buffers initialized) : AudioStream stream
FUNCTION: UnloadAudioStream                ( a -- )                 \ Unload audio stream and free memory : AudioStream stream
FUNCTION: UpdateAudioStream                ( a a i -- )             \ Update audio stream buffers with data : AudioStream stream, const void *data, int frameCount
FUNCTION: IsAudioStreamProcessed           ( a -- i )               \ Check if any audio stream buffers requires refill : AudioStream stream
FUNCTION: PlayAudioStream                  ( a -- )                 \ Play audio stream : AudioStream stream
FUNCTION: PauseAudioStream                 ( a -- )                 \ Pause audio stream : AudioStream stream
FUNCTION: ResumeAudioStream                ( a -- )                 \ Resume audio stream : AudioStream stream
FUNCTION: IsAudioStreamPlaying             ( a -- i )               \ Check if audio stream is playing : AudioStream stream
FUNCTION: StopAudioStream                  ( a -- )                 \ Stop audio stream : AudioStream stream
FUNCTION: SetAudioStreamVolume             ( a %f -- )              \ Set volume for audio stream (1.0 is max level) : AudioStream stream, float volume
FUNCTION: SetAudioStreamPitch              ( a %f -- )              \ Set pitch for audio stream (1.0 is base level) : AudioStream stream, float pitch
FUNCTION: SetAudioStreamPan                ( a %f -- )              \ Set pan for audio stream (0.5 is centered) : AudioStream stream, float pan
FUNCTION: SetAudioStreamBufferSizeDefault  ( i -- )                 \ Default size for new audio streams : int size
FUNCTION: SetAudioStreamCallback           ( a a -- )               \ Audio thread callback to request new data : AudioStream stream, AudioCallback callback
FUNCTION: AttachAudioStreamProcessor       ( a a -- )               \ Attach audio stream processor to stream, receives the samples as 'float' : AudioStream stream, AudioCallback processor
FUNCTION: DetachAudioStreamProcessor       ( a a -- )               \ Detach audio stream processor from stream : AudioStream stream, AudioCallback processor
FUNCTION: AttachAudioMixedProcessor        ( a -- )                 \ Attach audio stream processor to the entire audio pipeline, receives the samples as 'float' : AudioCallback processor
FUNCTION: DetachAudioMixedProcessor        ( a -- )                 \ Detach audio stream processor from the entire audio pipeline : AudioCallback processor
PUBLIC
: /raylib raylib +order ;
END-PACKAGE
