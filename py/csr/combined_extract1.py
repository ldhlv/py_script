#!/usr/bin/python3
# File name : combined_extract.py
# Author      : donghao lv (Full Name Please)
# Created     : Thu 19 Sep 2024 05:30:57 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
import re

def extract_nth_parentheses_content(content, n):
#Implement the method to find the signal in the csr brackets
    stack = []
    current_content = ""
    found_count = 0

    for char in content:
        if char == '(':
            stack.append(char)
            if len(stack) == 1:
                if found_count == n - 1:
                    current_content = ""
        elif char == ')':
            if stack:
                current_content += char
                stack.pop()
                if not stack:
                    if found_count == n - 1:
                        return current_content.strip()
                    found_count += 1
        elif stack:
            current_content += char

    return None

# set the index
n = 4  

def get_csr_output():
    # the file path
    input_file_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/de/core/cluster/pe/csr/pe_csr/pe_reg_wrapper.sv'
    output_csr_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/py/signal_csr.dat'
    output_rtl_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/py/signal_rtl.dat'
    output_bit_name_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/py/signal_bit_name.dat'
    
    # 
    with open(input_file_path, 'r') as input_file:
        content = input_file.read()
    
    # extract the n content 
    nth_content = extract_nth_parentheses_content(content, n)
    
    # write the result to the output_csr_path
    if nth_content:
        with open(output_csr_path, 'w') as output_csr_file:
            output_csr_file.write(nth_content + '\n')
        print(f"the {n} has saved for the second_content{output_csr_path}")
    else:
        print(f"not the {n}  enough brackets")
    
    extracted_items = []
    
    with open(output_csr_path, 'r') as input_file:
        content = input_file.read()
    
    # extract the string with o_ and i_
    for line in content.splitlines():
        #if not line.strip().startswith('//'):
        matches = re.findall(r'\b[o_i]_[\w]+\b', line)
        for match in matches:
            if line.strip().startswith('//'):
                extracted_items.append(f"//{match}")
            else:
                extracted_items.append(match)
    
    # the result output to the second file 
    with open(output_rtl_path, 'w') as output_rtl_file:
        for item in extracted_items:
            output_rtl_file.write(item + '\n')
    
    print(f"the string extracted has saved {output_rtl_path}")
    
    
    
    with open(output_csr_path, 'r') as input_file:
        lines = input_file.readlines()
    
    
    extracted_lines = []
    
    for line in lines:
        stripped_line = line.strip()
        #if not stripped_line.startswith('//'):  #
        matches = re.findall(r'(logic[^\s]*\s+[^;]*?)(o_\w+|i_\w+)', line)
        for match in matches:
           if line.strip().startswith('//'):
               extracted_lines.append(f"//{match[0].strip()}      {match[1].strip()}")
           else:
               extracted_lines.append(f"    {match[0].strip()}      {match[1].strip()}")           
    # the result output to the second file 
    with open(output_bit_name_path, 'w') as output_bit_name_file:
        for item in extracted_lines:
            #output_bit_name_file.write(' '.join(item) + '\n')
            output_bit_name_file.write(item + '\n')
    
    print(f"the string extracted has saved {output_bit_name_file}")

if __name__  == "__main__":
    get_csr_output()
