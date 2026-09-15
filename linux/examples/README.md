Forth ports of ~/Code/raylib/examples
====================================

Each `*.f` is a straight port of the matching `*.c`.  Shared setup is
`common.f` (loads `raylib.f`, `raymath.f`, scratch vectors).

Compile-check (does not open a window):

    : EXAMPLE-NO-RUN ;
    include examples/common.f
    include examples/core/core_basic_window.f

Run:

    cd ~/forth/raylib.f/linux
    sf64 include examples/common.f include examples/core/core_basic_window.f

Turnkey binaries into `examples/bin/`:

    cd ~/forth/raylib.f/linux
    sf64 include examples/example.f

    examples/bin/core_basic_window

Batch test (compile-check, then a 4s hidden-window smoke run):

    examples/test-examples.sh

Cstruct type names are `/Music`, `/Font`, `/Mesh`, … (the byte size) so
example buffers can be called `music`, `font`, `mesh` without being
shadowed.  Vector fields are `Vector2.x` / `.x`, not a bare `x`.

Resources are loaded from `/home/dave/Code/raylib/examples/<dir>/resources/`.
