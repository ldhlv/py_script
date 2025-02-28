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
def format_line(line, numbers, output_num, reg_num,   mode):
    parts = line.split(";")
    
    if len(parts) < numbers:
        return None
    reg_string  =  parts[reg_num].strip()
    output_string = parts[output_num].strip()
    
    if mode == 0: 
        if output_string  == "None":
            return None
        if reg_string  == "None":
            return None
        formatted_line = f"""
            CSR_OUTPUT_REG_ARRAY["{output_string}"] = "{reg_string}" ;\\"""
        
        return formatted_line

    if mode  == 1:
        field_start_bit  =  parts[numbers-2]
        field_width  =  parts[numbers-1]
        if output_string  == "None":
            return None
        if reg_string  == "None":
            return None
        formatted_line = f"""
            csr_na_s_w_temp.reg_name   =  "{reg_string}"; \\
            csr_na_s_w_temp.start_bit  =  {field_start_bit}; \\
            csr_na_s_w_temp.width      =  {field_width}; \\
            CSR_OUTPUT_FIELD_ARRAY["{output_string}"] = csr_na_s_w_temp ;\\"""
        
        return formatted_line




def update_svh():
    #input_file_path  =  '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/csr_py/ral_output.dat'
    input_file_path  = 'output2reg.dat' 
    input_field_path  =  'output_field2reg.dat'
    input_reserved_path  =  'reserved_addr.txt'
    svh_file_path  =  '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/csr_macro.svh'
    with open(input_file_path, 'r') as input_file:
        lines  =  input_file.readlines()
    format_lines  = []
    for index, line in enumerate(lines):
        formatted  =  format_line(line.strip(), 5, 0, 3, 0)
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

#CSR_OUTPUT_FIELD_ARRAY
    with open(input_field_path, 'r') as input_file:
        lines  =  input_file.readlines()
    format_lines  = []
    for index, line in enumerate(lines):
        formatted  =  format_line(line.strip(), 6, 0, 3, 1)
        if formatted:
            format_lines.append(formatted)
            
    #new_element  =  "            csr_na_s_w  csr_na_s_w_temp; \\"
    #format_lines.insert(0, new_element)

    with open(svh_file_path, 'r') as csr_file:
        csr_content  =  csr_file.readlines()

    start_marker = "`define CSR_OUTPUT_FIELD_ARRAY_INIT \\"
    end_marker = "//end_CSR_OUTPUT_FIELD_ARRAY_INIT<<\\"

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
        print("csr.svh can not found the marker")

#svh add the reserved addr read
    format_lines  =  []
    format_adr  =  []
    with open(input_reserved_path, 'r') as input_file:
        lines  = input_file.readlines()
        for index, line in enumerate(lines):
            cleaned_addr  = line.strip().replace("0x", "").replace("_", "")
            format_adr.append(cleaned_addr)

    for i, line in enumerate(format_adr):
        key =  f"            `uvm_do_on_with(axi4l_rd_seq, p_sequencer.axi_sqr,{{axi4l_rd_seq.address == 40'h{line};}}) \\\n"
        format_lines.append(key)

    with open(svh_file_path, 'r') as csr_file:
        csr_content  =  csr_file.readlines()
    start_marker = "`define RESERVED_READ\\"
    end_marker = "//end_RESERVED_READ<<"

    start_index = None
    end_index = None

    for i, line in enumerate(csr_content):
        if start_marker in line:
            start_index  =  i
        elif end_marker in line:
            end_index  = i
            break

    if start_index is not None and end_index is not None:
        new_content  = (
            csr_content[:start_index + 1] + 
            format_lines+ 
             ['\n'] +
            csr_content[end_index:]
        )
        with open(svh_file_path, 'w') as csr_file:
            csr_file.writelines(new_content)

        print(f" csr.svh replace the content between {start_marker} and {end_marker} ")
    else:
        print("csr.svh can not found the marker")
if __name__  == "__main__":
    update_svh()
    print('finish the update_svh.py')
        
