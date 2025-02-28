#!/usr/bin/python3
# File name : py_pkg.py
# Author      : donghao lv (Full Name Please)
# Created     : Mon 23 Sep 2024 10:16:03 AM CST
# Description :
# Notes       :
#-----------------------------------------------------------------------
# Copyright 2021 (c) Moffett
#-----------------------------------------------------------------------
import subprocess
extract_path  = '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/py/combined_extract.py'
get_output_path  =  '/projects/antoum2.0/donghaolv/workplace/antoum2.0_new_git_asic/fe/dv/verif/sys/csr_pe/env/py/get_ral_output.py'

scripts = [extract_path, get_output_path, "update_tb_if.py", "update_drv.py", "update_svh.py"]

for script in scripts:
    try:
        #
        result = subprocess.run(["python3", script], check=True)
        print(f"{script} executed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while executing {script}: {e}")
        break  # 
