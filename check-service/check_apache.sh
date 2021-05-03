#!/bin/bash
# vérifié si apache2est présent

servstat=$(service apache2 status)
if [[ $servstat == *"active (running)"* ]]; then
  echo "process is running"
else echo "process is not running"
fi