alias highlight {
  if (($1 == -addnick) && ($2)) {
    set %Highlight.NicksToMatch $addtok(%Highlight.NicksToMatch,$2,44)
    echo -a [Highlight/Nicks]: %Highlight.NicksToMatch
  }
  elseif (($1 == -delnick) && ($2)) {
    var %Tok $findtok(%Highlight.NicksToMatch,$2,1,44)
    set %Highlight.NicksToMatch $deltok(%Highlight.NicksToMatch,%Tok,44)
    echo -a [Highlight/Nicks]: %Highlight.NicksToMatch
    if ($numtok(%Highlight.NicksToMatch,44) == 0) {
      unset %Highlight.NicksToMatch
    }
  }
  elseif (($1 == -ignorechan) && ($regex($2,/#\S+/))) {
    set %Highlight.IgnoreChans $addtok(%Highlight.IgnoreChans,$2,44)
    echo -a [Highlight/IgnoreChans]: %Highlight.IgnoreChans
  }
  elseif (($1 == -unignorechan) && ($regex($2,/#\S+/))) {
    var %Tok $findtok(%Highlight.IgnoreChans,$2,1,44)
    set %Highlight.IgnoreChans $deltok(%Highlight.IgnoreChans,%Tok,44)
    echo -a [Highlight/IgnoreChans]: %Highlight.IgnoreChans
    if ($numtok(%Highlight.IgnoreChans,44) == 0) {
      unset %Highlight.IgnoreChans
    }
  }
  elseif (($1 == -ignorenick) && ($2)) {
    set %Highlight.IgnoreNicks $addtok(%Highlight.IgnoreNicks,$2,44)
    echo -a [Highlight/IgnoreNicks]: %Highlight.IgnoreNicks
  }
  elseif (($1 == -unignorenick) && ($2)) {
    var %Tok $findtok(%Highlight.IgnoreNicks,$2,1,44)
    set %Highlight.IgnoreNicks $deltok(%Highlight.IgnoreNicks,%Tok,44)
    echo -a [Highlight/IgnoreNicks]: %Highlight.IgnoreNicks
    if ($numtok(%Highlight.IgnoreNicks,44) == 0) {
      unset %Highlight.IgnoreNicks
    }
  }
  elseif ($1 == -status) {
    echo -a [Highlight/Status]:
    echo -a [Highlight/Nicks]: %Highlight.NicksToMatch
    echo -a [Highlight/IgnoreChans]: %Highlight.IgnoreChans
    echo -a [Highlight/IgnoreNicks]: %Highlight.IgnoreNicks
  }
  else {
    echo -a 07Syntax:
    echo -a /Highlight -addnick Nick [Adds a nick to your highlight list]
    echo -a /Highlight -delnick Nick [Removes a nick from your highlight list]
    echo -a /Highlight -ignorechan #Channel [Adds a channel to your highlight ignore list]
    echo -a /Highlight -unignore #Channel [Removes a channel from your highlight ignore list]
    echo -a /Highlight -ignorenick Nick [Ignores a user form highlighting you]
    echo -a /Highlight -unigorenick Nick [Unignores a user form highlighting you]
    echo -a /Highlight -status [Prints information]
  }
}

on *:TEXT:*:#:{ 
  if ((!$istok(%Highlight.IgnoreChans,$chan,44)) && (!$istok(%Highlight.IgnoreNicks,$nick,44))) {
    var %x 1
    while (%x <= $numtok(%Highlight.NicksToMatch,44)) {
      if ($matchtok($1-,$gettok(%Highlight.NicksToMatch,%x,44),0,32)) {
        if (!$window(@Highlight)) { /window -nz @Highlight }
        aline -ph @Highlight $timestamp $($+(12[07,$network,12:07,$chan,12:07,$nick,12]07:),2) $1-
      }
      inc %x
    }
  }
}
on *:ACTION:*:#:{ 
  if ((!$istok(%Highlight.IgnoreChans,$chan,44)) && (!$istok(%Highlight.IgnoreNicks,$nick,44))) {
    var %x 1
    while (%x <= $numtok(%Highlight.NicksToMatch,44)) {
      if ($matchtok($1-,$gettok(%Highlight.NicksToMatch,%x,44),0,32)) {
        if (!$window(@Highlight)) { /window -nz @Highlight }
        aline -ph @Highlight $timestamp $($+(12[07,$network,12:07,$chan,12:07,$nick,12]07:),2) $1-
      }
      inc %x
    }
  }
}
