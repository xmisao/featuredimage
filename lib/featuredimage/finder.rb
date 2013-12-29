require "mechanize"
require "RMagick"

module FeaturedImage
	class Finder
		# Find first featured image that is matching criteria from web page.
		# And return it as Magick::ImageList.
		# If the featured image does not exist return nil.
		def self.first(url, *args)
			finder = Finder.new
			cond = Criteria.new(*args)
			finder.first(url, cond)
		end

		# Find the biggest featured image that is matching criteria from web page.
		# And return it as Magick::ImageList.
		# If the featured image does not exist return nil.
		def self.biggest(url, *args)
			finder = Finder.new
			cond = Criteria.new(*args)
			finder.biggest(url, cond)
		end

		# Find all featured images that are matching criteria from web page.
		# And return them as Array of Magick::ImageList.
		# If the featured image does not exist return empty Array.
		def self.all(url, *args)
			finder = Finder.new
			cond = Criteria.new(*args)
			finder.all(url, cond)
		end

		def first(url, cond)
			agent = Mechanize.new
			page = agent.get(url)
			page.search("img").each{|elm|
				src = elm.attributes["src"].value
				begin
					data = download_image(agent, src)

					imagelist = Magick::ImageList.new
					imagelist.from_blob(data)

					size = Size.new(imagelist.columns, imagelist.rows)
					if featured_image?(cond, size)
						return imagelist
					end
				rescue Mechanize::ResponseCodeError
					# ignore Mechanize::ResponseCodeError
				end
			}
			nil
		end

		def biggest(url, cond)
			agent = Mechanize.new
			page = agent.get(url)

			max_size = Size.new(0, 0)
			max_imagelist = nil

			page.search("img").each{|elm|
				src = elm.attributes["src"].value
				begin
					data = download_image(agent, src)

					imagelist = Magick::ImageList.new
					imagelist.from_blob(data)

					size = Size.new(imagelist.columns, imagelist.rows)
					if featured_image?(cond, size)
						if max_size < size
							max_size = size
							max_imagelist = imagelist
						end
					end
				rescue Mechanize::ResponseCodeError
					# ignore Mechanize::ResponseCodeError
				end
			}

			max_imagelist
		end

		def all(url, cond)
			agent = Mechanize.new
			page = agent.get(url)

			max_size = Size.new(0, 0)
			max_imagelist = nil

			results = []
			page.search("img").each{|elm|
				src = elm.attributes["src"].value
				begin
					data = download_image(agent, src)

					imagelist = Magick::ImageList.new
					imagelist.from_blob(data)

					size = Size.new(imagelist.columns, imagelist.rows)
					results << imagelist if featured_image?(cond, size)
				rescue Mechanize::ResponseCodeError
					# ignore Mechanize::ResponseCodeError
				end
			}
			results
		end

		private
		def download_image(agent, src)
			agent.get(src).body
		end

		def featured_image?(cond, size)
			cond.check(size)
		end
	end

	class Criteria
		attr_accessor :min_width, :max_width, :min_height, :max_height, :aspect_range

		def initialize(*args)
			# default criteria size 0x0 to 4096x4096
			@min_width = 0
			@max_width = 4096
			@min_height = 0
			@max_height = 4096
			@aspect_range = 0..4096

			case args.length
			when 0
				# default criteria
			when 1
				@aspect_range = args[0]
			when 2
				@min_width = args[0]
				@min_height = args[1]
			when 3
				@min_width = args[0]
				@min_height = args[1]
				@aspect_range = args[2]
			when 4
				@min_width = args[0]
				@max_width = args[1]
				@min_height = args[2]
				@max_height = args[3]
			when 5
				@min_width = args[0]
				@max_width = args[1]
				@min_height = args[2]
				@max_height = args[3]
				@aspect_range = args[4]
			else
				raise ArgumentError.new
			end
		end

		def check(size)
			if @min_width < size.width and
				 size.width < @max_width and
				 @min_height < size.height and
				 size.height < @max_height and
				 @aspect_range.include?(size.aspect)
				true
			else
				false
			end
		end
	end

	class Size
		attr_accessor :width, :height

		def initialize(width, height)
			@width, @height = width, height
		end

		def aspect
			width.to_f / height.to_f # ;-)
		end

		def <(size)
			@width * @height < size.width * size.height ? true : false
		end
	end
end
