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
{"AudioStream", sizeof(struct AudioStream)},
{"Sound", sizeof(struct Sound)},
{"Music", sizeof(struct Music)},
{"VrDeviceInfo", sizeof(struct VrDeviceInfo)},
{"VrStereoConfig", sizeof(struct VrStereoConfig)},
{"FilePathList", sizeof(struct FilePathList)},
{"AutomationEvent", sizeof(struct AutomationEvent)},
{"AutomationEventList", sizeof(struct AutomationEventList)},
{ NULL, 0 },
};



int main(int argc, char** argv) {
	for (int i = 0; structs[i].name; ++i) {	
		printf("%8d %s\n", structs[i].size, structs[i].name);
	}

	struct AudioStream as;
	printf("%d buffer\n", (int)((int)&as.buffer - (int)&as));
	printf("%d processor\n", (int)((int)&as.processor - (int)&as));
	printf("%d sampleRate\n", (int)((int)&as.sampleRate - (int)&as));
	printf("%d sampleSize\n", (int)((int)&as.sampleSize - (int)&as));
	printf("%d channels\n", (int)((int)&as.channels - (int)&as));
	printf("%d sizeof\n", sizeof(as));


	struct Sound snd;
	printf("%d stream\n", (int)((int)&snd.stream - (int)&snd));	
	printf("%d frameCount\n", (int)((int)&snd.frameCount - (int)&snd));	
	printf("%d sizeof\n", sizeof(snd));


	struct Music mus;
	printf("%d stream\n", (int)((int)&mus.stream - (int)&mus));	
	printf("%d frameCount\n", (int)((int)&mus.frameCount - (int)&mus));	
	printf("%d looping\n", (int)((int)&mus.looping - (int)&mus));	
	printf("%d ctxType\n", (int)((int)&mus.ctxType - (int)&mus));	
	printf("%d ctxData\n", (int)((int)&mus.ctxData - (int)&mus));	
	printf("%d sizeof\n", sizeof(mus));
	
	return 0;
}
