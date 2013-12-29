# What is FeaturedImage?

FeaturedImage is the finder that extract featured image from a web page.

FeaturedImage::Finder accesses and analyses a web page using Mechanize, download images which are referenced by IMG tag in HTML, and specify a featured image based on size of image using RMagick.

Furthermore, FeaturedImage contains pretty good thumbnail generating function too. FeaturedImage::Converter crops centered area of image, resizes, and convert to arbitrary format automatically.

# Usage

~~~~
require 'featuredimage'

# find first featured image from a web page
featuredimage = FeaturedImage::Finder.first('http://en.wikipedia.org/wiki/Lenna')

# convert featured image to thumbnail
thumbnail = FeaturedImage::Converter.convert(180, 120) # return BLOB

# save BLOB
open('thumbnail.jpg', 'w'){|f| f.write thmbnail}
~~~~

# API Reference

## Basic API

There are 4 basic API.

|API|Description|
|:-|:-|
|FeaturedImage::Finder.first|Find first featured image that is matching criteria from web page. And return it as Magick::ImageList. If the featured image does not exist return nil.|
|FeaturedImage::Finder.biggest|Find the biggest featured image that is matching criteria from web page. And return it as Magick::ImageList. If the featured image does not exist return nil.|
|FeaturedImage::Finder.all|Find all featured images that are matching criteria from web page. And return them as Array of Magick::ImageList. If the featured image does not exist return empty Array.|
|FeaturedImage::Converter.convert|Convert image to arbitary sized thumbnai and return BLOB. Default thumbnail format is JPEG compression quality 60.|

Also, you can use FeaturedImage::Finder and FeaturedImage::Converter instance directory, if you want. See source code.

## Criteria

FeaturedImage::Finder APIs receive various argument about featured image criteria.
These are examples.

Empty criteria. Anything image is match as featured image.

~~~~
FeaturedImage::Finder.first URL
~~~~

Aspect ratio range criteria. Featured image aspect ratio restrict 4:3 to 16:9. See also _Aspect Ratio Range_.

~~~~
FeaturedImage::Finder.first URL 1.2..1.8
~~~~

Minimum size criteria. Minimum featured image size is 320x240.

~~~~
FeaturedImage::Finder.first URL 320 240
~~~~

Minimum size criteria with aspect ratio range 4:3 to 16:9. See also _Aspect Ratio Range_.

~~~~
FeaturedImage::Finder.first URL 320 240 1.2..1.8
~~~~

Minimum and maximum size criteria.

### Aspect Ratio Range

FeaturedImage's aspect ratio is calculated by WIDTH / HEIGHT.

- Aspect ratio 1.0 is square.
- Aspect ratio 0.5 is vertically long rectangle. HEIGHT is twice as much as WIDTH.
- Aspect ratio 2.0 is holizontally long rectangle. WIDTH is twice as much as HEIGHT.

# Auther

- [xmisao](http://www.xmisao.com/)

# License

This library is distributed under the MIT license.
