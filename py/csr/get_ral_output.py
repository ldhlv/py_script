#!/usr/bin/python3
# File name : get_ral_output.py
# Author      : donghao lv (Full Name Please)
# Created     : Fri 20 Sep 2024 03:24:20 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
import re
import sys
import string

def find_string_and_match(file_path, search_string):
    print(search_string)
    with open(file_path, 'r') as file:
        lines = file.readlines()

    o_value_line = None
    i_din_line = None
    o_dout_line = None
    output   = None

    # 
    for idx, line in enumerate(lines):
        words  = line.strip()
        words_list = re.findall(r'\w+', words)
        if (line.startswith('.i_din({') or line.startswith(' ')) and search_string in words_list:
        #if search_string in words:
            #print(line)
            o_value_line = idx
            #  .i_din({
            for check_idx in range(idx, -1, -1):
                words  = lines[check_idx].strip();
                if '(' in words.split():
                    print('(')
                    break
                if '.i_din({' in lines[check_idx]:
                    i_din_line = check_idx
                    print('({')
                    break
            
            if i_din_line is not None:
                # 
                lines_between = o_value_line - i_din_line
                print(f"{search_string} found at line {o_value_line + 1}, "
                      f"it is {lines_between} lines from .i_din{{}} (line {i_din_line + 1})")

                # 
                for check_idx in range(o_value_line, len(lines)):
                    if '.i_din({' in lines[check_idx]:
                        print('(')
                        break
                    if '.o_dout({' in lines[check_idx]:
                        o_dout_line = check_idx
                        break
                
                if o_dout_line is not None:
                    # .o_dout({
                    target_line_index = o_dout_line + lines_between
                    if target_line_index < len(lines):
                        output  =  lines[target_line_index].split()[0]
                        output  =  output.rstrip(string.punctuation)
                        #output  = re.findall(r'\w+',output)
                        print(output)
                        #print(f".o_dout found at line {o_dout_line + 1}, "
                        #      f"the string at line {target_line_index + 1} is: {lines[target_line_index].strip(0)}")

            #break

    if o_value_line is None:
        print(f"{search_string} not found.")
    
    return output

def get_ral_output():
    # 
    input_file = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/de/core/cluster/pe/csr/pe_csr/pe_csr_ral_pkg.sv'
    output_file = 'ral_pkg.dat'
    
    # 
    extracted_data = []
    
    # 
    #pattern = r'rggen_ral_create_reg\s*\(\s*([^,\s]+)'
    pattern = r'rggen_ral_create_reg\s*\(\s*([^,\s]+)[^)]*["\']([^"\']+)\.u_register["\']'
    # 
    with open(input_file, 'r') as file:
        for line in file:
            # 
            match = re.search(pattern, line)
            if match:
                first_string = match.group(1)
                last_string = match.group(2)
                extracted_data.append((first_string, last_string))
    
    # 
    with open(output_file, 'w') as file:
        for first, last in extracted_data:
            file.write(f'{first} ,     {last}\n')
    
    print(f'get the reg to {output_file}')
    
    
    ral_pkg_file = 'ral_pkg.dat'
    ral_output_file = 'ral_output.dat'
    pe_csr_file = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/de/core/cluster/pe/csr/pe_csr/pe_csr.sv'
    pe_reg_wrapper_file = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/de/core/cluster/pe/csr/pe_csr/pe_reg_wrapper.sv'
    
    # get the second_string of ral_pkg
    with open(ral_pkg_file, 'r') as file:
        lines = file.readlines()
        second_strings = [line.split(',   ')[1].strip() for line in lines]
        frist_strings = [line.split(',   ')[0].strip() for line in lines]
    
    #for second_string in second_strings:
    #     print(second_string)
    
    # store the results
    results = []
    
    # find in pe_csr.sv 
    with open(pe_csr_file, 'r') as file:
        lines = file.readlines()
        for first_string, second_string in zip(frist_strings, second_strings):
            in_generate_block = False
            o_value = None
            
            for i, line in enumerate(lines):
                if f'generate if (1) begin' in line and second_string in line:
                    in_generate_block = True
                    for j in range(i + 1, len(lines)):
                        if 'generate if (1)' in lines[j]:
                            break
                        if '.o_value' in lines[j]:
                            match = re.search(r'\(\s*([^,\s]+)\s*\)', lines[j])
                            if match:
                                o_value = match.group(1)
                                #print(o_value)
                                break
                    if o_value:
                        break
            
            if o_value:
                with open(pe_reg_wrapper_file, 'r') as reg_file:
                    reg_lines = reg_file.readlines()
                    for i, line in enumerate(reg_lines):
                        if o_value in line:
                            match  = re.search(r'\(\s*([^,\s]+)\s*\)', line)
                            if match:
                                extracted_value = match.group(1)  # 
                                #print(f"Found: {extracted_value} at line {i}")
                                #print(extracted_value)
                # find o_value in pe_reg_wrapper.sv
                                output = find_string_and_match(pe_reg_wrapper_file, extracted_value)
                                results.append(f'{first_string}     {second_string}    {o_value}   {extracted_value}   {output}')
    
    with open(ral_output_file, 'w') as file:
        for i, line in enumerate(lines):
            if i < len(results):
                file.write(results[i] + '\n')
            #else:
            #    file.write(line)
    
    print(f'has write to the {ral_output_file}')

if __name__  == "__main__":
    log_file  =  open('log.txt', 'w')
    sys.stdout  =  log_file
    get_ral_output()
    log_file.close()
    sys.stdout  = sys.__stdout__
    print('finish the get_ral_output.py')
    
