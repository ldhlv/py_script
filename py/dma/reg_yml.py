import pandas as pd
import yaml
from yaml.representer import SafeRepresenter

# 自定义HexInt类型用于十六进制格式输出
class HexInt(int):
    pass

def hexint_representer(dumper, data):
    return dumper.represent_scalar('tag:yaml.org,2002:int', '0x{:x}'.format(data))

yaml.add_representer(HexInt, hexint_representer)

# 处理YAML输出的缩进和格式
def setup_yaml_format():
    SafeRepresenter.add_representer(
        HexInt, hexint_representer)

setup_yaml_format()

# 读取Excel文件并处理空值
df = pd.read_excel('dma_reg.xlsx', dtype=str)
df['register_blocks_name'] = df['register_blocks_name'].ffill()
df['regs_num'] = df['regs_num'].ffill()
df['chl'] = df['chl'].ffill()
df['registers_name'] = df['registers_name'].ffill()
df['offset_address'] = df['offset_address'].ffill()

register_blocks = []
byte_len = 8

# 处理每个register_block
for (block_name,regs_num,chl), block_df in df.groupby(['register_blocks_name','regs_num','chl']):
    current_block = {
        'name': block_name,
        'byte_size': 0,
        'registers': []
    }
    int_regs_num = int(regs_num)
    int_chl = int(chl) 
    max_offset = 0
    for regs_idx in range(int_regs_num):
        for chl_idx in range(int_chl):
            # 处理每个register
            for (reg_name, reg_offset), reg_group in block_df.groupby(['registers_name', 'offset_address']):
                try:
                    if reg_offset.startswith('0x'):
                        reg_offset_val = int(reg_offset,16)
                    else:
                        reg_offset_val = int(reg_offset)
                except ValueError:
                    reg_offset_val = reg_offset
                reg_offset_adr = (chl_idx<<7)|(reg_offset_val&0x7F)
                #set the max size
                offset = reg_offset_adr
                if offset > max_offset:
                    max_offset = offset
                current_reg = {
                    'name': f"{reg_name}_csr{regs_idx}_{chl_idx}",
                    'offset_address': hex(reg_offset_adr),
                    'bit_fields': []
                }
                
                # 处理每个bit_field
                for _, row in reg_group.iterrows():
                    # 处理initial_value格式
                    initial_value_str = row['initial_value']
                    try:
                        if initial_value_str.startswith('0x'):
                            int_val = int(initial_value_str, 16)
                            initial_value = HexInt(int_val)
                        else:
                            initial_value = int(initial_value_str)
                    except ValueError:
                        initial_value = initial_value_str
                    
                    bit_field = {
                        'name': row['bit_fields_name'],
                        'bit_assignment': {
                            'lsb': int(row['lsb']),
                            'width': int(row['width'])
                        },
                        'type': row['type'],
                        'initial_value': initial_value
                    }
                    current_reg['bit_fields'].append(bit_field)
                
                current_block['registers'].append(current_reg)
        
    # 计算byte_size（最大offset + 8字节）//TODO
    current_block['byte_size'] = max_offset + byte_len
    
    register_blocks.append(current_block)

# 构建YAML数据并写入文件
with open('dma_reg.yml', 'w') as f:
    yaml.dump(
        {'register_blocks': register_blocks},
        f,
        sort_keys=False,
        default_flow_style=None,
        allow_unicode=True,
        indent=2
    )
    print(register_blocks)