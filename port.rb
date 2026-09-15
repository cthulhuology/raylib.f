# raylib_to_forth.rb
# Ruby script to parse raylib.h (provided as raylib.h) and generate SwiftForth FUNCTION: wrappers

require 'fileutils'

# Normalize type by removing 'const'
def normalize_type(t)
  t.strip.gsub(/const\s+/, '')
end

# Default to "a" for unmapped types (structs, pointers, etc.)
def map_type(t)
	# List of struct types defined in raylib.h
	struct_types = %w[
	  Vector2 Vector3 Vector4 Quaternion Matrix Color Rectangle Image Texture Texture2D TextureCubemap
	  RenderTexture RenderTexture2D NPatchInfo GlyphInfo Font Camera3D Camera Camera2D Mesh Shader
	  MaterialMap Material Transform BoneInfo Model ModelAnimation Ray RayCollision BoundingBox Wave
	  AudioStream Sound Music VrDeviceInfo VrStereoConfig FilePathList AutomationEventList
	]
	# Type mapping for Forth stack.  By-value structs use ffi.f ABI
	# tokens; Color stays a packed cell (INTEGER 4) to match Color: helpers.
	type_map = {
	  "void" => "",
	  "int" => "i",
	  "unsigned int" => "u",
	  "float" => "%f",
	  "double" => "%%d",
	  "bool" => "i",
	  "char *" => "a",
	  "unsigned char *" => "a",
	  "void *" => "a",
	  "const char *" => "a",
	  "const unsigned char *" => "a",
	  "const void *" => "a",
	  "const int *" => "a",
	  "const float *" => "a",
	  "const Vector2 *" => "a",
	  "const Vector3 *" => "a",
	  "const Matrix *" => "a",
	  "Image *" => "a",
	  "Material *" => "a",
	  "ModelAnimation *" => "a",
	  "GlyphInfo *" => "a",
	  "Rectangle **" => "*a",
	  "char **" => "*a",
	  "float *" => "a",
	  "int *" => "a",
	  "AutomationEvent *" => "a",
	  "Matrix *" => "a",
	  "Color" => "u",
	  "Vector2" => "{%8}",
	  "Vector3" => "{%12}",
	  "Vector4" => "{%16}",
	  "Quaternion" => "{%16}",
	  "Rectangle" => "{%16}",
	  "Matrix" => "{64}",
	  "Camera3D" => "{44}",
	  "Camera" => "{44}",
	  "Camera2D" => "{24}",
	  "Image" => "{24}",
	  "Texture" => "{20}",
	  "Texture2D" => "{20}",
	  "TextureCubemap" => "{20}",
	  "RenderTexture" => "{44}",
	  "RenderTexture2D" => "{44}",
	  "NPatchInfo" => "{36}",
	  "GlyphInfo" => "{40}",
	  "Font" => "{48}",
	  "Mesh" => "{120}",
	  "Shader" => "{16}",
	  "MaterialMap" => "{28}",
	  "Material" => "{40}",
	  "Transform" => "{40}",
	  "BoneInfo" => "{36}",
	  "Model" => "{120}",
	  "ModelAnimation" => "{56}",
	  "Ray" => "{24}",
	  "RayCollision" => "{32}",
	  "BoundingBox" => "{24}",
	  "Wave" => "{24}",
	  "AudioStream" => "{32}",
	  "Sound" => "{40}",
	  "Music" => "{56}",
	  "VrDeviceInfo" => "{60}",
	  "VrStereoConfig" => "{304}",
	  "FilePathList" => "{16}",
	  "AutomationEvent" => "{24}",
	  "AutomationEventList" => "{16}"
	}
	nt = normalize_type(t)
	type_map[nt] || "a"
end

# Check if type is a struct returned by value
def is_struct_by_value?(t)
	struct_types = %w[
	  Vector2 Vector3 Vector4 Quaternion Matrix Color Rectangle Image Texture Texture2D TextureCubemap
	  RenderTexture RenderTexture2D NPatchInfo GlyphInfo Font Camera3D Camera Camera2D Mesh Shader
	  MaterialMap Material Transform BoneInfo Model ModelAnimation Ray RayCollision BoundingBox Wave
	  AudioStream Sound Music VrDeviceInfo VrStereoConfig FilePathList AutomationEventList
	]
	nt = normalize_type(t)
	struct_types.include?(nt) && !nt.end_with?('*')
end

input_file = ARGV[0] || "raylib.h"
output_file = "raylib.f"

File.open(output_file, "w") do |out|
  out.puts "\\ Requires ffi.f (full SysV struct ABI) loaded first."
  out.puts "include /home/dave/forth/ffi/ffi.f"
  out.puts
  out.puts "PACKAGE raylib"
  out.puts "\\ Linux: libraylib.so is found via the dynamic linker (e.g. /usr/lib64)."
  out.puts "\\ Windows builds should use: LIBRARY raylib.dll"
  out.puts "LIBRARY libraylib.so"
  out.puts "PRIVATE"
  out.puts
  out.puts "include raylib_structs.f"

  current_section = nil

  File.read(input_file).lines.each do |line|
    line = line.strip

    # Detect section headers like // Window-related functions
    if line.start_with?('//') && line.include?('functions')
      current_section = line.sub('//', '').strip.sub('functions', 'Module').strip
      out.puts
      out.puts "\\ #{current_section}"
      next
    end

    # Match RLAPI function declarations
    if line.start_with?('RLAPI')
      if match = line.match(/RLAPI\s+(.+?)\s*?([A-Z][\w]+)\((.*?)\);\s*(\/\/\s*(.*))?/)
        return_type = match[1].strip
        name = match[2]
        params_str = match[3].strip
        comment = match[5] || "No preceding comment for #{name}"

	puts "#{params_str} #{name} -- #{return_type}"

        # Parse params, ignore varargs '...'
        params = if params_str == 'void' || params_str.empty?
                   []
                 else
                   params_str.split(',').map do |p|
                     p.strip.sub(/\s+[\w\[\]]+$/, '').strip  # Remove param name and array brackets
                   end.reject { |p| p == '...' }
                 end

        # Map param types to Forth stack items
        stack_params = params.map { |p| map_type(p) }.join(' ')

        # Handle return type.  Struct returns (except packed Color) use
        # the ABI token; the Forth caller supplies a dest buffer.
        if return_type == 'void'
          stack_return = ''
        else
          stack_return = map_type(return_type)
        end

	puts "#{name} #{stack_return}"
	puts "#{name} #{stack_params}"

        # Build stack comment
        stack = if stack_params.empty? && stack_return.empty?
                  '( -- )'
                elsif stack_params.empty?
                  "( -- #{stack_return} )"
                elsif stack_return.empty?
                  "( #{stack_params} -- )"
                else
                  "( #{stack_params} -- #{stack_return} )"
                end

        # Output
        puts "FUNCTION: %-32s %-24s \\ %s : %s" % [name,stack, comment,params_str ]
        out.puts "FUNCTION: %-32s %-24s \\ %s : %s" % [name,stack, comment,params_str ]
      else
       puts "Failed to parse #{line}"
      end
    end
  end
  out.puts "PUBLIC"
  out.puts ": /raylib raylib +order ;"
  out.puts "END-PACKAGE"
end

puts "Generated #{output_file}"
