import os

def count_lines_in_files(directory, extensions):
    total_lines = 0
    for root, _, files in os.walk(directory):
        for file in files:
            if any(file.endswith(ext) for ext in extensions):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    total_lines += len(f.readlines())
    return total_lines

if __name__ == "__main__":
    target_directory = "D:\FauxrjePGA\Le-FauxrjePGA-CPU\src"  # Replace this with your directory path
    file_extensions = ['.v', '.vh']
    
    total_lines = count_lines_in_files(target_directory, file_extensions)
    
    print(f"Total lines in {', '.join(file_extensions)} files: {total_lines}")
