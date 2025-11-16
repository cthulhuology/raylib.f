#include <raylib.h>
#include <stdlib.h>
#include <stdio.h>

struct _structs {
	char* name;
	int    size;
} structs[] = {

{"Color", sizeof(struct Color)},
{"Vector2", sizeof(struct Vector2)},
{"Matrix", sizeof(struct Matrix)},
{"Image", sizeof(struct Image)},
{"Texture", sizeof(struct Texture)},
{"RenderTexture", sizeof(struct RenderTexture)},
{"NPatchInfo", sizeof(struct NPatchInfo)},
{"GlyphInfo", sizeof(struct GlyphInfo)},
{"Font", sizeof(struct Font)},
{"Camera3D", sizeof(struct Camera3D)},
{"Camera2D", sizeof(struct Camera2D)},
{"Mesh", sizeof(struct Mesh)},
{"Shader", sizeof(struct Shader)},
{"MaterialMap", sizeof(struct MaterialMap)},
{"Material", sizeof(struct Material)},
{"Transform", sizeof(struct Transform)},
{"BoneInfo", sizeof(struct BoneInfo)},
{"Model", sizeof(struct Model)},
{"ModelAnimation", sizeof(struct ModelAnimation)},
{"Ray", sizeof(struct Ray)},
{"RayCollision", sizeof(struct RayCollision)},
{"BoundingBox", sizeof(struct BoundingBox)},
{"Wave", sizeof(struct Wave)},
{ NULL, 0 },
};



int main(int argc, char** argv) {
	for (int i = 0; structs[i].name; ++i) {	
		printf("%8d %s\n", structs[i].size, structs[i].name);
	}
	return 0;
}
