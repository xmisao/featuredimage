Gem::Specification.new do |s|
  s.name        = 'featuredimage'
  s.version     = '0.9.1'
  s.date        = '2017-07-17'
  s.summary     = "FeaturedImage is the finder that extract featured image from a web page."
  s.description = <<DESC
FeaturedImage is the finder that extract featured image from a web page.
FeaturedImage::Finder accesses and analyses a web page using Mechanize, download images which are referenced by IMG tag in HTML, and specify a featured image based on size of image using RMagick.
Furthermore, FeaturedImage contains pretty good thumbnail generating function too. FeaturedImage::Converter crops centered area of image, resizes, and convert to arbitrary format automatically.
DESC
  s.authors     = ["xmisao"]
  s.email       = 'mail@xmisao.com'
  s.files       = ["lib/featuredimage.rb", "lib/featuredimage/finder.rb", "lib/featuredimage/converter.rb"]
  s.homepage    = 'https://github.com/xmisao/featuredimage'
  s.license     = 'MIT'
  s.add_dependency('mechanize')
  s.add_dependency('rmagick')
end
