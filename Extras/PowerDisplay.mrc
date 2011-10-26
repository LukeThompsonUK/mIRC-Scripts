; /power <echo/msg> defaults to msg if nothing is given.
; This script shows how many channels you're in and how many you are opped/voice in.

alias power {
  if ($1 == echo) { var %Show.Power = echo -a }
  else { %Show.Power = msg $active } 
  var %ChanOP = 0, %ChanVoice = 0, %ChanReg = 0, %TotalChannels = 0
  var %i = 1, %x = 1
  while (%i <= $scon(0)) {
    scon %i {
      while ($chan(%x) <= $chan(0)) {
        if ($me isop $chan(%x)) { inc %ChanOP } 
        elseif ($me isvoice $chan(%x)) { inc %ChanVoice }
        else { inc %ChanReg }
        inc %x
      }
      %TotalChannels = %TotalChannels + $chan(0)
    }
    inc %i
    var %x = 1
  }
  scid -r
  %Show.Power 12Total Channels: %TotalChannels
  %Show.Power 12OP: %ChanOP
  %Show.Power 12Voice: %ChanVoice
  %Show.Power 12Regular: %ChanReg

  unset %Show.Power
}
