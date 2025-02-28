#!/usr/bin/python3
# File name : analy_isa.py
# Author      : donghao lv (Full Name Please)
# Created     : Fri 03 Jan 2025 02:06:59 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
import sys
opcode_map = {
    '010110':'DCFG',
    '001100':'SND',
    '001101':'RCV',
    '001011':'CPY',
    '111111':'END',
    '010011':'SET',
    '001101':'RCV', 
    '001110':'LPS', 
    '001111':'LPSI', 
    '010000':'LPE'
}

#SET_fields = [
#    ("opcode",31-31,31-26),
#    ("r_dst",31-25,31-18),
#    ("offset",31-17,31-16),
#    ("imm",31-15,31-0)
#]
fields_dirct = {
    "SET_fields" : [
        ("OPCODE",31-31,31-26),
        ("r_dst",31-25,31-18),
        ("offset",31-17,31-16),
        ("imm",31-15,31-0)
    ],
    "CPY_fields":[
        ("OPCODE",31-31,31-26),
        ("SUR_IDX",31-25,31-23),
        ("LINE_IDX",31-22,31-20),
        ("LEN_IDX",31-19,31-19),
        ("LOW_PECISION",31-18,31-15),
        ("SRC_DYNAMIC",31-14,31-14),
        ("DST_DYNAMIC",31-13,31-13),
        ("BANK",31-12,31-11),
        ("DTYPE",31-10,31-8),
        ("EXREND_SQUENCE",31-7,31-7),
        ("VALID_LEN",31-6,31-3),
        ("FORMAT_CONVERT",31-2,31-2),
        ("R_CONVERT_STRIDE",31-1,31-1),
        ("RESERVED",31-0,31-0)


    ],
    "END_fields":[
        ("OPCODE",31-31,31-26)
    ], 
    "SND_fields":[
        ("OPCODE",31-31,31-26),
        ("SUR_IDX",31-25,31-23), 
        ("LINE_IDX",31-22,31-20), 
        ("LEN_IDX",31-19,31-19), 
        ("PE_ID", 31-6, 31-0)
    ], 
    "RCV_fields":[
        ("OPCODE",31-31,31-26), 
        ("R_LENGTH",31-25,31-25), 
        ("PE_ID",31-5,31-0)
    ], 
    "LPS_fields":[
        ("OPCODE",31-31,31-26), 
        ("LOOP_ID",31-25 ,31-23 ), 
        ("R_COUNT",31-22 ,31-20 ) 
    ], 
    "LPE_fields":[
        ("OPCODE",31-31,31-26), 
        ("LOOP_ID",31-25 ,31-23 )
            
    ], 
    "LPSI_fields":[
        ("OPCODE",31-31,31-26), 
        ("LOOP_ID",31-25 ,31-23 ), 
        ("COUNT",31-22 ,31-7 ) 
    ]
}
def hex_2_bin(hex_str,length=32):
    decimal_value = int(hex_str, 16)
    binary_str = bin(decimal_value)[2:].zfill(length)
    return binary_str

def binary_to_hex(binary_string):
    if not all(bit in '01' for bit in binary_string):
        raise ValueError("the string contain the not bin")
    
    decimal_value = int(binary_string, 2)  # 
    hex_string = hex(decimal_value)  # 
    
    # 
    return hex_string[2:].lower()


def decode_instruction(instruction):
    #
    instr_int = int(instruction,16)
    instruction_bin = format(instr_int, '032b')
    
    # 
    opcode_bin = instruction_bin[:6]  # 
    opcode = int(opcode_bin, 2)  #    
    #opcode_map = {
    #    '111110': 'STR',   # 111110 STR
    #    '111111': 'END',   # 111111  END
    #    '010011': 'SET',   # 010011SET
    #    '001011': 'COPY'  # 001011 COPY
    #}
    
    return opcode_map.get(opcode_bin, 'UNKNOWN')

# get the field
def parse_instruction(binary_str, field_specs):
    if field_specs in fields_dirct:
        fields = fields_dirct[field_specs]
        for index,item in enumerate(fields):
            if len(item) == 3:
                field_name,start,end = item
                field_value = binary_str[start:end+1]  # 
                print(f"{field_name}: the bin:{field_value},the hex:{binary_to_hex(field_value)},the dec:{int(field_value,2)} ;", end=" ")
                if index== len(fields) -1:
                    print("\n")
            else:
                print(f"skipping the invaild entry:{item}")

def add_underscores_to_numbers(line):
    line = line.strip()
    
    result = []
    result_divi = []
    
    for i in range(len(line), 0, -8):
        segment = line[max(i - 8, 0):i]
        #get the isa name
        isa_type = decode_instruction(segment)
        print(f"the isa:{segment} the type is  {isa_type}")
        segment_bin = hex_2_bin(segment,32)
        parse_instruction(segment_bin,f"{isa_type}_fields")
        if max(i - 8, 0)==0:
            result_divi.insert(0, segment)  # 
        else:
            result_divi.insert(0, f"_{segment}")  # 
    
    return ''.join(result_divi)

def process_file(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as infile:
        lines = infile.readlines()
    
    processed_lines = [add_underscores_to_numbers(line) for line in lines]
    
    with open(output_file, 'w', encoding='utf-8') as outfile:
        for processed_line in processed_lines:
            outfile.write(processed_line + '\n')  # 

# 
input_file = 'ch0.txt'
output_file = 'ch0_divi.txt'

#
runlog_file  = f"runlog_{input_file}"
with open(runlog_file,'w') as f:
    original_stdout = sys.stdout
    sys.stdout = f

    process_file(input_file, output_file)
    print(f"push the {output_file}")
