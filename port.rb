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
	# Type mapping for Forth stack (param and return use the same for simplicity)
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
	  # Structs default to "a", special case Color as "u"
	  "Color" => "u"
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
  out.puts "LIBRARY raylib  \\ Loads libraylib.so or raylib.dll or equivalent"
  out.puts

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
      if match = line.match(/RLAPI\s+(.+?)\s*([A-Z][\w]+)\((.*?)\);\s*(\/\/\s*(.*))?/)
        return_type = match[1].strip
        name = match[2]
        params_str = match[3].strip
        comment = match[5] || "No preceding comment for #{name}"

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

        # Handle return type
        if return_type == 'void'
          stack_return = ''
        elsif is_struct_by_value?(return_type)
          if return_type == 'Color'
            stack_return = 'u'
          else
            # Add 'a' for storage pointer
            stack_params = [stack_params, 'a'].reject(&:empty?).join(' ')
            stack_return = ''
          end
        else
          stack_return = map_type(return_type)
        end

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
        out.puts "FUNCTION: %-32s %-24s \\ %s : %s" % [name,stack, comment,params_str ]
      else
       puts "Failed to parse #{line}"
      end
    end
  end
end

puts "Generated #{output_file}"
