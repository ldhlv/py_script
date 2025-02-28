#!/usr/bin/python3
# File name : update_drv.py
# Author      : donghao lv (Full Name Please)
# Created     : Fri 20 Sep 2024 11:23:21 AM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
import re

# the file path
input_bit_name_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/py/signal_bit_name.dat'
output_drv_path  =  '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/uvcs/csr_engine_uvc/csr_engine_drvr.sv'

# 
with open(input_bit_name_path, 'r') as csr_file:
    csr_lines = csr_file.readlines()

i_prefix_items_with_comments = {
    match: line.startswith('//')
    for line in csr_lines
    for match in re.findall(r'\bi_[\w]+\b', line)
}

# 
with open(output_drv_path, 'r') as drv_file:
    drv_lines = drv_file.readlines()

updated_drv_lines = []
missing_items = set(i_prefix_items_with_comments.keys())  #

for drv_line in drv_lines:
    updated_line = drv_line
    for item in list(missing_items):
        if item in drv_line:
            # 
            if i_prefix_items_with_comments[item] and not drv_line.strip().startswith('//'):
                updated_line = f'// {drv_line}'  # ¸
            missing_items.remove(item)  # 
    updated_drv_lines.append(updated_line)

# 
for item in missing_items:
    # 

    similar_line_index = next((i for i, line in enumerate(drv_lines) if 'i_' in line), None)
    if similar_line_index is not None:
        new_line = re.sub(r'\bi_[\w]+\b', item, drv_lines[similar_line_index].strip())
        updated_drv_lines.insert(similar_line_index + 1, f'  {new_line}\n')
#
with open('drv_updated.sv', 'w') as updated_drv_file:
    updated_drv_file.writelines(updated_drv_lines)

with open(output_drv_path, 'w') as updated_drv_file:
    updated_drv_file.writelines(updated_drv_lines)

print('finish the update_drv.py')
