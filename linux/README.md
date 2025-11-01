Linux Demos
-----------

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
