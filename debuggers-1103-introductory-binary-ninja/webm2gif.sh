#!/bin/bash

# 检查ffmpeg是否已安装
if ! command -v ffmpeg &>/dev/null; then
	echo "错误：未检测到ffmpeg，请先安装ffmpeg并确保其可执行" >&2
	exit 1
fi

# 检查参数数量是否正确
if [ $# -ne 2 ]; then
	echo "用法：$0 <输入文件路径> <输出文件路径>" >&2
	echo "示例：$0 input.webm output.gif" >&2
	exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"

# 检查输入文件是否存在
if [ ! -f "$INPUT_FILE" ]; then
	echo "错误：输入文件 '$INPUT_FILE' 不存在" >&2
	exit 1
fi

# 执行转换命令
ffmpeg -i "$INPUT_FILE" \
	-filter_complex "[0:v]fps=10,scale=640:-1,palettegen=max_colors=256:stats_mode=diff[out_palette]; \
                     [0:v][out_palette]paletteuse=dither=floyd_steinberg:bayer_scale=5[out_gif]" \
	-map "[out_gif]" "$OUTPUT_FILE"

# 检查转换是否成功
if [ $? -eq 0 ]; then
	echo "转换成功！输出文件：$OUTPUT_FILE"
else
	echo "错误：转换失败，请检查输入文件格式或ffmpeg参数" >&2
	exit 1
fi
