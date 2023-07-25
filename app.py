import oloren as olo
import sys
import io
import os
import subprocess
import shutil
import time

@olo.register()
def hello():
    return "Hello World!"

# ./scripts/run_inference.py 'contigmap.contigs=[150-150]' inference.output_prefix=test_outputs/test inference.num_designs=10
@olo.register()
def unconditional_monomer():
    cwd = os.getcwd()
    
    # Run the subprocess
    process = subprocess.Popen(['python3.9', '/RFdiffusion/scripts/run_inference.py', 'contigmap.contigs=[150-150]', f"inference.output_prefix={os.path.join(cwd, 'output')}", 'inference.num_designs=10', 'inference.model_directory_path=/root/models', 'inference.input_pdb=/RFdiffusion/examples/input_pdbs/1qys.pdb'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    while True:
        output = process.stdout.readline()
        if output == b'' and process.poll() is not None:
            break
        if output:
            print(f"stdout: {output.strip().decode('utf-8')}")
        
        error = process.stderr.readline()
        if error:
            print(f"stderr: {error.strip().decode('utf-8')}")

    # Ensure any remaining outputs are printed out
    rc = process.poll()
    if rc is not None:
        for output in process.stdout.readlines():
            print(f"stdout: {output.strip().decode('utf-8')}")
        for error in process.stderr.readlines():
            print(f"stderr: {error.strip().decode('utf-8')}")

    # Zip the output directory
    shutil.make_archive('output_archive', 'zip', os.path.join(cwd, 'output'))

    # Return the path to the zipped file
    return olo.OutputFile('output_archive.zip')

if __name__ == "__main__":
    olo.run("rfdiffusion", port=80)