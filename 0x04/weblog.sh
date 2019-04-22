#! /bin/bash

function help_information {
  echo "  usage task3.sh FILE [options]..."
  echo "  FILE the file that you want to count"
  echo "  -H count the top 100 source hosts visited"
  echo "  -i count the top 100 source IP address visited"
  echo "  -u count the top 100 url most frequently visited"
  echo "  -r count different response status codes "
  echo "  -x count the top 10 url and the times of occurance related 4xx status code "
  echo "  -U enter an url to count the top 100 source hosts"
  echo "  -h print this usage and exit"
}

function top100hosts {
  sed -n '2,$p' "$1"|awk -F '\t' '{hosts[$1]++} END {for (i in hosts) printf("%-40s %-10d\n",i,hosts[i])}' |sort -r -n -k 2|sed -n 1,100p
}

function top100ip {
  sed -n '2,$p' "$1"|awk -F '\t' '$1 ~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/{ip[$1]++} END {for (i in ip) printf("%-40s%-10d\n",i,ip[i])}'|sort -n -r -k 2|sed -n 1,100p
}

function top100url {
  sed -n '2,$p' "$1"|awk -F '\t' '{url[$5]++} END {for (i in url) printf("%-60s %-10d\n",i,url[i])}' |sort -r -n -k 2|sed -n 1,100p
}

function statuscode {
  sed -n '2,$p' "$1"|awk -F '\t' '{response[$6]++} END {for (i in response) printf("%-10s %-10d %10.6f%%\n",i,response[i],response[i]*100/NR)}' |sort -r -n -k 2|sed -n '1,$p'
}

function statuscode4xx {
  status4xx=$(sed -n '2,$p' "$1" | awk -F '\t' '{if($6~/^4/) {print $6}}'| sort -u)
  for i in $status4xx;do
	  echo "$i"
	  sed -n '2,$p' "$1" |awk -F '\t' '{if( $6=="'$i'" ) {url[$5]++}} END {for (j in url)printf("%-60s%-10d\n",j,url[j])}' | sort -r -n -k 2 |sed -n 1,10p
	  echo " "
  done
} 

function urltop10hosts {
  sed -n '2,$p' "$1" |awk -F '\t' '{if($5=="'$2'") hosts[$1]++} END {for(i in hosts) printf("%-40s%-10d\n",i,hosts[i])}' |sort -r -n -k 2 |sed -n '1,100p'
}

if [[ $# -lt 1 ]];then
	echo "Arguments too short,you need to input a file."
else
	file="$1"
	shift
	until [ "$#" -eq 0 ]
	do
		case "$1" in
			"-H")
				top100hosts "$file"
				shift
				;;
			"-i")
				top100ip "$file"
				shift
				;;
			"-u")
				top100url "$file"
				shift
				;;
			"-r")
				statuscode "$file"
				shift
				;;
			"-x")
				statuscode4xx "$file"
				shift
				;;
			"-U")
				if [[ "$2" != '' ]];then
				  	urltop10hosts "$file" "$2"
				  	shift 2
				else
					echo "missing an argument: url"
					shift
				fi
				;;
			"-h")
				help_information
				shift
				;;
		esac
	done
fi
