/*
* Please note this only works for the SeersIRC IdleRPG because that's where the socket is opening to
* If you want a script like this for your network let me know.
*/
alias IdleStats {
  if (!$1) { echo 7 -a Syntax: /IdleStats IdleUserNameHere }
  else {
    set %IdleUser $1
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
  ; We only get this warning if we try to go to a link that has no idlerpg player.
  if (%Warning.I) { unset %Warning.I | echo -a ERROR NO SUCH NAME }
  Else {
    var %Stats $replace(%Stats,$chr(32),$chr(58))
    tokenize 58 %Stats
    echo 7 -a + Player +
    echo 7 -a * Username: $gettok(%Stats,1,58)
    echo 7 -a * Level: $gettok(%Stats,3,58)
    echo 7 -a * Class: $gettok(%Stats,4,58)
    echo 7 -a * Time to level: $Duration($gettok(%Stats,5,58))
    echo 7 -a * Last host used: $gettok(%Stats,6,58)
    echo 7 -a * Online?: $iif($gettok(%Stats,7,58) == 1,Yes,No)
    echo 7 -a * Total time idled: $duration($gettok(%Stats,8,58))
    echo 7 -a * Current position: $gettok(%Stats,9,58) / $gettok(%Stats,10,58)
    if ($gettok(%Stats,11,58) == n) { echo 7 -a * Alignment: Neutral }
    else { echo 7 -a * Alignment: $iif($gettok(%Stats,11,58) ==g,Good,Evil) }
    echo 7 -a + Penalties +
    echo 7 -a * Logout: $Duration($gettok(%Stats,12,58))
    echo 7 -a * Quest: $duration($gettok(%Stats,13,58))
    echo 7 -a * Quit: $Duration($gettok(%Stats,14,58))
    echo 7 -a * Kick: $Duration($gettok(%Stats,15,58))
    echo 7 -a * Part: $Duration($gettok(%Stats,16,58))
    echo 7 -a * Nick: $Duration($gettok(%Stats,17,58))
    echo 7 -a * Message: $Duration($gettok(%Stats,18,58))
    echo 7 -a * Total: $Duration($gettok(%Stats,19,58))
    echo 7 -a + Items +
    echo 7 -a * Weapon: $gettok(%Stats,20,58)
    echo 7 -a * Tunic: $gettok(%Stats,21,58)
    echo 7 -a * Shield: $gettok(%Stats,22,58)
    echo 7 -a * Legs: $gettok(%Stats,23,58)
    echo 7 -a * Ring: $gettok(%Stats,24,58)
    echo 7 -a * Gloves: $gettok(%Stats,25,58)
    echo 7 -a * Boots: $gettok(%Stats,26,58)
    echo 7 -a * Helmet: $gettok(%Stats,27,58)
    echo 7 -a * Charm: $gettok(%Stats,28,58)
    echo 7 -a * Amulet: $gettok(%Stats,29,58)
    echo 7 -a * Total: $gettok(%Stats,30,58)
    echo 7 -a ** Script written by Shawn for the SeersIRC IdleRPG Game
  }
  .sockclose IdleStats
  unset %IdleStats
  .timer 1 1 unset %Stats
  unset %IdleUser
}
