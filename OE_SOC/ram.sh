

LANG=C

# get arguments

# #RED
while getopts 'w:c:hp' OPT; do
  case $OPT in
    w)  WARN=$OPTARG;;
    c)  CRIT=$OPTARG;;
    h)  hlp="yes";;
    p)  perform="yes";;
    *)  unknown="yes";;
  esac
done

# usage
HELP="
    usage: $0 [ -w value -c value -p -h ]
        -w --> Warning Percentage < value
        -c --> Critical Percentage < value
        -p --> print out performance data
        -h --> print this help screen
"

if [ "$hlp" = "yes" ]; then
  echo "$HELP"
  exit 0
fi

WARN=${WARN:=80}
CRIT=${CRIT:=90}

#Get total memory available on machine
TotalMem=$(free -m | grep Mem | awk '{ print $2 }')
#Determine amount of free memory on the machine
set -o pipefail
FreeMem=$(free -m | grep buffers/cache | awk '{ print $4 }')
if [ $? -ne 0 ];
  then
  FreeMem=$(free -m | grep Mem | awk '{ print $7 }')
fi
#Get percentage of free memory
FreePer=$(awk -v total="$TotalMem" -v free="$FreeMem" 'BEGIN { printf("%-10f\n", (free / total) * 100) }' | cut -d. -f1)
#Get actual memory usage percentage by subtracting free memory percentage from 100
UsedPer=$((100-$FreePer))


if [ "$UsedPer" = "" ]; then
  echo "MEM UNKNOWN -"
fi

if [ "$perform" = "yes" ]; then
  output="system memory usage: $UsedPer% | free memory="$UsedPer"%;$WARN;$CRIT;0"
else
  output="system memory usage: $UsedPer%"
fi

#if [ "$UsedPer" -gt 80 ]; then
#  echo "Clearimg Cache Memory" 
#  clear_output=$(sync; echo 1 > /proc/sys/vm/drop_caches)
#fi

if (( $UsedPer >= $CRIT )); then
  echo "MEM CRITICAL - $output"
elif (( $UsedPer >= $WARN )); then
  echo "MEM WARNING - $output"

#elif (( $UsedPer >= 80 )); then
#  echo "Clearing Caches"
#  exec sync; echo 1 > /proc/sys/vm/drop_caches
#  exit 1

else
  echo "MEM OK - $output"

fi

if [ "$UsedPer" -gt 80 ]; then
  echo "RAM MEMORY IS GETTING FULL CLEARING BUFFER AND CACHES" 
  clear_output=$(sync; echo 1 > /proc/sys/vm/drop_caches)
fi

#if (( $UsedPer >= 80% )); then
#  exec sync; echo 1 > /proc/sys/vm/drop_caches
#fi

