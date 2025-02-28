#!/usr/bin/python3
# File name : get_ovalue.py
# Author      : donghao lv (Full Name Please)
# Created     : Fri 20 Sep 2024 07:33:12 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
import re

def extract_and_match(ral_pkg_path, pe_csr_path, output_path):
    # 
    #with open(ral_pkg_path, 'r') as f:
    #    ral_lines = [line.split()[1] for line in f.readlines()]

    with open(ral_pkg_path, 'r') as file:
        lines = file.readlines()
        second_strings = [line.split(',   ')[1].strip() for line in lines]
        #print(second_strings)
    # 
    with open(pe_csr_path, 'r') as f:
        lines = f.readlines()

    value_map = {}

    for second_string in second_strings:
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
                            value_map[second_string]  =  o_value
                            #print(o_value)
                            break
                if o_value:
                    break

                        


    # 
    with open(output_path, 'w') as f:
        for reg_temp, reg_temp_temp in value_map.items():
            f.write(f"{reg_temp}         {reg_temp_temp}\n")

# 
input_file = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/de/core/cluster/pe/csr/pe_csr/pe_csr.sv'
ral_file = 'ral_pkg.dat'
output_file  = 'ral_output.dat'

extract_and_match(ral_file, input_file, output_file)
