Linux Demos
-----------

These bindings include `../../ffi/ffi.f` so FUNCTION: marshalls
raylib structs by value under the System V AMD64 ABI.
Camera3D, Vector2, Vector3, Rectangle, Matrix, and the rest are no
longer passed as raw pointers or via the old XFUNCTION:/xcall.f path.

The library is opened as `LIBRARY libraylib.so` — the same idea as the
Windows demos loading `raylib.dll` from the default search path.  On
Linux that is the dynamic linker path (e.g. /usr/lib64/libraylib.so),
not a hardcoded filename in this tree.

Color remains a packed cell (`u`) so existing Color: helpers and the
hello/demo sources keep working.

To run the linux demos you need libraylib.so installed and in your ld.so.conf paths.

For example if you compile raylib from scratch

	RAYLIB_LIBTYPE=SHARED make
	sudo RAYLIB_LIBTYPE=SHARED make install

And then make sure in your /etc/ls.so.conf you have /usr/local/lib and then run

	sudo ldconfig

And then you can compile the demos:

	sf demo.f
	sf hello.f

And you can run the binaries

	./demo
	./hello

Press ESC to exit the demo

Regenerate FUNCTION: wrappers after a raylib.h bump:

	ruby ../port.rb ../raylib.h
	# then splice the Vector2:/Camera:/key helpers from the previous
	# raylib.f back in before END-PACKAGE, and keep include ../../ffi/ffi.f

ABI tests for the calling forms (no GPU required) live in
~/Code/x86_64/tests (make test).
