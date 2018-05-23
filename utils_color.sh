#!/bin/bash
### Author: Yufei
### Date: 2017.06.14
### Desc: util shell for color text output

## https://zh.wikipedia.org/wiki/Echo_(%E5%91%BD%E4%BB%A4)
## http://misc.flogisoft.com/bash/tip_colors_and_formatting , color and format reference
_red="\033[31m"
_purple="\033[35m"
_green="\033[32m"
_blue="\033[36m"

_bold="\033[1m"
_underline="\033[4m"
_blink="\033[5m"

_normal="\033[m"

if [[ $1 == "help" ]]; then
  echo -e "${_red}Hello the world is red!${_normal}"
  echo -e "${_purple}Hello the world is purple!${_normal}"
  echo -e "${_green}Hello the world is green!${_normal}"
  echo -e "${_blue}Hello the world is bule!${_normal}"
  echo -e "${_bold}Hello the world is bold!${_normal}"
  echo -e "${_bold}${_red}Hello the world is red bold!${_normal}"
  echo -e "Hello the world is normal"
fi
