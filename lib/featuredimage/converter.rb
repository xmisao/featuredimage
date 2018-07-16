begin
  require "rmagick"
rescue LoadError
  require "RMagick"
end

module FeaturedImage
	class Converter
		attr_accessor :width, :height, :opts

		def self.convert(image, w, h, opts = {})
			converter = Converter.new(w, h, opts)
			converter.convert(image)
		end

		def initialize(width, height, opts = {})
			@width, @height = width, height

			# default convert options
			@opts = {
				:format => "JPG",
				:quality => 60
			}
			@opts.merge!(opts)
		end

		def convert(image)
			target_size = {w:@width, h:@height}
			original_size = {w:image.columns, h:image.rows}

			resized_size = get_resized_size(original_size, target_size)
			resized_image = image.resize(resized_size[:w], resized_size[:h])

			offset = get_offset(target_size, resized_size)
			cropped_image = resized_image.crop(offset[:x], offset[:y], target_size[:w], target_size[:h])

			image_to_blob(cropped_image)
		end

		private
		def get_resized_size(src, dst)
			w_ratio = dst[:w].to_f / src[:w]
			h_ratio = dst[:h].to_f / src[:h]
			ratio = 0
			if w_ratio > h_ratio
				ratio = w_ratio
			else
				ratio = h_ratio
			end
			{w:(src[:w] * ratio).to_i, h:(src[:h] * ratio).to_i}
		end

		def get_offset(target_size, resized_size)
			offset_x = (resized_size[:w] - target_size[:w]) / 2
			offset_y = (resized_size[:h] - target_size[:h]) / 2
			{:x => offset_x, :y => offset_y}
		end

		def image_to_blob(image)
			opts = @opts
			image.to_blob{
				opts.each{|k, v|
					self.send(k.to_s + '=', v)
				}
			}
		end
	end
end
