F12 {
  var %bc.Show $$?="Echo/Msg"

  if (%bc.Show = Msg) { 
    set %Ac.Show Msg $active 
  }
  elseif (%bc.show = Echo) { 
    set %Ac.Show echo -a 
  }
  else { 
    Halt 
  }

  var %z = 1, %i = 1, %b = 0
  var %Reg.chans = 0,%voiced.chans = 0, %Halfed.chans = 0, %oped.chans = 0, %Admin.chans = 0, %Owner.chans = 0

  while (%i <= $scon(0)) {
    scon %i {
      while (%z <= $chan(0)) {
        if ($left($nick($chan(%z),$me).pnick,1) == +) { 
          inc %Voiced.Chans
          set %Voiced.Name %Voiced.Name + $+ $chan(%z) 
        }
        elseif ($left($nick($chan(%z),$me).pnick,1) == %) { 
          inc %Halfed.Chans
          set %Halfed.Name %Halfed.Name $eval(%,0) $+ $chan(%z) 
        }
        elseif ($left($nick($chan(%z),$me).pnick,1) == @) { 
          inc %Oped.Chans
          set %Oped.Name %Oped.Name @ $+ $chan(%z) 
        }
        elseif ($left($nick($chan(%z),$me).pnick,1) == &) { 
          inc %Admin.Chans
          set %Admin.Name %Admin.Name & $+ $chan(%z) 
        }
        elseif ($left($nick($chan(%z),$me).pnick,1) == ~) { 
          inc %Owner.Chans 
          set %Owner.Name %Owner.Name ~ $+ $chan(%z) 
        }
        else { 
          inc %Reg.chans
          set %reg.name %reg.name $chan(%z) 
        }

        inc %z
      }

      var %c $calc(%z -1)
      var %d $calc(%b + %c)
      var %b %d
      var %z 1
    }

    inc %i
  }

  scid -r
  %Ac.Show I'm on %d Channels.

  if (%reg.chans = 0) {     var %Reg.name NONE }
  if (%voiced.chans = 0) {  var %voiced.name NONE }
  if (%halfed.chans = 0) {  var %halfed.name NONE }
  if (%oped.chans = 0) {    var %oped.name NONE }
  if (%admin.chans = 0) {   var %admin.name NONE }
  if (%owner.chans = 0) {   var %Owner.name NONE }

  %Ac.Show 10Regular13 ( $+ %reg.chans $+ ) 10on: %reg.name
  %Ac.Show 12Voiced13 ( $+ %Voiced.chans $+ ) 12on: %voiced.name
  %Ac.Show 11Halfed13 ( $+ %Halfed.Chans $+ ) 11on: %Halfed.Name
  %Ac.Show 4Oped13 ( $+ %Oped.chans $+ ) 4on: %Oped.name
  %Ac.Show 4Admin13 ( $+ %Admin.chans $+ ) 4on: %Admin.name
  %Ac.Show 4Owner13 ( $+ %Owner.chans $+ ) 4on: %owner.name
  %Ac.Show 11/!\ 12A couple of channels appear multiple times. Its because they're on differant networks. (Data was taken from $scon(0) Servers) 11/!\

  unset %*chans
  unset %*name
  unset %Ac.show
}