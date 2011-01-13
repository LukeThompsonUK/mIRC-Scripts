OWindows {
  var %x 1

  while (%x <= $scon(0)) {
    scon %x

    var %Query $calc(%Query + $query(0))
    var %Chan $calc(%chan + $chan(0))

    inc %x
  }

  var %Window $Window(0)

  scon -r
  echo -a I have $calc(%window + %query + %chan) Open windows.
  echo -a %chan Channels, %query Querys, and %window @Windows.
}