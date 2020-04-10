import subprocess

def run(command:str):
    cmd = command.split()
    subprocess.run(cmd)
