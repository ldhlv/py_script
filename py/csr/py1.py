#!/usr/bin/python3
# File name : py1.py
# Author      : donghao lv (Full Name Please)
# Created     : Wed 18 Sep 2024 02:47:08 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
# 
input_file = 'ral_pkg_temp1.sv'
output_file = 'output.txt'

# open the input
with open(input_file, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# open the output 
with open(output_file, 'w', encoding='utf-8') as f:
    for line in lines:
        line = line.strip()  # delete \n
        if line:  # 
            f.write(f"while (1) begin\n{line}\nend\n")

print("success change")
