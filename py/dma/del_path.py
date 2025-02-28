import re
import sys

def clean_last_quoted_param(line):
    """
    使用前瞻断言精准定位最后一个引号参数
    保留原始代码缩进和格式特征
    """
    # 匹配函数调用最后一个带引号的参数
    pattern = r'''
        (                       # 捕获组1：保留前面所有内容
            `rggen_ral_create_reg\(                  # 函数参数开始括号
            .*?                 # 非贪婪匹配所有字符
            ,                   # 定位到最后一个逗号
            \s*                 # 允许逗号后的空格
        )
        "                       # 参数开始的引号
        [^"]*                  # 清除引号内的所有内容
        "                       # 参数结束的引号
        (\s*\))                # 捕获组2：保留括号和空格
    '''
    return re.sub(pattern, r'\1""\2', line, flags=re.VERBOSE | re.DOTALL)

def process_file(input_path, output_path):
    """带格式保护的代码文件处理"""
    with open(input_path, 'r') as infile, open(output_path, 'w') as outfile:
        for line in infile:
            # 保留原始行尾换行符
            processed = clean_last_quoted_param(line.rstrip('\n'))
            outfile.write(processed + '\n')

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_file> <output_file>")
        sys.exit(1)
    
    process_file(sys.argv[1], sys.argv[2])
    print(f"Processing completed. Output saved to {sys.argv[2]}")
