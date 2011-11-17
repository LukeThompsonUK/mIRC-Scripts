alias randompass {
  var %PassGen 1
  while (%PassGen <= $1) {
    var %Rand $rand(1,3)
    if (%Rand == 2) {
      var %Pass %Pass $+ $rand(0,9)
    }
    else { 
      var %Pass %Pass $+ $iif(%Rand == 1,$rand(a,z),$rand(A,Z))
    }
    inc %PassGen
  }
  if ($2 == -m) { 
    msg $active Pass: %pass - md5: $md5(%pass) - sha1: $sha1(%pass)
  } 
  else {
    echo -a Pass: %Pass
    echo -a md5: $md5(%pass)
    echo -a sha1: $sha1(%pass)
  }
}
