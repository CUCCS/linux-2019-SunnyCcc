#! bin/bash

#显示帮助信息
function help_information {
  echo "      usage bash task1.sh DIRECTORY [option]..."
  echo "      DIRECTORY  the directory of the pictures that you want to deal with"
  echo "      -h print this usage and exit"
  echo "      -c type a compression level for JPEG images"
  echo "      -C type a width to compress JPEG/PNG/SVG format picture under the premise of maintaining the original aspect ratio"
  echo "      -w type the watermark to embed into the pictures"
  echo "      -p type the prefix to add to the pictures'names"
  echo "      -s type the suffix to add to the pictures'names"
  echo "      -t convert png/svg to jpeg"
}

#对jpeg格式图片进行图片质量压缩
function compress_jpeg {
  for i in *.jpg;
  do 
     convert "$i" -quality "$2" ../"$i"
  done	 
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function compress_jpeg_png_svg {
  for i in *;
  do 
    convert "$i" -resize "$2" ../"$i"
  done
}

#对图片批量添加自定义文本水印
function embed {
  for i in *;
  do 
    convert "$i" -fill black -pointsize 13 -draw "text 10,15 '$2' " ../"$i"
  done
}

#批量重命名（统一添加文件名前缀，不影响原始文件扩展名）
function prefix {
  for i in *;
  do
    cp "$i" ../"$2""$i"
  done
}

#批量重命名（统一添加文件名后缀，不影响原始文件扩展名）
function suffix {
  for i in *;
  do 
    filename="$i"
    extension=${filename##*.}
    filename=$(echo "$i" | cut -d . -f1)
    cp "$i" ../"$filename""$2"".""$extension"
  done
}

#将png/svg图片统一转换为jpg格式图片
function convert_pngandsvg_to_jpeg {
  for i in *png;
  do 
    filename="$i"
    extension=${filename##*.}
    filename=$(echo "$i" | cut -d . -f1)
    convert "$i" ../"$filename"".jpg"
  done
  for i in *svg; 
  do 
    filename="$i"
    extension=${filename##*.}
    filename=$(echo "$i" | cut -d . -f1)
    convert "$i" ../"$filename"".jpg"
  done
}

if [[ "$#" -lt 1 ]]; then
  echo "arguments too short."
else
  cd "$1"
  shift 1
  until [ "$#"  -eq 0 ]
  do
    case "$1" in
      "-c")
	 if [[ "$2" != '' ]];then
           compress_jpeg "$@"
	   shift 2
	 else 
           echo "missing an argument:compression level"
	   shift
	 fi
	 ;;
      "-C")
	 if [[ "$2" != '' ]];then
	   compress_jpeg_png_svg "$@"
	   shift 2
         else
           echo "missing an argument:width"
	   shift
	 fi
	 ;;
      "-w")
	 if [[ "$2" != '' ]];then
	   embed "$@"
	   shift 2
	 else
           echo "missing an argument:watermark"
	   shift
	 fi
	 ;;
      "-p")
	 if [[ "$2" != '' ]];then
	   prefix "$@"
	   shift 2
	 else
           echo "missing an argument:prefix"
	   shift
	 fi
	 ;;
      "-s")
	 if [[ "$2" != '' ]];then
	   suffix "$@"
	   shift 2
	 else
           echo "missing an argument:suffix"
	   shift
	 fi
	 ;;
      "-t")
	 convert_pngandsvg_to_jpeg "$@"
	 shift
	 ;;
      "-h")
	 help_information
	 shift
	 ;;
   esac	    
  done
fi
