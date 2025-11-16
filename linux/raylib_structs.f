\ raylib_structs.f
 
include cstruct.f

struct Color
	c_char			red
	c_char			green
	c_char			blue
	c_char			alpha
;struct

struct Vector2
	c_float			x
	c_float			y
;struct

Vector2 extend Vector3
	c_float			z
;struct

Vector3 extend Vector4
	c_float			w
;struct

Vector4 extend Quaternion 	\ Vector4 alias
;struct	

struct Matrix			\ 4x4 matrix OpenGL style
	c_float			m0
	c_float			m4
	c_float			m8
	c_float			m12

	c_float			m1
	c_float			m5
	c_float			m9
	c_float			m13

	c_float			m2
	c_float			m6
	c_float			m10
	c_float			m14

	c_float			m3
	c_float			m7
	c_float			m11
	c_float			m15
;struct

Vector2 extend Rectangle
	c_float			rect_width
	c_float			rect_height
;struct

struct Image
	c_void*			image_data
	c_int			image_width
	c_int			image_height
	c_int			image_mipmaps
	c_int			image_format
;struct

struct Texture
	c_int 			texture_id
	c_int			texture_width
	c_int			texture_height
	c_int			texture_mipmaps
	c_int			texture_format
;struct

Texture extend Texture2D	\ another alias
;struct

Texture extend TextureCubemap	\ also an alias
;struct

struct RenderTexture
	c_int			render_texture_id
	Texture c_struct	render_texture_texture
	Texture c_struct	render_texture_depth
;struct

RenderTexture extend RenderTexture2D	\ alias
;struct

struct NPatchInfo
	Rectangle c_struct	npatchinfo_source
	c_int			npatchinfo_left
	c_int			npatchinfo_top
	c_int			npatchinfo_right
	c_int			npatchinfo_bottom
	c_int			npatchinfo_layer
;struct

struct GlyphInfo
    c_int			glyph_value
    c_int			glyph_offsetX
    c_int			glyph_offsetY
    c_int			glyph_advanceX
    Image c_struct		glyph_image
;struct

struct Font
    c_int			font_baseSize
    c_int			font_glyphCount
    c_int			font_glyphPadding
    Texture c_struct		font_texture
    c_void*			font_recs
    c_void*			font_glyphs
;struct

struct Camera3D
	Vector3 c_struct	3d_camera_position
	Vector3 c_struct	3d_camera_target
	Vector3 c_struct	3d_camera_up
	c_float			3d_camera_fovy
	c_int			3d_camera_projection
;struct

struct Camera2D
	Vector2 c_struct	2d_camera_offset
	Vector2 c_struct	2d_camera_target
	c_float			2d_camera_rotation
	c_float			2d_camera_zoom
;struct

struct Mesh
	c_int			mesh_vertexCount
	c_int			mesh_triangleCount
	c_float*		mesh_vertices
	c_float*		mesh_texcoords
	c_float*		mesh_texcoords2
	c_float*		mesh_normals
	c_float*		mesh_tangents
	c_char*			mesh_colors
	c_short*		mesh_indices
	c_float*		mesh_animVertices
	c_float*		mesh_animNormals
	c_char*			mesh_boneIds
	c_float*		mesh_boneWeights
	c_void*			mesh_boneMatrices
	c_int			mesh_boneCount
	c_int			mesh_vaoId
	c_int*			mesh_vboId
;struct

struct Shader
	c_long			shader_id
	c_int*			shader_locs
;struct

struct MaterialMap
	Texture c_struct	materialmap_texture
	Color c_struct		materialmap_color
	c_float			materialmap_value
;struct

struct Material
	Shader c_struct		material_shader
	c_void*			material_maps
	4 [] c_float		material_params
;struct

struct Transform
	Vector3 c_struct	transform_translation
	Quaternion c_struct	transform_rotation
	Vector3 c_struct	transform_scale
;struct

struct BoneInfo
	32 [] c_char		bone_name
	c_int			bone_parent
;struct

struct Model
	Matrix  c_struct	model_transform
	c_int			model_meshCount
	c_int			model_materialCount
	c_void*			model_meshes
	c_void*			model_materials
	c_int*			model_meshMaterials
	c_long			model_boneCount
	c_void*			model_bones
	c_void* 		model_bindPose
;struct

struct ModelAnimation
	c_int			modelAnimation_boneCount
	c_int			modelAnimation_frameCount
	c_void*			modelAnimation_bones
	c_void**		modelAnimation_framePoses
	32 [] c_char		name
;struct


struct Ray
	Vector3 c_struct	ray_position
	Vector3 c_struct	ray_direction
;struct

struct RayCollision
	c_int			ray_hit
	c_float			ray_distance
	Vector3 c_struct	ray_point
	Vector3 c_struct	ray_normal
;struct	

struct BoundingBox
	Vector3 c_struct	bounds_min
	Vector3 c_struct	bounds_max
;struct

struct Wave
	c_int			wave_frameCount
	c_int			wave_sampleRate
	c_int			wave_sampleSize
	c_int			wave_channels
	c_void*			wave_data
;struct

struct AudioStream
	c_void*			audioStream_buffer
	c_void*			audioStream_procesor
	c_int			audioStream_sampleRate
	c_int			audioStream_sampleSize
	c_int			audioStream_channels
	c_int			audooStream_padding		\ don't know what this is but it looks like it is compiled
;struct

struct Sound
	AudioStream c_struct	sound_stream
	c_int			sound_frameCount
	c_int			sound_padding
;struct

struct Music
	AudioStream c_struct	music_stream
	c_int			music_frameCount
	c_int			music_looping
	c_int			music_ctxType
	c_int			music_padding			\ need to align pointer
	c_void*			music_ctxData
;struct

struct VrDeviceInfo
	c_int			vrDeviceInfo_hResolution
	c_int			vrDeviceInfo_vResolution
	c_float			vrDeviceInfo_hScreenSize
	c_float			vrDeviceInfo_vScreenSize
	c_float			vrDeviceInfo_eyeToScreenDistance
	c_float			vrDeviceInfo_lenseSeparationDistance
	c_float			vrDeviceIndo_interpupillaryDistance
    	4 [] c_float		vrDeviceIndo_lensDistortionValues
    	4 [] c_float		vrDeviceIndo_chromaAbCorrection
;struct

struct VrStereoConfig
	2 [] Matrix c_struct 	vrStereoConfig_projection
    	2 [] Matrix c_struct	vrStereCconfig_viewOffset
	2 [] c_float		vrStereoConfig_leftLensCenter
	2 [] c_float		vrStereoConfig_rightLensCenter
	2 [] c_float		vrStereoConfig_leftScreenCenter
	2 [] c_float		vrStereoConfig_rightScreenCenter
	2 [] c_float		vrStereoConfig_scale
	2 [] c_float		vrStereoConfig_scaleIn
;struct

struct FilePathList
	c_int			filePathList_capacity
	c_int			filePathList_count
	c_void**		filePathList_paths
;struct

struct AutomationEvent
	c_int			automationEvent_frame
	c_int			automationEvent_type
	4 [] c_int		automationEvent_params
;struct

struct AutomationEventList
	c_int			automationEventList_capacity
	c_int			automationEventList_count
	c_void*			automationEventList_events
;struct


: test
Color . ." Color" cr
Vector2 . ." Vector2" cr
Matrix . ." Matrix" cr
Image . ." Image" cr
Texture . ." Texture" cr
RenderTexture . ." RenderTexture" cr
NPatchInfo . ." NPatchInfo" cr
GlyphInfo . ." GlyphInfo" cr
Font . ." Font" cr
Camera3D . ." Camera3D" cr
Camera2D . ." Camera2D" cr
Mesh . ." Mesh" cr
Shader . ." Shader" cr
MaterialMap . ." MaterialMap" cr
Material . ." Material" cr
Transform . ." Transform" cr
BoneInfo . ." BoneInfo" cr
Model . ." Model" cr
ModelAnimation . ." ModelAnimation" cr
Ray . ." Ray" cr
RayCollision . ." RayCollision" cr
BoundingBox . ." BoundingBox" cr
Wave . ." Wave" cr
AudioStream . ." AudioStream" cr
Sound . ." Sound" cr
Music . ." Music" cr
VrDeviceInfo . ." VrDeviceInfo" cr
VrStereoConfig . ." VrStereoConfig" cr
FilePathList . ." FilePathList" cr
AutomationEvent . ." AutomationEvent" cr
AutomationEventList . ." AutomationEventList" cr
;

test
