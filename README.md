# DeepFaceLab-RTX5000
### Forked from https://github.com/iperov/DeepFaceLab
This fork also fixes some issues that might occur in the original repository.  
If you don't have any issues with the original DFL, you don't need to use this fork. See [changes and fixes](#new-features-and-fixes) section to see if this version might be of use to you.

## Installation
Tensorflow doesn't support Windows anymore, therefore you need to use WSL2 (Windows Subsystem for Linux) to run DeepFaceLab now.

The setup script is meant for a fresh WSL installation. It will install everything you need to run DeepFaceLab on new GPUs.
If you aren't familiar with WSL/Linux and don't know how to use a terminal, don't worry, visit the [how to use section](#how-to-use) for a brief guide.

### 1. Install WSL2 (Ubuntu 24.04)
1. Open PowerShell as Administrator and run the following command:
   ```powershell
   wsl --install -d Ubuntu-24.04
   ```
   If the command doesn't work, you might have it disabled in Windows features. Most YouTube tutorials will show you what to do.  
2. After installation, the Ubuntu app should appear in your search. Opening it will show a terminal and prompt you to create a new user.  

3. Open the Ubuntu app and run the following command to update the system:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
### 2. Install DeepFaceLab-RTX5000
Continuing in the Ubuntu terminal, run the following commands.
1. Clone this repository:
   ```bash
   git clone https://github.com/volnas10/DeepFaceLab-RTX5000.git
    ```
2. Navigate to the cloned repository and run the setup script:
   ```bash
   cd DeepFaceLab-RTX5000
   sudo chmod +x setup.sh
   ./setup.sh
   ```
3. The setup script will automatically do the following:
    - Recreate the original DFL folder structure
    - Install CUDA and cuDNN
    - Install Python 3.10
    - Download XnView
    - Install all required Python packages
   
### 3. (Optional) Manually copy needed files from the original DFL
1. If you plan on using the Generic XSeg masks, copy the
`DeepFaceLab_NVIDIA_RTX3000_series/_internal/model_generic_xseg` folder to the
`DeepFaceLab-RTX5000/_internal/` folder.

2. If you want to pretrain a model with the original dataset, copy
`DeepFaceLab_NVIDIA_RTX3000_series/_internal/pretrain_faces` folder to the
`DeepFaceLab-RTX5000/_internal/` folder.

3. If you use Quick96, copy the
`DeepFaceLab_NVIDIA_RTX3000_series/_internal/pretrain_Quick96` folder to the
`DeepFaceLab-RTX5000/_internal/` folder.

## Updating
You can check if there are any updates to this repository by using the update.sh script:
```bash
cd DeepFaceLab-RTX5000/_internal
sudo chmod +x update.sh
./update.sh
```
Since there haven't been any updates yet, the functionality of this script is not confirmed so you might need to download a newer update script in the future.  
This version uses [custom TensorFlow build](https://github.com/weyn9q/rtx5070tensorflow) since the official TensorFlow still doesn't support RTX 5000 GPUs. If I change it to the official build in the future, there is a high chance a fresh install of this repository will be required.


## How to use
Usage is basically the same as in the original DFL. But obviously you will be working in a Linux environment now.
1. You can move your dataset using Windows Explorer. The workspace folder will be located in:
    ```
    Linux/Ubuntu/home/your_username/DeepFaceLab-RTX5000/workspace
    ```
2. To run the scripts, double-clicking won't work. You need to run them from the terminal. Here are the commands you will use:
   ```bash
   # Change to the directory with scripts:
   cd DeepFaceLab-RTX5000
   # To show the list of all scripts:
   ls *.sh
   # To run a script, copy the full name of the one you want and run using 'source' like this:
   source '4) data_src faceset extract.sh'
   ```
4. If you need to force close the scripts for whatever reason, press `Ctrl + C` in the terminal.  
   If scripts refuse to end (you will see VRAM is still occupied), you can use `wsl --shutdown` command in PowerShell to restart entire WSL.

## Changes and fixes

**Note**: Around 70% GPU usage is completely normal. DFL has quite a lot of CPU overhead and the usage will jump between low and 100% while training.
Task manager then shows the average %, making it seem like the GPU is underutilized.

### Slow faceset extraction (low GPU usage)
Depending on the resolution, you might see low GPU usage. For this reason you can now create more than one GPU session.
The GPU sessions will split all available VRAM between them for every GPU. Try increasing the number in increments of 1 and monitor the speed.

### Manual face extractor
Scrolling now also zooms into the image. This is an opencv behavior that cannot be disabled. Use W/A keys to increase/decrease the square size.

### Random warp causes immediate model collapse
Larger models seem prone to this issue even in the original DFL.
When enabling random warp on a pretrained model, it instantly collapses even with gradient clipping.
For this reason gradient clipping now allows you to set a custom value. If you're experiencing model collapse, try this:
1. Turn on gradient clipping (set the value to 1) and run training
2. If the model still collapses, try a small value like 0.1 with a fresh model and run training
3. If training is stable for a few minutes, back up the model, increase the value to 0.2 and train again
4. If the model collapses again, restore backup and go back to lower values
5. Repeat the process of backing up the model and increasing the value until you can reach 1 again (tested with steps 0.1, 0.2, 0.5 and 1)

## Issues
Only SAEHD workflow has been tested. If you encounter errors, please copy everything from the terminal starting with the script you lunched and provide it in the issue.

### Training freezes or slows down when doing anything else on the PC
You might see iteration time go up if you're doing any other work on your PC.
Sometimes training might crash without any errors and WSL needs to be restarted.
If you encounter these issues **unplug monitor(s) from your GPU and use integrated graphics (if your PC has any) while training instead.**

If issues persist, try running ```nvidia-smi``` comand in Windows terminal.
The second table that appears will show all the processes using the GPU, try shutting them down to see if it helps.

### Small preview windows on high resolution monitors
I couldn't find a working solution for this. If you manage to enable high DPI scaling, please let me know how in the issues.
