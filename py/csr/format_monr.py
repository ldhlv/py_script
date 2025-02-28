#!/usr/bin/python3
# File name : format_monr.py
# Author      : donghao lv (Full Name Please)
# Created     : Wed 18 Sep 2024 03:34:27 PM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
# format_monr.py

def format_line(line):
    parts = line.split()
    
    if len(parts) < 3:
        return None
    
    third_string = parts[2]
    
    formatted_line = f"""
        while(1)begin
            @(bus.engine_vpu_mon);
            wait(bus.{third_string});
            mon_item.output_data <= bus.{third_string};
            mon_item.output_name = "{third_string}";
            $fwrite(fd,$sformatf("@%t:the mon output_name:%s, the data:%0h\\n",$time(),"{third_string}",bus.{third_string}));
        end
    """
    
    return formatted_line

def main():
    with open('1.txt', 'r') as infile, open('2.txt', 'w') as outfile:
        for line in infile:
            formatted = format_line(line.strip())
            if formatted:
                outfile.write(formatted + '\n')

if __name__ == "__main__":
    main()
