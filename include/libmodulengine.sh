#!/bin/bash
#Module engine :O
source /tmp/bashIRC/share
function e.hook() {
   #e.hook is revolutionary :D
   #penis[hook->chanMsg]() {
   # if [[ "$text" == *penis* ]]; then
   # msg $dest "sup penis."
   # fi
   #}
   #please mind my shitty usage of brackets :{
   #i'm addicted to C syntax :}
   #get all the functions
   #thanks gnu.org reference!
   functions=$(declare -F | awk '{print $NF}' | grep '\[hook->.*\]')
   for function in $functions; do
      
      if [[ "$function" =~ (.*)'[hook->'(.*)']' ]]; then
         event=${BASH_REMATCH[2]}
         func=${BASH_REMATCH[1]}
         
         case "${event,,}" in
            "chanmsg" ) {
                  if [ "$dest_chan" = "true" ] && [ "$command" = "PRIVMSG" ] && [ "$text" ]; then
                     $function
                  fi
            };;
            "privmsg" ) {
                  if [ "$dest_chan" = "false" ] && [ "$text" ]; then
                     $function
                  fi
            };;
            "channotice") {
                  if [ "$dest_chan" = "true" ] && [ "$command" = "NOTICE" ] && [ "$text" ]; then
                     $function
                  fi
            };;
            "privnotice") {
                  if [ "$dest_chan" = "false" ] && [ "$command" = "NOTICE" ] && [ "$text" ]; then
                     $function
                  fi
            };;
         esac
      fi
   done
}

Modules.load() {
   if [ ! "$modules" ]; then
      modules=$(ls ../modules | grep '.sh')
   fi
   for module in $modules; do
      function=$(../include/functiongrab.sh "../modules/$module")
      #load teh code!
      source <(echo $function)
   done
   modules=$(declare -F | grep -o '.*[module]' | wc -l)
   echo "$modules modules loaded!"
}
