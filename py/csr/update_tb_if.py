#!/usr/bin/python3
# File name : update_tb_if.py
# Author      : donghao lv (Full Name Please)
# Created     : Thu 19 Sep 2024 07:46:59 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
import re

# the file path
input_file_path = 'signal_rtl.dat'  
#testbench_file_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/top/testbench1.sv'
testbench_file_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/top/testbench.sv'
#io_file_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/uvcs/csr_engine_uvc/csr_engine_io1.sv'
io_file_path = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/uvcs/csr_engine_uvc/csr_engine_io.sv'
input_file_bit_name_path = 'signal_bit_name.dat' 

# read the input file
with open(input_file_path, 'r') as input_file:
    lines = input_file.readlines()

#change the string
formatted_lines = []
for index, line in enumerate(lines):
    stripped_line = line.strip()
    if stripped_line.startswith('//'):
        formatted_line = f'//.{stripped_line[2:]}          (csr_engine.{stripped_line[2:]}),\n'
    else:
        formatted_line = f'    .{stripped_line}                (csr_engine.{stripped_line}),\n'
    if index == len(lines) - 1:
        formatted_line = formatted_line.rstrip(',\n') + '\n'
    formatted_lines.append(formatted_line)

# read the content of file 
with open(testbench_file_path, 'r') as testbench_file:
    testbench_content = testbench_file.readlines()

# replace the line between >> and   <<    
start_marker = "//>>replace"
end_marker = "//replace<<"

# find the index
start_index = None
end_index = None

for i, line in enumerate(testbench_content):
    if start_marker in line:
        start_index = i
    elif end_marker in line:
        end_index = i
        break

if start_index is not None and end_index is not None:
    # save the start and end marker
    new_content = (
        testbench_content[:start_index + 1] + 
        formatted_lines + 
        testbench_content[end_index:]
    )
    
    # write back the file 
    with open(testbench_file_path, 'w') as testbench_file:
        testbench_file.writelines(new_content)

    print(f"replace the content between {start_marker} and {end_marker} ")
else:
    print("can not found the marker")
    
#io 
with open(input_file_bit_name_path, 'r') as input_file:
    lines = input_file.readlines()

#change the string
formatted_lines = []
for line in lines:
    stripped_line = line.strip()
    formatted_line = f'    {stripped_line};\n'
    formatted_lines.append(formatted_line)


with open(io_file_path, 'r') as io_file:
    io_content = io_file.readlines()

# replace the line between >> and   <<    
start_marker = "//>>replace"
end_marker = "//replace<<"

# find the index
start_index = None
end_index = None

for i, line in enumerate(io_content):
    if start_marker in line:
        start_index = i
    elif end_marker in line:
        end_index = i
        break

if start_index is not None and end_index is not None:
    # save the start and end marker
    new_content = (
        io_content[:start_index + 1] + 
        formatted_lines + 
        io_content[end_index:]
    )
    
    # write back the file 
    with open(io_file_path, 'w') as io_file:
        io_file.writelines(new_content)

    print(f" io replace the content between {start_marker} and {end_marker} ")
else:
    print("io can not found the marker")
    

with open(input_file_bit_name_path, 'r') as input_file:
    lines  =  input_file.readlines()

#change string 
new_lines  =  []
for line in lines:
    i_strings  =  []
    #if not line.strip().startswith('//'):
    for s in line.split():
        if not line.strip().startswith('//'):
            if s.startswith('i_'):
                i_strings.append(s)
        else:
            if s.startswith('i_'):
                i_strings.append(f'//{s}')


    for i_str in i_strings:
        if i_str.startswith('//'):
            new_lines.append(f'//      output    {i_str[2:]}    ;\n')
        else:
            new_lines.append(f'    output    {i_str}    ;\n')

with open(io_file_path, 'r') as io_file:
    io_content = io_file.readlines()

# replace the line between >> and   <<    
start_marker = "//>>replace_drv"
end_marker = "//replace_drv<<"

# find the index
start_index = None
end_index = None

for i, line in enumerate(io_content):
    if start_marker in line:
        start_index = i
    elif end_marker in line:
        end_index = i
        break

if start_index is not None and end_index is not None:
    # save the start and end marker
    new_content = (
        io_content[:start_index + 1] + 
        new_lines + 
        io_content[end_index:]
    )
    
    # write back the file 
    with open(io_file_path, 'w') as io_file:
        io_file.writelines(new_content)

    print(f" io drv replace the content between {start_marker} and {end_marker} ")
else:
    print("io drv can not found the marker")    


print('finish the update_tb_if.py')
