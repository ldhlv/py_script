#!/usr/bin/python3
# File name : add_isa_divi.py
# Author      : donghao lv (Full Name Please)
# Created     : Thu 02 Jan 2025 04:03:46 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
def add_underscores_to_numbers(line):
    line = line.strip()
    
    result = []
    
    for i in range(len(line), 0, -8):
        segment = line[max(i - 8, 0):i]
        
        if max(i - 8, 0)==0:
            result.insert(0, segment)  # 
        else:
            result.insert(0, f"_{segment}")  # 
    
    return ''.join(result)

def process_file(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as infile:
        lines = infile.readlines()
    
    processed_lines = [add_underscores_to_numbers(line) for line in lines]
    
    with open(output_file, 'w', encoding='utf-8') as outfile:
        for processed_line in processed_lines:
            outfile.write(processed_line + '\n')  # 


# 
input_file = 'add1000_len400_ch0.txt'
output_file = 'add1000_len400_ch0_divi.txt'

# 
process_file(input_file, output_file)

print(f"push the {output_file}")
