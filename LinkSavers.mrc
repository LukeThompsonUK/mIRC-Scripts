on *:TEXT:*:*:{
  if ($regex(Motherless,$1-,/((?:https?://)?(?:www\.)?motherless\.com\S+)/Si)) {
    aline -ph @LinkSaver $timestamp 04[Motherless] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(Motherless,1))
  }
  elseif ($regex(Youtube,$1-,/((?:https?://)?(?:www\.)?youtube\.co(?:m|\..{2})\S+)/Si)) {
    aline -ph @LinkSaver $timestamp 07[Youtube] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(Youtube,1))
  }
  elseif ($regex(Photobucket,$1-,/((?:https?://)?(?:www\.)?photobucket\.com\S+)/Si)) {
    aline -ph @LinkSaver $timestamp 07[Photobucket] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(Photobucket,1))
  }
  elseif ($regex(4Chan,$1-,/((?:https?://)?(?:www\.)?4chan\.org\S+)/Si)) {
    aline -ph @LinkSaver $timestamp 04[4Chan] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(4Chan,1))
  }
  elseif ($regex(ImageSaver,$1-,/((?:https?://)?(?:www\.)?\S+(?:\.jpe?g|\.flv|\.bmp|\.gif))/Si)) {
    aline -ph @LinkSaver $timestamp 07[IMAGE] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(ImageSaver,1))
  }
}
