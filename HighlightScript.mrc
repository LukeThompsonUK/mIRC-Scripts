/**
* Script Description
** Creates a @Window for highlights. Copies highlighted text to the @Window for viewing.
*
* Configuration Settings / Commands:
** /Highlight -addnick Nick [Adds a nick to your highlight list]
** /Highlight -delnick Nick [Removes a nick from your highlight list]
** /Highlight -ignorechan #Channel [Adds a channel to your highlight ignore list]
** /Highlight -unignorechan #Channel [Removes a channel from your highlight ignore list]
** /Highlight -ignorenick Nick [Ignores a user form highlighting you]
** /Highlight -unigorenick Nick [Unignores a user form highlighting you]
** /Highlight -status [Prints information]
*
* Settings File
** This script stores all settings in HighlightSettings.ini in the mIRC Directory.
** Type: //run $mIRCDir\HighlightSettings.ini to view.
*/

alias highlight {
  if (($1 == -addnick) && ($2)) {
    writeini HighlightSettings.ini NicksToMatch $2 on
    echo -a [Highlight/Nicks]: $ReturnAll(NicksToMatch)
  }
  elseif (($1 == -delnick) && ($2)) {
    remini HighlightSettings.ini NicksToMatch $2
    echo -a [Highlight/Nicks]: $ReturnAll(NicksToMatch)
  }
  elseif (($1 == -ignorechan) && ($regex($2,/#\S+/))) {
    writeini HighlightSettings.ini IgnoreChans $2 on
    echo -a [Highlight/IgnoreChans]: $ReturnAll(IgnoreChans)
  }
  elseif (($1 == -unignorechan) && ($regex($2,/#\S+/))) {
    remini HighlightSettings.ini IgnoreChans $2
    echo -a [Highlight/IgnoreChans]: $ReturnAll(IgnoreChans)
  }
  elseif (($1 == -ignorenick) && ($2)) {
    writeini HighlightSettings.ini IgnoreNicks $2 on
    echo -a [Highlight/IgnoreNicks]: $ReturnAll(IgnoreNicks)
  }
  elseif (($1 == -unignorenick) && ($2)) {
    remini HighlightScript.ini IgnoreNicks $2
    echo -a [Highlight/IgnoreNicks]: $ReturnAll(IgnoreNicks)
  }
  elseif ($1 == -status) {
    echo -a [Highlight/Status]:
    echo -a [Highlight/Nicks]: $ReturnAll(NicksToMatch)
    echo -a [Highlight/IgnoreChans]: $ReturnAll(IgnoreChans)
    echo -a [Highlight/IgnoreNicks]: $ReturnAll(IgnoreNicks)
  }
  else {
    echo -a 07Syntax:
    echo -a /Highlight -addnick Nick [Adds a nick to your highlight list]
    echo -a /Highlight -delnick Nick [Removes a nick from your highlight list]
    echo -a /Highlight -ignorechan #Channel [Adds a channel to your highlight ignore list]
    echo -a /Highlight -unignorechan #Channel [Removes a channel from your highlight ignore list]
    echo -a /Highlight -ignorenick Nick [Ignores a user form highlighting you]
    echo -a /Highlight -unigorenick Nick [Unignores a user form highlighting you]
    echo -a /Highlight -status [Prints information]
  }
}


; This alias returns all the topics in an ini directory in item1,item2,item3 format.
alias -l ReturnAll {
  var %Reading $1
  var %Total $ini(HighlightSettings.ini, %Reading, 0)
  var %x 1
  while (%x <= %Total) {
    var %Return $addtok(%Return, $ini(HighlightSettings.ini, %Reading, %x), 44)
    inc %x
  }

  return %Return
}


on *:TEXT:*:#:{
  ; This checks to make sure the channel and the user both aren't in the ignore list.
  if ((!$istok($ReturnAll(IgnoreChans),$chan,44)) && (!$istok(ReturnAll(IgnoreNicks),$nick,44))) {
    var %x 1

    ; Loops for every nick we have to check for.
    while (%x <= $numtok($ReturnAll(NicksToMatch),44)) {
      ; If we found the nick somewhere in the line.
      if ($matchtok($1-,$gettok($ReturnAll(NicksToMatch),%x,44),0,32)) {

        ; Open a @Window if one doesn't already exist.
        if (!$window(@Highlight)) {
          window -nz @Highlight
        }

        ; Print to the window and then highlight the channel window that we were highlighted in.
        aline $iif($chan == $active,-p,-ph) @Highlight $timestamp $($+(12[07,$network,12:07,$chan,12:07,$nick,12]07:),2) $1-
        window -g2 $chan
      }

      inc %x
    }
  }
}


on *:ACTION:*:#:{
  ; This checks to make sure the channel and the user both aren't in the ignore list.
  if ((!$istok($ReturnAll(IgnoreChans),$chan,44)) && (!$istok(ReturnAll(IgnoreNicks),$nick,44))) {
    var %x 1

    ; Loops for every nick we have to check for.
    while (%x <= $numtok($ReturnAll(NicksToMatch),44)) {
      ; If we found the nick somewhere in the line.
      if ($matchtok($1-,$gettok($ReturnAll(NicksToMatch),%x,44),0,32)) {

        ; Open a @Window if one doesn't already exist.
        if (!$window(@Highlight)) {
          window -nz @Highlight
        }

        ; Print to the window and then highlight the channel window that we were highlighted in.
        aline $iif($chan == $active,-p,-ph) @Highlight $timestamp $($+(12[07,$network,12:07,$chan,12:07,$nick,12]07:),2) $1-
        window -g2 $chan
      }

      inc %x
    }
  }
}
