#!/bin/bash
## Desc: create ssh tunnel to AWS env

declare -a envs_with_port_prefix=("qa1:20" "qa2:21" "qa3:22" "ppeus:23" "ppeie:24" "produs:25" "prodie:26")
declare -a boxes_with_port_suffix=("jmeter:001" "cmsdb:002" "newsdb:003" "rtdb:004" "bulkdb:005" "wireworksdb:006")
declare -a env_boxes
declare -a env_boxes_port

function join {
  local IFS="$1"; shift; echo "$*"; 
}

function checkport {
  tunnel=$1;
  port=$2;
  flag=`ps aux | grep ssh | grep $port | wc -l`
  if [[ $flag > 0 ]]; then
          echo "$tunnel port $port already exist, pls check."
          ps aux | grep ssh | grep $port
          exit 0;
  fi
}

function openssh {
  env=$1
  box=$2
  port=$3
  echo "env $env, box $box, port $port"
  if [[ $env == "qa1" ]]; then
    perm="~/.ssh/qa1.pem"
    jumpbox="0.0.0.0"
    if [[ $box == "jmeter" ]]; then
      target_host="0.0.0.0:0000"
    fi
  elif [[ $env == "qa2" ]]; then
    perm="~/.ssh/qa2.pem"
    jumpbox="0.0.0.0"
    if [[ $box == "jmeter" ]]; then
      target_host="0.0.0.0:0"
    fi
  elif [[ $env == "qa3" ]]; then
    perm="~/.ssh/qa3.pem"
    jumpbox="0.0.0.0"
  elif [[ $env == "ppeus" ]]; then
    perm="~/.ssh/rcom-ppe-us.pem"
    jumpbox="0.0.0.0"
    if [[ $box == "jmeter" ]]; then
      target_host="0.0.0.0:5901"
    fi
  elif [[ $env == "ppeie" ]]; then
    perm="~/.ssh/.pem"
    jumpbox="0.0.0.0"
  elif [[ $env == "produs" ]]; then
    perm="~/.ssh/0.0.0.0.pem"
    jumpbox="0.0.0.0"
  elif [[ $env == "prodie" ]]; then
    perm="~/.ssh/0.0.0.0.pem"
    jumpbox="0.0.0.0"
  fi
  
  if [[ $box == "cmsdb" ]]; then
    target_host='xxxxx:0000'
  elif [[ $box == "newsdb" ]]; then
    target_host='xxxxx.com:000'
  elif [[ $box == "rtdb" ]]; then
    target_host='realtimedbmaster:0000'
  elif [[ $box == "bulkdb" ]]; then
    target_host='mdbulkdbmaster:xxxx'
  elif [[ $box == "wireworksdb" ]]; then
    target_host='xxxx:20000'
  fi
  
  
  if [ -z $target_host ]; then
      echo "ssh host not exist, pls check"
      exit 1
  else 
    echo "ssh -i $perm -C -f -N -g -L *:$port:$target_host ec2-user@$jumpbox"
    ssh -i $perm -C -f -N -g -L *:$port:$target_host ec2-user@$jumpbox
  fi
  
  
  
  
}

for i in "${envs_with_port_prefix[@]}"
do
  for j in "${boxes_with_port_suffix[@]}"
  do
    env=`echo $i | cut -d':' -f 1`
    port_prefix=`echo $i | cut -d':' -f 2`
     
    box=`echo $j | cut -d':' -f 1`
    port_suffix=`echo $j | cut -d':' -f 2`
    
    envs+=(${env})
    env_boxes+=(${env}-${box})
    env_boxes_port+=(${env}-${box}:${port_prefix}${port_suffix})
  done
done



allbox=$(join '|' ${env_boxes[@]})
allbox_port=$(join '|' ${env_boxes_port[@]})

if [ -z $1 ]; then
        echo "Usage: $0 box, open ssh tunnel to box"
        echo "Usage: $0 port, show port mapping"
        echo "Box available: $allbox"
        exit 0
fi

if [[ $1 == 'port' ]]; then
  echo "Boxes port mapping, $allbox_port"
  exit 0;
fi

target_box=$1
for i in "${env_boxes[@]}"
do
  if [[ $i == $target_box ]]; then
    normal_box_flag=1
    break
  fi
done


if [ -z $normal_box_flag ]; then
  echo "box name: $target_box not exist! pls check."
  exit 1;
fi

for i in "${env_boxes_port[@]}"
do
  box_part=`echo $i | cut -d':' -f 1`
  port_part=`echo $i | cut -d':' -f 2`
  if [[ $target_box == $box_part ]]; then
    checkport $box_part $port_part
  fi
done


for i in "${env_boxes_port[@]}"
do
  box_part=`echo $i | cut -d':' -f 1`
  port_part=`echo $i | cut -d':' -f 2`
  if [[ $target_box == $box_part ]]; then
    box_env=`echo $target_box | cut -d'-' -f 1`
    box_name=`echo $target_box | cut -d'-' -f 2`
    openssh $box_env $box_name $port_part
  fi
done
  









