on $*:TEXT:/(http.\/\/(i\.)?imgur\S+\/\S+)/Sgi:*:{
  if (!$window(@Imgur)) { /window -nz @Imgur }
  aline -ph @Imgur $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}
on $*:TEXT:/((\w+\.4chan\S+)(src|res)\/\S+)/Sgi:*:{
  if (!$window(@4Chan)) { /window -nz @4Chan }
  aline -ph @4Chan $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}
on $*:TEXT:/(\w+\.photobucket\S+)/Sgi:*:{
  if (!$window(@Photobucket)) { /window -nz @Photobucket }
  aline -ph @Photobucket $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10,$regml(1))
}