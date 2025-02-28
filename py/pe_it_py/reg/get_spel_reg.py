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

# File path
file_wrapper_path = "/projects/antoum2.0/donghaolv/workplace/tag95/antoum2.0_new_git_asic/fe/de/core/cluster/pe/csr/pe_csr/pe_reg_wrapper.sv"
file_csr_path = "/projects/antoum2.0/donghaolv/workplace/tag95/antoum2.0_new_git_asic/fe/de/core/cluster/pe/csr/pe_csr/pe_csr.sv"
output_path  = "reg_spel.txt"


# Function to find the g_ string above a specific line
def find_g_string(lines, start_index, keyword):
    for i in range(start_index-1, -1, -1):
        line = lines[i].strip()
        if keyword in line:
            match = re.search(r'g_\w+',line)
            if match:
                return match.group(0)[2:]
    return None

def get_spel_reg(access,str_key):
    # Dictionary to store results
    results = []
    
    # Regular expression to match input and output lines
    #input_output_pattern = re.compile(r'(input|output)\s+logic\s+(i_|o_)(\w+)\s+,')
    input_pattern = re.compile(r'input\s+logic\s+(i_\w+)\s+,')
    output_pattern = re.compile(r'output\s+logic\s+(o_\w+)\s+,')
    
    # Open and read the file
    with open(file_wrapper_path, 'r') as file:
        lines = file.readlines()
    
    # Flag to indicate whether to start extraction
    extracting = False
    
    current_inputs = []
    
    next_outputs = []
    
    # Process each line in the file
    for i, line in enumerate(lines):
        line = line.strip()
        # Check if we've reached the start comment
        #if line == "//******* rwc type csr if ********//":
        if line == str_key:
            extracting = True
            continue
        # Check if we've reached the end (two empty lines)
        #if extracting and line == "" and "" in lines[lines.index(line)+1:lines.index(line)+3]:
        #    break
        if extracting and i< len(lines) - 2 and lines[i+1].strip() == "":
            print(lines[i-1])
            break
        # If we are extracting and the line is not empty
        if extracting and line:
            #print(f"the extracting is true")
            # Find matches using regular expression
            #matches = input_output_pattern.findall(line)
            inputs = input_pattern.findall(line)
            if inputs:
                current_inputs = inputs
            outputs = output_pattern.findall(line)
            if outputs:
                next_outputs = outputs
                if current_inputs and next_outputs:
                    results.append({
                            'inputs': current_inputs,
                            'outputs': next_outputs
                        })
                    current_inputs = []
                    next_outputs = []
                else:
                    results.append({
                            'inputs': current_inputs,
                            'outputs': next_outputs
                        })
                    current_inputs = []                    
                    next_outputs = []
    
    # Print the results
    for result in results:
        print(f"Inputs: {result['inputs']}")
        print(f"Outputs: {result['outputs']}\n")
    
    # Open and read the csr file
    with open(file_csr_path, 'r') as file:
        lines_csr = file.readlines()
    
    
    
    # Process each output in the results
    for result in results:
        for output in result['outputs']:
            # Find the .o_value line for the current output
            for i, line_csr in enumerate(lines_csr):
                if (f".o_value" in line_csr or ".o_trigger" in line_csr) and output in line_csr:
                    # Find the g_ string above the first if (1) begin :
                    field = find_g_string(lines_csr, i, "if (1) begin :")
                    # Find the g_ string above the first generate if (1) begin :
                    reg = find_g_string(lines_csr, i, "generate if (1) begin :")
                    # Update the result with the found g_ strings
                    for r in results:
                        if output in r['outputs']:
                            r['field'] = field
                            r['reg'] = reg
                            break
    
    # Print the results
    for result in results:
        print(f"Inputs: {result['inputs']}")
        print(f"Outputs: {result['outputs']}")
        print(f"Field: {result.get('field')}")
        print(f"Reg: {result.get('reg')}\n")
    
    with open('reg_spel.txt', 'a') as output_file:
        for result in results:
            # Construct the string to be written to the file
            #inputs_str = ', '.join(result['inputs']) if result['inputs'] else ''
            #outputs_str = ', '.join(result['outputs']) if result['outputs'] else ''
            if len(result['inputs']) == 1:
                inputs_str = f"top.u_pe_top_wrapper.u_pe_top.u_pe_csr.{result['inputs'][0]}"
            elif result['inputs']:
                inputs_str = ', '.join(result['inputs'])
            else:
                inputs_str = ''

            if len(result['outputs']) == 1:
                outputs_str = f"top.u_pe_top_wrapper.u_pe_top.u_pe_csr.{result['outputs'][0]}"
            elif result['outputs']:
                outputs_str = ', '.join(result['outputs'])
            else:
                outputs_str = ''

            reg_str = result.get('reg', '')
            field_str = result.get('field', '')
            
            # Format the string according to the specified format
            output_line = f'reg_16steps_seq.set("{reg_str}","{field_str}","{access}","{inputs_str}","{outputs_str}");\n'
            
            # Write the string to the file
            output_file.write(output_line)
    
    # Print a message to indicate the file has been written
    print('The results have been written to reg_spl.txt')


get_spel_reg("RWC","//******* rwc type csr if ********//")
get_spel_reg("W1C","//******* w1c type csr if ********//")
get_spel_reg("W1TRG","//******* w1trg type csr if ********//")