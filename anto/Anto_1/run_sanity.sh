source antoum_v2p0_asic.sh
source project_env_2023.sh
dv_run -l pe -m pe_it -f pe_sanity.list -cf tb_cfg|tee pe-sanity.log
dv_run -l sys -m single_core -cf tb_cfg -f sanity.lst|tee core-sanit_test.log
