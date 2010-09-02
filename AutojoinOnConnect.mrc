alias autojoin { 
  if (($1 == -d) && ($2)) {
    var %Tok $findtok($($+(%,$network,.autojoin),2),$2,1,44)
    set $+(%,$network,.autojoin) $deltok($($+(%,$network,.autojoin),2),%Tok,44)
    echo -a $+([,$network,]) $($+(%,$network,.autojoin),2)
  }
  else {
    set $+(%,$network,.autojoin) $addtok($($+(%,$network,.autojoin),2),$chan,44)
    echo -a $+([,$network,]) $($+(%,$network,.autojoin),2)
  }
}
raw 001:*:{
  set %Connect.raw on
}
raw 004:*:{
  if (%Connect.raw) {
    ; Modes to set on any UnrealIRCd network
    if (Unreal isin $3) { mode $me +pTiwx }
    if (InspIRCd isin $3) { 
	  ; Modes to set on any InspIRCd network, also look below to see how we detect/set the +I mode
      set %modes +xiw
      if (I isincs $4) {
        ; I isin the usermode list, let's check to make sure it's on the modules list aswell.
        set %CheckMods true
        /modules
      }
    }
  }
}
raw 005:*:{
  if (%Connect.Raw) {
    if ($regex(Raw005Name,$1-,NETWORK=(\S+)) == 1) {
      if ($regml(Raw005Name,1) == SeersIRC) {
        if ($me == Shawn) { join -n %SeersIRC.autojoin }
      }
      elseif ($regml(Raw005Name,1) == EXAMPLENETWORK) {
	    ; Set certain modes on certain networks.
	    mode $me +somemodeshere
        join -n %EXAMPLENETWORK.autojoin 
      }
      unset %Connect.Raw
    }
  }
}
raw 702:*m_hidechans*:{
  ; Detects if +I is m_hidechans.so, if yes it sets +I
  if (%CheckMods) {
    ; Fantastic, This network supports m_hidechans.so. Appending +I to the end of modes to set.
    mode $me %modes $+ I
  }
}
raw 703:*End of MODULES list*:{
  if (%CheckMods) {
    mode $me %modes
    unset %modes
    unset %CheckMods
  }
}
