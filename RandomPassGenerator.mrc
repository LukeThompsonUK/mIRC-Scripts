/randompass {
  var %PassGen 1
  while (%PassGen <= $1) {
    Var %R $r(1,3)
    if (%R == 1) { var %Pass %Pass $+ $r(0,9) }
    elseif (%R == 2) { var %Pass %Pass $+ $r(A,Z) }
    elseif (%R == 3) { var %Pass %Pass $+ $r(a,z) }
    inc %PassGen
  }
  echo -a Pass: %Pass
  echo -a md5: $md5(%pass)
  echo -a sha1: $sha1(%pass)
}
; This doesn't have anything to do with the password generator.
/hash {
  var %Show $iif($1 == -m,msg $active,echo -a)
  %Show Original: $iif($1 == -m,$2-,$1)
  %Show md5: $md5($iif($1 == -m,$2-,$1))
  %Show sha1: $sha1($iif($1 == -m,$2-,$1))
}