/*
This script is used to convert tempature between two scales.
Usage: /Temp SCALE TEMPERATURE
Example: /Temp F 94.5
Supported scales:
- F (Fahrenheit)
- C (Celsius)
*/

alias Temp {
  if ($2 isnum) {
    if (F == $1) {
      echo 07 -a $2 in Fahrenheit is:
      echo 07 -a $calc(($2 - 32) * 5/9) in Celsius.
    }
    elseif (C == $1) {
      echo 07 -a $2 in Celsius is:
      echo 07 -a $calc($2 * (9/5) + 32) in Fahrenheit.
    }
    else {
      echo -a Syntax: /Temp [FC] [Number]
      echo -a Example: /Temp F 60
    }
  }
  else {
    echo -a Syntax: /Temp [FC] [Number]
    echo -a Example: /Temp F 60
  }
}
