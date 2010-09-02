on ^*:TEXT:*:#:{
  if ($regex($1-,/^is?(?:\x20am)?\x20(?:now\x20)?(away|back).?(?:\x20reason:?(?:\x20was:?)?|-)?\x20(.+)$/Si) != 0) {
    if (($me isop $chan) || ($me ishop $chan)) {
      ban -ku600 $chan $nick 3 Don't use away messages here. [5 Minute ban]
    }
  }
}
on ^*:ACTION:*:#:{
  if ($regex($1-,/^is?(?:\x20am)?\x20(?:now\x20)?(away|back).?(?:\x20reason:?(?:\x20was:?)?|-)?\x20(.+)$/Si) != 0) {
    if (($me isop $chan) || ($me ishop $chan)) {
      ban -ku600 $chan $nick 3 Don't use away messages here. [5 Minute ban]
    }
  }
}
