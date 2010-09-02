/global {
  var %c 1
  ; These are exceptions on any network.
  var %IChan.Exceptions #Idle,#Idle-RPG,#IdleRPG,#IRPG
  ; This would be network specific, make another variable %somethinghere with channels after it if you want to add another network
  ; Then add a if ($network == YournetworkherE) { 
  ; if (!$istok(%YourVariableHere,$chan(%c),44)) { msg $chan(%c) 7[10 Global 7]10 $1- }
  ; }
  ; Below or above the SeersIRC one and it should work.
  var %SChan.Exceptions #Help,#SeersIRC,#Trivia,#Seers
  while (%c <= $chan(0)) {
    if (!$istok(%IChan.Exceptions,$chan(%c),44)) {
      if ($network == SeersIRC) { 
        if (!$istok(%SChan.Exceptions,$chan(%c),44)) { msg $chan(%c) 7[10 Global 7]10 $1- }
      }
      else { msg $chan(%c) 7[10 Global 7]10 $1- }
    }
    inc %c
  }
}