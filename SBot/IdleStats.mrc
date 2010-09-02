on *:TEXT:!IdleStats:#:{
  set %chan $chan
  if (!$2) { msg %chan Syntax: !IdleStats IdleUserNameHere }
  else {
    set %IdleUser $2
    echo -a Gathering data...One moment...
    if ($sock(IdleStats)) { .sockclose IdleStats }
    Sockopen IdleStats www.seersirc.net 80
  }
}
on *:SockOpen:IdleStats:{
  sockwrite -nt $sockname GET $+(/irpg/xml.php?player=,%IdleUser)
  sockwrite -nt $sockname Host: http://www.seersirc.net
  sockwrite -nt $sockname $crlf
}
on *:SockRead:IdleStats: {
  sockread %IdleStats
  if (<b>warning</b> isin %IdleStats) { set %Warning.I Warning }
  if ($regex(IdleStats,%IdleStats,>(.+)<)) { set %Stats %Stats $regml(IdleStats,1) }
  .timerShowStats 1 1 ShowStats
}
alias ShowStats {
  if (%Warning.I) { unset %Warning.I | msg %chan ERROR NO SUCH NAME }
  Else {
    var %Stats $replace(%Stats,$chr(32),$chr(58))
    tokenize 58 %Stats
    msg %chan + Player +
    msg %chan * Username: $gettok(%Stats,1,58)
    msg %chan * Level: $gettok(%Stats,3,58)
    msg %chan * Class: $gettok(%Stats,4,58)
    msg %chan * Time to level: $Duration($gettok(%Stats,5,58))
    msg %chan * Last host used: $gettok(%Stats,6,58)
    msg %chan * Online?: $iif($gettok(%Stats,7,58) == 1,Yes,No)
    msg %chan * Total time idled: $duration($gettok(%Stats,8,58))
    msg %chan * Current position: $gettok(%Stats,9,58) / $gettok(%Stats,10,58)
    if ($gettok(%Stats,11,58) == n) { msg %chan * Alignment: Neutral }
    else { msg %chan * Alignment: $iif($gettok(%Stats,11,58) ==g,Good,Evil) }
    msg %chan + Penalties +
    msg %chan * Logout: $Duration($gettok(%Stats,12,58))
    msg %chan * Quest: $duration($gettok(%Stats,13,58))
    msg %chan * Quit: $Duration($gettok(%Stats,14,58))
    msg %chan * Kick: $Duration($gettok(%Stats,15,58))
    msg %chan * Part: $Duration($gettok(%Stats,16,58))
    msg %chan * Nick: $Duration($gettok(%Stats,17,58))
    msg %chan * Message: $Duration($gettok(%Stats,18,58))
    msg %chan * Total: $Duration($gettok(%Stats,19,58))
    msg %chan + Items +
    msg %chan * Weapon: $gettok(%Stats,20,58)
    msg %chan * Tunic: $gettok(%Stats,21,58)
    msg %chan * Shield: $gettok(%Stats,22,58)
    msg %chan * Legs: $gettok(%Stats,23,58)
    msg %chan * Ring: $gettok(%Stats,24,58)
    msg %chan * Gloves: $gettok(%Stats,25,58)
    msg %chan * Boots: $gettok(%Stats,26,58)
    msg %chan * Helmet: $gettok(%Stats,27,58)
    msg %chan * Charm: $gettok(%Stats,28,58)
    msg %chan * Amulet: $gettok(%Stats,29,58)
    msg %chan * Total: $gettok(%Stats,30,58)
    msg %chan ** Script written by Shawn for the SeersIRC IdleRPG Game
  }
  .sockclose IdleStats
  unset %IdleStats
  .timer 1 1 unset %Stats
  unset %IdleUser
}
