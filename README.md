# FeaturedImage

<img src="featuredimage.jpg">

## What is FeaturedImage?

FeaturedImage is the finder that extract featured image from a web page.

FeaturedImage::Finder accesses and analyses a web page using Mechanize, download images which are referenced by IMG tag in HTML, and specify a featured image based on size of image using RMagick.

Furthermore, FeaturedImage contains pretty good thumbnail generating function too. FeaturedImage::Converter crops centered area of image, resizes, and convert to arbitrary format automatically.

## Usage

```ruby
require 'featuredimage'

# find first featured image from a web page
featuredimage = FeaturedImage::Finder.first('http://en.wikipedia.org/wiki/Lenna')

# convert featured image to thumbnail
thumbnail = FeaturedImage::Converter.convert(featuredimage, 180, 120) # return BLOB

# save BLOB
open('thumbnail.jpg', 'w'){|f| f.write thmbnail}
```

## API Reference

### Basic API

<table>
<tr><th>API</th><th>Description</th></tr>
<tr><td>FeaturedImage::Finder.first</td><td>Find first featured image that is matching criteria from web page. And return it as Magick::ImageList. If the featured image does not exist return nil.</td></tr>
<tr><td>FeaturedImage::Finder.biggest</td><td>Find the biggest featured image that is matching criteria from web page. And return it as Magick::ImageList. If the featured image does not exist return nil.</td></tr>
<tr><td>FeaturedImage::Finder.all</td><td>Find all featured images that are matching criteria from web page. And return them as Array of Magick::ImageList. If the featured image does not exist return empty Array.</td></tr>
<tr><td>FeaturedImage::Converter.convert</td><td>Convert image to arbitary sized thumbnai and return BLOB. Default thumbnail format is JPEG compression quality 60.</td></tr>
</table>

Also, you can use FeaturedImage::Finder and FeaturedImage::Converter instance directory, if you want. See source code.

### Criteria

FeaturedImage::Finder APIs receive various argument about featured image criteria. These are examples.

Empty criteria. Anything image is match as featured image.

```ruby
FeaturedImage::Finder.first URL
```

Aspect ratio range criteria. Featured image aspect ratio restrict 4:3 to 16:9. See also _Aspect Ratio_.

```ruby
FeaturedImage::Finder.first URL 1.2..1.8
```

Minimum size criteria. Minimum featured image size is 320x240.

```ruby
FeaturedImage::Finder.first URL 320 240
```

Minimum size criteria with aspect ratio range restrict 4:3 to 16:9.

```ruby
FeaturedImage::Finder.first URL 320 240 1.2..1.8
```

Minimum and maximum size criteria. Featured image size is 320x240 to 1024x768.

```ruby
FeaturedImage::Finder.first URL 320 240 1024 768
```

The most restricted criteria. Featured image size is 320x240 to 1024x768, and aspect ratio restrict 4:3 to 16:9.

```ruby
FeaturedImage::Finder.first URL 320 240 1024 768 1.2..1.8
```

### Aspect Ratio

FeaturedImage's aspect ratio is calculated by WIDTH / HEIGHT.

Examples.

- Aspect ratio 1.0 is square.
- Aspect ratio 0.5 is vertically long rectangle. HEIGHT is twice as much as WIDTH.
- Aspect ratio 2.0 is holizontally long rectangle. WIDTH is twice as much as HEIGHT.

# Auther

- [xmisao](http://www.xmisao.com/)

# License

This library is distributed under the MIT license.
