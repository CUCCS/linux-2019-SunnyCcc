#! bin/bash

  min=200
  max=0
  oldest=()
  youngest=()
  age_less_than_20=0
  age_between_20_30=0
  age_greater_than_30=0
  sum=0
  declare -A a #a<位置，人数>
  longest=()
  shortest=()
  llen=0
  slen=200
  i=2
  
  row=$(sed -n "$i"p "$1")
  while [[ "$row" != '' ]];do
    IFS='	' 
    read -r -a arr<<<"$row"
    age=${arr[5]}
    name=${arr[8]}
    
    #统计各年龄区段的人数
    if [[ "$age" -lt 20 ]];then
      age_less_than_20=$((age_less_than_20+1))
    elif [[ "$age" -gt 30 ]];then
      age_greater_than_30=$((age_greater_than_30+1))
    else
      age_between_20_30=$((age_between_20_30+1))
    fi
   
    #记录年龄最小和最大的球员
    if [[ "$age" -lt "$min" ]];then
      min="$age"
      youngest=("$name")
    elif [[ "$age" -eq $min ]];then
	youngest=("${youngest[@]}" "$name")
    fi

    if [[ "$age" -gt "$max" ]];then
      max="$age"
      oldest=("$name")
    elif [[ "$age" -eq "$max" ]];then
      oldest=("${oldest[@]}" "$name")
    fi
    
    #统计场上不同位置的球员数量
    pos=${arr[4]}
    flag=0
    for j in "${!a[@]}"; do
      if [[ "$pos" == "$j" ]];then
	a["$j"]=$(( ${a["$j"]}+1 ))
	flag=1
	break
      fi
    done
    if [[ "$flag" -eq 0 ]];then
      a["$pos"]=1
    fi

    #最长的名字与最短的名字
    len=${#name}
    
    if [[ "$len" -lt "$slen" ]];then
      slen=$len
      shortest=("$name")
    elif [[ "$len" -eq "$slen" ]];then
      shortest=("${shortest[@]}" "$name")
    fi

    if [[ "$len" -gt "$llen" ]];then
      llen="$len"
      longest=("$name")
    elif [[ "$len" -eq "$llen" ]];then
      longest=("${longest[@]}" "$name")
    fi
    
    sum=$(( $sum+1 ))
    i=$(( $i+1 ))
    row=$(sed -n "$i"p "$1")
 done

a1=$(echo "scale=2; $age_less_than_20*100/$sum" | bc)
a2=$(echo "scale=2; $age_between_20_30*100/$sum" | bc)
a3=$(echo "scale=2; $age_greater_than_30*100/$sum" | bc)
printf "Age    Amount    Percentage \n">>task2_ans
printf "%-7s%-10s%-.2f%%\n" "<20" "$age_less_than_20" "$a1">>task2_ans
printf "%-7s%-10s%-.2f%%\n" "20~30" "$age_between_20_30" "$a2">>task2_ans
printf "%-7s%-10s%-.2f%%\n" "<20" "$age_greater_than_30" "$a3">>task2_ans

printf "\nPosition     Amount    Percentage\n">>task2_ans
for i in "${!a[@]}"; do
  p=$(echo "scale=2; ${a[$i]}*100/$sum" | bc)
  printf "%-13s%-10s%-.2f%%\n" "$i" "${a["$i"]}" "$p">>task2_ans
done

printf "\nthe player with the longest name(length:%s): \n" "$llen">>task2_ans
for i in "${longest[@]}"; do
  printf "$i\n">>task2_ans
done

printf "\nthe player with the shortest name(length:%s): \n" "$slen">>task2_ans
for i in "${oldest[@]}"; do
  printf "$i\n">>task2_ans
done

printf "\nthe oldest player(age:%s): \n" "$max">>task2_ans
for i in "${oldest[@]}"; do
  printf "$i\n">>task2_ans
done

printf "\nthe youngest player(age:%s): \n" "$min">>task2_ans
for i in "${shortest[@]}"; do
  printf "$i\n">>task2_ans
done

