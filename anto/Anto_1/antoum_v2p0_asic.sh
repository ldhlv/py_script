#DV_COMMON,luo add23.11.2
#export DV_COMMON=/home/ex_meipengzhe/ex_share/DV_COMMON
export DV_COMMON=/projects/antoum_v15MP/ASIC/DV_COMMON
source $DV_COMMON/dv_common.bash
#SYNOPSYS license
export SCL_HOME=$SYNOPSYS/scl_2016.12
export PATH=$SCL_HOME/linux64/bin:$PATH
export SNPSLMD_LICENSE_FILE=27001@192.168.1.51:27001@10.1.20.59
#27020@10.1.20.52
export LM_LICENSE_FILE=27001@192.168.1.51:27001@10.1.20.59:30000@10.1.20.52
#27020@10.1.20.52
export VCS_ARCH_OVERRIDE=linux
export VCS_TARGET_ARCH=amd64

#synopsys
export SYNOPSYS=/tools/eda
#vcs
export VCS_HOME=$SYNOPSYS/vcs_L-2016.06-SP2-12
#dve
export DVE_HOME=$VCS_HOME/gui/dve
export PATH=$DVE_HOME/bin:$VCS_HOME/bin:$PATH
#verdi
export VERDI_HOME=$SYNOPSYS/verdi3_L-2016.06-SP2-12
export NOVAS_HOME=$SYNOPSYS/verdi3_L-2016.06-SP2-12
export FSDB_HOME=$VERDI_HOME/share/PLI/VCS/LINUX64
export PATH=$VERDI_HOME/bin:$VERDI_HOME/platform/LINUX64/bin:$PATH
#DC
##export DC_HOME=/tools/eda/dc2016-L-2016.03-SP1
##export PATH=$DC_HOME/bin:$PATH
export DC_HOME="/tools/eda/synopsys/syn/O-2018.06-SP5-4"
export PATH="${PATH}:$DC_HOME/bin"
#spyglass
export SPYGLASS_HOME=/tools/eda/spyglass201606/tool/eda/SpyGlass_2016.06/SpyGlass-L2016.06/SPYGLASS_HOME/
export PATH=$SPYGLASS_HOME/bin:$PATH
#reggen
export GEM_PATH=/tools/eda/rggen
#coreConsultant
export PATH=/tools/eda/coretools/coretools/S-2021.09-SP4-1/bin:$PATH
#lpddr5 
export DESIGNWARE_HOME=/projects/antoum_v15MP/ASIC/snps_ip/snps_dw
export PATH=$DESIGNWARE_HOME/bin:$PATH
#vc static platform, ruofan add 2024/04/19
export VC_STATIC_HOME=/tools/eda/scl_2022data/vc-static_T-2022.06-SP2-7
export PATH=$VC_STATIC_HOME/bin:$PATH
########################################################
#antoum_v2p0_asic project 
########################################################
#export ANTOM_DIR=$(dirname $(readlink -f "$0"))
#export PROJ_ROOT=$(dirname $(readlink -f "$0"))
export PROJ_ROOT=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
export PROJ_FE_DV=$PROJ_ROOT/fe/dv
export PROJ_FE_DE=$PROJ_ROOT/fe/de
export PROJ_SCRIPT=$PROJ_FE_DV/script
export CMODEL_DIR=$PROJ_ROOT/../antoumv2.0_clib


alias vrf="cd $PROJ_ROOT/fe/dv"
alias dv_run="/usr/bin/python  $PROJ_SCRIPT/dv_run"
alias run_sim="/usr/bin/python3 $PROJ_SCRIPT/run_sim"
alias guvm="/usr/bin/python3   $PROJ_SCRIPT/guvm"
alias find_error="/usr/bin/python $PROJ_SCRIPT/find_error"
alias mk_pend_list="/usr/bin/python $PROJ_SCRIPT/mk_pend_list"
alias summary_run="/usr/bin/python3 $PROJ_SCRIPT/summary_run.py"

echo $PROJ_ROOT

export PATH=/usr/bin:$PATH
#luo add for encoded engines
export ENGS_SRC_DIR=$PROJ_ROOT/../antoum2.0_engines_git_asic
export ENGS_ENC_DIR=$PROJ_ROOT/../ex_git_engines_ex

#for cl nn rvv
export RISCV_PATH=$PROJ_ROOT/fe/dv/script/cl_nn_rvv/riscv-toolchain
#export LD_LIBRARY_PATH=$VCS_HOME/linux64
alias dv_run_cn="/usr/bin/python  $PROJ_SCRIPT/dv_run_cn"
alias dv_run_cp="/usr/bin/python  $PROJ_SCRIPT/dv_run_cp"
