#!/usr/bin/python3
# File name : update_svh.py
# Author      : donghao lv (Full Name Please)
# Created     : Sun 22 Sep 2024 08:05:25 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
import re
def format_line(line):
    parts = line.split()
    
    if len(parts) < 5:
        return None
    reg_string  =  parts[0]
    output_string = parts[4]
    
    if output_string  == "None":
        return None
    formatted_line = f"""
        CSR_OUTPUT_REG_ARRAY["{output_string}"] = "{reg_string}" ;\\"""
    
    return formatted_line


def update_svh():
    input_file_path  =  '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/py/ral_output.dat'
    svh_file_path  =  '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/csr_macro.svh'
    with open(input_file_path, 'r') as input_file:
        lines  =  input_file.readlines()
    format_lines  = []
    for index, line in enumerate(lines):
        formatted  =  format_line(line.strip())
        if formatted:
            format_lines.append(formatted)

    with open(svh_file_path, 'r') as csr_file:
        csr_content  =  csr_file.readlines()
    start_marker = "`define CSR_OUTPUT_REG_ARRAY_INIT \\"
    end_marker = "//end_CSR_OUTPUT_REG_ARRAY_INIT<<\\"

    start_index = None
    end_index = None

    for i, line in enumerate(csr_content):
        if start_marker in line:
            start_index  =  i
        elif end_marker in line:
            end_index  = i
            break

    if start_index is not None and end_index is not None:
        filtered_format_lines = [line for line in format_lines if line.strip()]
        new_content  = (
            csr_content[:start_index + 1] + 
            filtered_format_lines + 
             ['\n'] +
            csr_content[end_index:]
        )
        with open(svh_file_path, 'w') as csr_file:
            csr_file.writelines(new_content)
        with open(svh_file_path, 'r') as csr_file:
            lines  =  csr_file.readlines()
            index  =  start_index + 1
            if 0 <= index < len(lines):
                removed_line = lines.pop(index)  #
                print(f"Removed: {removed_line}")
        with open(svh_file_path, 'w') as csr_file:
            csr_file.writelines(lines)

            
            
        print(f" csr.svh replace the content between {start_marker} and {end_marker} ")
    else:
        print("csr.svh drv can not found the marker")

if __name__  == "__main__":
    update_svh()
    print('finish the update_drv.py')
        
