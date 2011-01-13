on $*:TEXT:/(\S+imgur\S+)/Sgi:*:{
  if (!$window(@LinkSaver)) { 
    window -nz @LinkSaver 
  }

  aline -ph @LinkSaver $timestamp 07[ImGur] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}


on $*:TEXT:/(\S+4chan\S+)/Sgi:*:{
  if (!$window(@LinkSaver)) { 
    window -nz @LinkSaver 
  }

  aline -ph @LinkSaver $timestamp 04[4Chan] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}


on $*:TEXT:/(\S+photobucket\S+)/Sgi:*:{
  if (!$window(@LinkSaver)) { 
    window -nz @LinkSaver 
  }

  aline -ph @LinkSaver $timestamp 07[Photobucket] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}


on $*:TEXT:/(\S+youtube\S+)/Sgi:*:{
  if (!$window(@LinkSaver)) { 
    window -nz @LinkSaver 
  }

  aline -ph @LinkSaver $timestamp 07[Youtube] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}


on $*:TEXT:/(\S+motherless\S+)/Sgi:*:{
  if (!$window(@LinkSaver)) { 
    window -nz @LinkSaver 
  }

  aline -ph @LinkSaver $timestamp 04[Motherless] $+(12[10,$network,12:10,$chan,12:10,$nick,12]: 10, $regml(1))
}
