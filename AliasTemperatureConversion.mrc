alias Temp {
  /*
  This script is used to convert tempature between two scales.
  Usage: /Temp SCALE TEMPERATURE
  Example: /Temp F 94.5
  Supported scales:
  - F (Fahrenheit)
  - C (Celsius)
  - K (Kelvin)
  */

  if ($2 isnum) {
    if (F == $1) {
      echo -a 07 $+ $2 in Fahrenheit is:
      echo -a 07 $+ $calc(($2 - 32) * 5/9) in Celsius.
      echo -a 07 $+ $calc(($2 + 459.67) * 5/9) in Kalvin.
    }
    elseif (C == $1) {
      echo -a 07 $+ $2 in Celsius is:
      echo -a 07 $+ $calc($2 * (9/5) + 32) in Fahrenheit.
      echo -a 07 $+ $calc($2 + 275.15) in Kalvin.
    }
    elseif (K == $1) {
      echo -a 07 $+ $2 in Kalvin is:
      echo -a 07 $+ $calc($2 - 275.15) in Celsius.
      echo -a 07 $+ $calc($2 * (9/5) - 459.67) in Fahrenheit.
    }
    else { 
      echo -a Syntax: /Temp [FCK] [Number]
      echo -a Example: /Temp F 60
    }
  }
  else { 
    echo -a Syntax: /Temp [FCK] [Number]
    echo -a Example: /Temp F 60
  }
}