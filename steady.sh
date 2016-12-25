#!/bin/bash
# =====================================================================================================
# Copyright (C) steady.sh v1.2 2016 
# =====================================================================================================
#-------------------------------------------------
#--    ▒▒▒▒▒▒▒▒▒                                --
#--    ▒▒▒▒▒▒▒█▒                                --
#--    ▒███████▒                                --
#--    ▒▒▒▒▒▒▒█▒                                --
#--    ▒▒▒▒▒▒▒▒▒                                --
#--    ▒███████▒                                --
#--    ▒█▒▒▒▒▒█▒                                --
#--    ▒▒█████▒▒                                --
#--    ▒▒▒▒▒▒▒▒▒                                --
#--    ▒▒▒▒▒▒▒▒▒                                --
#--    ▒█▒▒█▒▒█▒                                --
#--    ▒███████▒                                --
#--    ▒▒▒▒▒▒▒▒▒                                --
#-------------------------------------------------
#--                                             --
#--                  TeleDiamond                --
#--                                             --
#--                                             --
#-------------------------------------------------

OK=0
BAD=0
NONVOLUNTARY=1
NONVOLUNTARYCHECK=0
VOLUNTARY=1
VOLUNTARYCHECK=0
I=1
BOT=mohammadwolf
RELOADTIME=10 

function tmux_mode {

sleep 0.5
clear

f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'

cat << EOF

 $f1  ▀▄   ▄▀     $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4  ▀▄   ▄▀     $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
 $f1 ▄█▀███▀█▄    $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4 ▄█▀███▀█▄    $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
 $f1█▀███████▀█   $f2▀▀███▀▀███▀▀   $f3▀█▀██▀█▀   $f4█▀███████▀█   $f5▀▀███▀▀███▀▀   $f6▀█▀██▀█▀$rst
 $f1▀ ▀▄▄ ▄▄▀ ▀   $f2 ▀█▄ ▀▀ ▄█▀    $f3▀▄    ▄▀   $f4▀ ▀▄▄ ▄▄▀ ▀   $f5 ▀█▄ ▀▀ ▄█▀    $f6▀▄    ▄▀$rst
 
EOF
echo -e "                \e[100m                Steady script           \e[00;37;40m"
echo -e "               \e[01;34m                    @TeleDiamondCh                 \e[00;37;40m"
echo ""
cat << EOF
 $bld$f1▄ ▀▄   ▄▀ ▄   $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4▄ ▀▄   ▄▀ ▄   $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
 $bld$f1█▄█▀███▀█▄█   $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4█▄█▀███▀█▄█   $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
 $bld$f1▀█████████▀   $f2▀▀▀██▀▀██▀▀▀   $f3▀▀█▀▀█▀▀   $f4▀█████████▀   $f5▀▀▀██▀▀██▀▀▀   $f6▀▀█▀▀█▀▀$rst
 $bld$f1 ▄▀     ▀▄    $f2▄▄▀▀ ▀▀ ▀▀▄▄   $f3▄▀▄▀▀▄▀▄   $f4 ▄▀     ▀▄    $f5▄▄▀▀ ▀▀ ▀▀▄▄   $f6▄▀▄▀▀▄▀▄$rst

EOF

sleep 1.2

echo -e "$bld$f4 CHECKING INSTALLED BOT...$rst"
sleep 0.5
ls ../ | grep $BOT > /dev/null
if [ $? != 0 ]; then
  echo -e "$f1 td folder not found$rst"
  sleep 4
  exit 1
fi
echo -e "$f2 $td folder found$rst"
sleep 0.5

echo ""
echo -e "\033[38;5;208m @TeleDiamondh    :)      @TeleDiamondh \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondh \033[0;00m"
echo -e "\033[38;5;208m @TeleDiamondh    :)      @TeleDiamondh \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondh \033[0;00m"
echo -e "\033[38;5;208m @TeleDiamondh    :)      @TeleDiamondh \033[0;00m"

sleep 1.5
echo -e "$bld$f4 check ...$rst"
sleep 0.7

CLINUM=`ps -e | grep -c telegram-cli`
echo "$f2 running $CLINUM TELEGRAM-CLI PROCESS$rst"
sleep 0.9

echo -e "$bld$f4 ATTACHING TMUX AS DAEMON...$rst"

rm ../.telegram-cli/state  > /dev/null 

TMUX= tmux new-session -d -s $BOT "./launch.sh"
sleep 1.3

CLIPID=`ps -e | grep telegram-cli | head -1 | sed 's/^[[:space:]]*//' | cut -f 1 -d" "`
echo -e "$f2 NEW TELEGRAM-CLI PROCESS: $CLIPID$rst"
echo ""
echo ""

cat /proc/$CLIPID/task/$CLIPID/status > STATUS
NONVOLUNTARY=`grep nonvoluntary STATUS | cut -f 2 -d":" | sed 's/^[[:space:]]*//'`

sleep 3

while true; do
  
	echo -e "$f2 TIMES CHECKED AND RUNNING:$f5 $OK $rst"
	echo -e "$f2 TIMES FAILED AND RECOVERED:$f5 $BAD $rst"
	echo ""
	
	cat /proc/$CLIPID/task/$CLIPID/status > CHECK
	if [ $? != 0 ]; then
		I=$(( $I + 1 ))
		if [ $I -ge 3 ]; then
			kill $CLIPID
			tmux kill-session -t $BOT
			rm ../.telegram-cli/state  > /dev/null 
			NONVOLUNTARY=0
			NONVOLUNTARYCHECK=0
			VOLUNTARY=0
			VOLUNTARYCHECK=0
		fi
	else
		I=1
	fi
	VOLUNTARYCHECK=`grep voluntary CHECK | head -1 | cut -f 2 -d":" | sed 's/^[[:space:]]*//'`
	NONVOLUNTARYCHECK=`grep nonvoluntary CHECK | cut -f 2 -d":" | sed 's/^[[:space:]]*//'`
	
	if [ $NONVOLUNTARY != $NONVOLUNTARYCHECK ] || [ $VOLUNTARY != $VOLUNTARYCHECK ]; then
		echo -e "$f5 BOT RUNNING!$rst"
		OK=$(( $OK + 1 ))

	else
		echo -e "$f5 BOT NOT RUNING, TRYING TO RELOAD IT...$rst"
		BAD=$(( $BAD + 1 ))
		sleep 1
		
		rm ../.telegram-cli/state  > /dev/null 

		kill $CLIPID
		tmux kill-session -t $BOT
	
		TMUX= tmux new-session -d -s $BOT "./launch.sh"
		sleep 1
		
		CLIPID=`ps -e | grep telegram-cli | head -1 | sed 's/^[[:space:]]*//' | cut -f 1 -d" "`
		
		if [ -z "${CLIPID}" ]; then
			echo -e "$f1 ERROR: TELEGRAM-CLI PROCESS NOT RUNNING$rst"
			echo -e "$f1 FAILED TO RECOVER BOT$rst"
			sleep 3
			exit 1
		fi

	fi
	
	VOLUNTARY=`echo $VOLUNTARYCHECK`
	NONVOLUNTARY=`echo $NONVOLUNTARYCHECK`
	sleep $RELOADTIME
	rm CHECK
	
done

}

function screen_mode {

clear
sleep 0.5

f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'

cat << EOF

 $f1  ▀▄   ▄▀     $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4  ▀▄   ▄▀     $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
 $f1 ▄█▀███▀█▄    $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4 ▄█▀███▀█▄    $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
 $f1█▀███████▀█   $f2▀▀███▀▀███▀▀   $f3▀█▀██▀█▀   $f4█▀███████▀█   $f5▀▀███▀▀███▀▀   $f6▀█▀██▀█▀$rst
 $f1▀ ▀▄▄ ▄▄▀ ▀   $f2 ▀█▄ ▀▀ ▄█▀    $f3▀▄    ▄▀   $f4▀ ▀▄▄ ▄▄▀ ▀   $f5 ▀█▄ ▀▀ ▄█▀    $f6▀▄    ▄▀$rst
 
EOF
echo -e "                \e[100m                Steady script           \e[00;37;40m"
echo -e "               \e[01;34m                    @mrr619                 \e[00;37;40m"
echo ""
cat << EOF
 $bld$f1▄ ▀▄   ▄▀ ▄   $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4▄ ▀▄   ▄▀ ▄   $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
 $bld$f1█▄█▀███▀█▄█   $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4█▄█▀███▀█▄█   $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
 $bld$f1▀█████████▀   $f2▀▀▀██▀▀██▀▀▀   $f3▀▀█▀▀█▀▀   $f4▀█████████▀   $f5▀▀▀██▀▀██▀▀▀   $f6▀▀█▀▀█▀▀$rst
 $bld$f1 ▄▀     ▀▄    $f2▄▄▀▀ ▀▀ ▀▀▄▄   $f3▄▀▄▀▀▄▀▄   $f4 ▄▀     ▀▄    $f5▄▄▀▀ ▀▀ ▀▀▄▄   $f6▄▀▄▀▀▄▀▄$rst

EOF

sleep 1.3

echo -e "$bld$f4 CHECKING INSTALLED BOT...$rst"
sleep 0.5
ls ../ | grep $BOT > /dev/null
if [ $? != 0 ]; then
  echo -e "$f1 td folder not found$rst"
  sleep 4
  exit 1
fi
echo -e "$f2 $td folder found$rst"
sleep 0.5


echo ""
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"

sleep 1.5
echo -e "$bld$f4 ]; checking PROCESS...$rst"
sleep 0.7


SCREENNUM=`ps -e | grep -c screen`
CLINUM=`ps -e | grep -c telegram-cli`

if [ $SCREENNUM -ge 3 ]; then
  echo -e "$f1 ERROR: MORE THAN 2 PROCESS OF SCREEN RUNNING.$rst"
  echo -e "$f1 THESE PROCESSES HAVE BE KILLED. THEN RESTART THE SCRIPT$rst"
  echo -e '$f1 RUN: "killall screen" $rst'
  if [ $CLINUM -ge 2 ]; then
    echo -e "$f1 ERROR: MORE THAN 1 PROCESS OF TELEGRAM-CLI RUNNING.$rst"
    echo -e "$f1 THESE PROCESSES WILL BE KILLED. THEN RESTART THE SCRIPT$rst"
	echo -e "$f1 RUN: killall telegram-cli $rst"
  fi
  sleep 4
  exit 1
fi
echo "$f2 SCREEN NUMBER AND CLI NUMBER UNDER THE SUPPORTED LIMIT"
sleep 0.7
echo "$f2 RUNNING $SCREENNUM SCREEN PROCESS$rst"
echo "$f2 RUNNING $CLINUM TELEGRAM-CLI PROCESS$rst"
sleep 0.9


ps -e | grep screen | sed 's/^[[:space:]]*//' | cut -f 1 -d" " | while read -r line ; do
  sleep 0.5
  echo -e "$f2 SCREEN NUMBER $I PID: $line$rst"
  if [ $I -eq 1 ]; then
    echo $line > SC1
  else
    echo $line > SC2
  fi
  I=$(( $I + 1 ))
done

SCREENPID1=`cat SC1`
SCREENPID2=`cat SC2`
rm SC1 SC2 >/dev/null

sleep 0.7
CLIPID=`ps -e | grep telegram-cli | sed 's/^[[:space:]]*//' | cut -f 1 -d" "`
if [ $CLINUM -eq 1 ]; then
  echo -e "$f2 RUNNING ONE PROCESS OF TELEGRAM-CLI: $CLIPID1$rst"
  echo -e "$bld$f4 KILLING TELEGRAM-CLI PROCESS. NOT NEEDED NOW$rst"
  kill $CLIPID1
else
  echo -e "$f2 RUNNING ZERO PROCESS OF TELEGRAM-CLI$rst"
fi
sleep 0.7


CLINUM=`ps -e | grep -c telegram-cli`
if [ $CLINUM -eq 1 ]; then
  echo -e "$f1 ERROR: TELEGRAM-CLI PID COULDN'T BE KILLED. IGNORE.$rst"
fi
sleep 1


echo -e "$bld$f4 ATTACHING SCREEN AS DAEMON...$rst"

rm ../.telegram-cli/state  > /dev/null 
screen -d -m bash launch.sh

sleep 1.3

SCREENNUM=`ps -e | grep -c screen`
if [ $SCREENNUM != 3 ]; then
  echo -e "$f1 ERROR: SCREEN RUNNING: $SCREENNUM \n SCREEN ESPECTED: 3$rst"
  exit 1
fi

sleep 0.7
echo -e "$bld$f4 RELOADING SCREEN INFO...$rst"
sleep 1
echo -e "$f2 NUMBER OF SCREEN ATTACHED: $SCREENNUM$rst"
echo -e "$f2 SECONDARY SCREEN: $SCREENPID1 AND $SCREENPID2$rst"
SCREEN=`ps -e | grep -v $SCREENPID1 | grep -v $SCREENPID2 | grep screen | sed 's/^[[:space:]]*//' | cut -f 1 -d" "`

sleep 0.5
echo -e "$f2 PRIMARY SCREEN: $SCREEN$rst"

sleep 0.7
echo -e "$bld$f4 RELOADING TELEGRAM-CLI INFO...$rst"
sleep 0.7

CLIPID=`ps -e | grep telegram-cli | sed 's/^[[:space:]]*//' |cut -f 1 -d" "`
echo -e "$f2 NEW TELEGRAM-CLI PID: $CLIPID$rst"
if [ -z "${CLIPID}" ]; then
  echo -e "$f1 ERROR: TELEGRAM-CLI PROCESS NOT RUNNING$rst"
  sleep 3
  exit 1
fi

cat /proc/$CLIPID/task/$CLIPID/status > STATUS
NONVOLUNTARY=`grep nonvoluntary STATUS | cut -f 2 -d":" | sed 's/^[[:space:]]*//'`


sleep 5

  while true; do
  
	echo -e "$f2 TIMES CHECKED AND RUNNING:$f5 $OK $rst"
	echo -e "$f2 TIMES FAILED AND RECOVERED:$f5 $BAD $rst"
	echo ""
	
	cat /proc/$CLIPID/task/$CLIPID/status > CHECK
	VOLUNTARYCHECK=`grep voluntary CHECK | head -1 | cut -f 2 -d":" | sed 's/^[[:space:]]*//'`
	NONVOLUNTARYCHECK=`grep nonvoluntary CHECK | cut -f 2 -d":" | sed 's/^[[:space:]]*//'`
	#echo -e "NONVOLUNTARYCHECK CTXT SWITCHES: $NONVOLUNTARYCHECK"
	#echo -e "NONVOLUNTARY CTXT SWITCHES: $NONVOLUNTARY"
	
	if [ $NONVOLUNTARY != $NONVOLUNTARYCHECK ] || [ $VOLUNTARY != $VOLUNTARYCHECK ]; then
		echo -e "$f5 BOT RUNNING!$rst"
		OK=$(( $OK + 1 ))

	else
		echo -e "$f5 BOT NOT RUNING, TRYING TO RELOAD IT...$rst"
		BAD=$(( $BAD + 1 ))
		sleep 1
		
		rm ../.telegram-cli/state  > /dev/null 

		kill $CLIPID
		kill $SCREEN
		
		screen -d -m bash launch.sh
		sleep 1
		
		CLIPID=`ps -e | grep telegram-cli | sed 's/^[[:space:]]*//' | cut -f 1 -d" "`
		
		if [ -z "${CLIPID}" ]; then
			echo -e "$f1 ERROR: TELEGRAM-CLI PROCESS NOT RUNNING$rst"
			echo -e "$f1 FAILED TO RECOVER BOT$rst"
			sleep 1
		fi
		
		SCREENNUM=`ps -e | grep -c screen`
		if [ $SCREENNUM != 3 ]; then
			echo -e "$f1 ERROR: SCREEN RUNNING: $SCREENNUM \n SCREEN ESPECTED: 3$rst"
			echo -e "$f1 FAILED TO RECOVER BOT$rst"
			exit 1
		fi

		SCREEN=`ps -e | grep -v $SCREENPID1 | grep -v $SCREENPID2 | grep screen | sed 's/^[[:space:]]*//' | cut -f 1 -d" "`
		echo -e "$f5 BOT HAS BEEN SUCCESFULLY RELOADED!$rst"
		echo -e "$f2 TELEGRAM-CLI NEW PID: $CLIPID$rst"
		echo -e "$f2 SCREEN NEW PID: $SCREEN$rst"
		sleep 3
		
	fi
	
	VOLUNTARY=`echo $VOLUNTARYCHECK`
	NONVOLUNTARY=`echo $NONVOLUNTARYCHECK`
	sleep $RELOADTIME
	rm CHECK
	
  done

}

function tmux_detached {
clear
TMUX= tmux new-session -d -s script_detach "bash steady.sh -t"
echo -e "\e[1m"
echo -e ""
echo "Bot running in the backgroud with TMUX"
echo ""
echo -e "\e[0m"
sleep 3
tmux kill-session script
exit 1
}

function screen_detached {
clear
screen -d -m bash launch.sh
echo -e "\e[1m"
echo -e ""
echo "Bot running in the backgroud with SCREEN"
echo ""
echo -e "\e[0m"
sleep 3
quit
exit 1
}



if [ $# -eq 0 ]
then
	echo -e "\e[1m"
	echo -e ""
	echo "Missing options!"
	echo "Run: bash steady.sh -h  for help!"
	echo ""
	echo -e "\e[0m"
    sleep 1
	exit 1
fi

while getopts ":tsTSih" opt; do
  case $opt in
    t)
	echo -e "\e[1m"
	echo -e ""
	echo "TMUX multiplexer option has been triggered." >&2
	echo "Starting script..."
	sleep 1.5
	echo -e "\e[0m"
	tmux_mode
	exit 1
      ;;
	s)
	echo -e "\e[1m"
	echo -e ""
	echo "SCREEN multiplexer option has been triggered." >&2
	echo "Starting script..."
	sleep 1.5
	echo -e "\e[0m"
	screen_mode
	exit 1
      ;;
    T)
	echo -e "\e[1m"
	echo -e ""
	echo "TMUX multiplexer option has been triggered." >&2
	echo "Starting script..."
	sleep 1.5
	echo -e "\e[0m"
	tmux_detached
	exit 1
      ;;
	S)
	echo -e "\e[1m"
	echo -e ""
	echo "SCREEN multiplexer option has been triggered." >&2
	echo "Starting script..."
	sleep 1.5
	echo -e "\e[0m"
	screen_detached
	exit 1
      ;;
	i)
	echo -e "\e[1m"
	echo -e ""
	echo "steady.sh bash script v3 telediamond" >&2
	echo ""
	echo -e "\e[0m"

echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo -e "\033[38;5;208m @mrr619    :)      @TeleDiamondch \033[0;00m"
echo ""
	exit 1
      ;;
	h)
	echo -e "\e[1m"
	echo -e ""
	echo "Usage:"
	echo -e ""
	echo "steady.sh -t"
	echo "steady.sh -s"
	echo "steady.sh -T"
	echo "steady.sh -S"
	echo "steady.sh -h"
	echo "steady.sh -i"
    echo ""
	echo "Options:"
	echo ""
    echo "   -t     select TMUX terminal multiplexer"
	echo "   -s     select SCREEN terminal multiplexer"
	echo "   -T     select TMUX and detach session after start"
	echo "   -S     select SCREEN and detach session after start"
	echo "   -h     script options help page"
	echo "   -i     information about the script"
	echo -e "\e[0m"
	exit 1
	;;
	  
    \?)
	echo -e "\e[1m"
	echo -e ""
    echo "Invalid option: -$OPTARG" >&2
	echo "Run bash $0 -h for help"
	echo -e "\e[0m"
	exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

