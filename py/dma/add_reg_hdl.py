import re
import sys

def generate_blocks(content, copies,chl):
    pattern = r'//\*\*DMA_CSR0_0_addpath\*\*//(.*?)//\*\*DMA_CSR0_0_addpath_end\*\*//'
    blocks = []
    found = False
    for match in re.finditer(pattern, content,re.DOTALL):
        found = True  
        original_block =  match.group(1).strip()             
        for i in range(copies):
            for j in range(chl):
                modified_block = re.sub(
                    r'\b(\w+?)(csr)(\d+)(_)(\d+)\b',  # 只匹配变量名部分
                    f'\\1csr{i}_{j}', 
                    original_block
                )
                counter = [0]  # 使用闭包保持计数器状态
                def replace_index(match):
                    counter[0] += 1
                    return f"[{i if counter[0]%2 else j}]"
                
                modified_block = re.sub(
                    r'GEN_CH_REG\[0\]', 
                    f"GEN_CH_REG[{i}]", 
                    modified_block, 
                    count=0  
                )
                modified_block = re.sub(
                    r'GEN_CH_REG_ID\[0\]', 
                    f'GEN_CH_REG_ID[{j}]', 
                    modified_block, 
                    count=0  
                )
                blocks.append(f"//**DMA_CSR{i}_{j}_addpath**//\n{modified_block}\n//**DMA_CSR{i}_{j}_addpath_end**//")
        break
        if not found:
            print("[Warning] not found the //**DMA_CSR0_addpath**//or//**DMA_CSR0_addpath_end**//")
    
    return '\n\n'.join(blocks)



def process_file(filename,file_outname, copies,chl):
    try:
        with open(filename, 'r+', encoding='utf-8') as f,open(file_outname, 'w') as outfile:
            content = f.read()
            new_content = re.sub(
                r'//\*\*DMA_CSR0_0_addpath\*\*//.*?//\*\*DMA_CSR0_0_addpath_end\*\*//',
                lambda m: generate_blocks(m.group(), copies,chl),
                content,
                count=1,
                flags=re.DOTALL
            )
            
            if new_content != content:
                outfile.write(new_content)
                print(f"[Success] writen to: {file_outname}")
            else:
                print("[Info] the content of file not modify")
                
            print("****finish****")
    except FileNotFoundError:
        print(f"[Error] the file not found: {filename}")
    except Exception as e:
        print(f"[Error] process fail: {str(e)}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py <filename> <copies> <chl>")
        sys.exit(1)
    
    process_file(sys.argv[1],"dma_reg_ral_pkg_new1.sv", int(sys.argv[2]),int(sys.argv[3]))
