SwiftForth bindings for Raylib
------------------------------

This is an experimental binding for [raylib](https://github.com/raysan5/raylib) to the [SwiftForth](https://www.forth.com/swiftforth/) FFI.

The implementation is via a quick and dirty ruby script that takes the 597 RLAPI functions and exports
them via the SwiftForth FUNCTION: defining word.  I have tried to preserve the original comments and
provide enough information about the type signatures.

Some gotachs...

1.) Some structures are passed by value on 64 bit x86, for example Color is passed as a RGBA value in a register
2.) All of the char\* stuff should take z" strings. However in practice it might be wise to create a strings file
3.) I've run into some issues with the SwiftForth 4.0.x FFI with some functions, still working through the assembler.

- Dave
