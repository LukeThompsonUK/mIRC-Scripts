on $*:TEXT:/(http.\/\/(i\.)?imgur\S+\/\S+)/Sgi:*:{
  if (!$window(@Imgur)) { /window -nz @Imgur }
  aline -ph @Imgur $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}
on $*:TEXT:/((\w+\.4chan\S+)(src|res)\/\S+)/Sgi:*:{
  ; $regml(3) is src or res, can be used to determine if it's a thread or image.

  if (!$window(@4Chan)) { /window -nz @4Chan }
  aline -ph @4Chan $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}
on $*:TEXT:/(\w+\.photobucket\S+)/Sgi:*:{
  if (!$window(@Photobucket)) { /window -nz @Photobucket }
  ; I'm not even sure what the fuck I was thinking here when I coded this but it works
  ; So I'll not fuck with it.
  var %x 1
  var %Links
  while (%x <= $regml(0)) {
    %Links = $addtok(%Links,$regml(%x),58)
    inc %x
  }
  aline -ph @Photobucket $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10,$replace(%Links,:,12:10))
}