import re
import sys

def generate_blocks(content, copies):
    pattern = r'//\*\*DMA_CSR0_REG\*\*//(.*?)//\*\*DMA_CSR0_REG_END\*\*//'
    blocks = []
    found = False
    
    for match in re.finditer(pattern, content, re.DOTALL):
        found = True
        original_block = match.group(1).strip()
        for i in range(copies):
            # 动态生成替换模式，匹配任意前缀的csr0_数字结尾的变量名
            modified_block = re.sub(
                r'\b(\w+?)(csr0)(_\d+)\b(?=\s*;)',  # 只匹配变量名部分
                f'\\1csr{i}\\3', 
                original_block
            )
            blocks.append(f"//**DMA_CSR{i}_REG**//\n{modified_block}\n//**DMA_CSR{i}_REG_END**//")
        break
        if not found:
            print("[Warning] not found the //**DMA_CSR0_REG**//or//**DMA_CSR0_REG_END**//")
    
    return '\n\n'.join(blocks)

def generate_regbuilds(content, copies):
    pattern = r'//\*\*DMA_CSR0_build\*\*//(.*?)//\*\*DMA_CSR0_build_end\*\*//'
    blocks = []
    found = False
    
    for match in re.finditer(pattern, content, re.DOTALL):
        found = True
        original_block = match.group(1).strip()
        for i in range(copies):
            # 动态生成替换模式，匹配任意前缀的csr0_数字结尾的变量名
            modified_block = re.sub(
                r'\b(\w+?)(csr0)(_\d+)\b(?=\s*,)',  # 只匹配变量名部分
                f'\\1csr{i}\\3', 
                original_block
            )
            blocks.append(f"//**DMA_CSR{i}_build**//\n{modified_block}\n//**DMA_CSR{i}_REG_build_end**//")
        break
        if not found:
            print("[Warning] not found the //**DMA_CSR0_build**//or//**DMA_CSR0_build_end**//")
    
    return '\n\n'.join(blocks)

def process_file(filename, copies):
    try:
        with open(filename, 'r+', encoding='utf-8') as f:
            content = f.read()
            new_content = re.sub(
                r'//\*\*DMA_CSR0_REG\*\*//.*?//\*\*DMA_CSR0_REG_END\*\*//',
                lambda m: generate_blocks(m.group(), copies),
                content,
                count=1,
                flags=re.DOTALL
            )
            new_content1 = re.sub(
                r'//\*\*DMA_CSR0_build\*\*//.*?//\*\*DMA_CSR0_build_end\*\*//',
                lambda m: generate_regbuilds(m.group(), copies),
                new_content,
                count=1,
                flags=re.DOTALL
            )
            
            if new_content1 != new_content:
                f.seek(0)
                f.write(new_content1)
                f.truncate()
                print(f"[Success] writen to: {filename}")
            else:
                print("[Info] the content of file not modify")
                
            print("****finish****")
    except FileNotFoundError:
        print(f"[Error] the file not found: {filename}")
    except Exception as e:
        print(f"[Error] process fail: {str(e)}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <filename> <copies>")
        sys.exit(1)
    
    process_file(sys.argv[1], int(sys.argv[2]))
