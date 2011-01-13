randompass {
  var %PassGen 1

  while (%PassGen <= $1) {
    var %R $r(1,3)
    
    if (%R == 1) { 
      var %Pass %Pass $+ $r(0,9) 
    }
    elseif (%R == 2) { 
      var %Pass %Pass $+ $r(A,Z) 
    }
    elseif (%R == 3) { 
      var %Pass %Pass $+ $r(a,z) 
    }

    inc %PassGen
  }

  echo -a Pass: %Pass
  echo -a md5: $md5(%pass)
  echo -a sha1: $sha1(%pass)
}