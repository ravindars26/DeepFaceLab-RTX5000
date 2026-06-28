#!/bin/bash

echo "-------------------------------------------------------"
echo "Creating the DFL directory structure"
echo "-------------------------------------------------------"

# Move everything into place
DFL_DIR="other/_internal/DeepFaceLab"
mkdir "$DFL_DIR"
mkdir "$DFL_DIR/other"

# Move everything from main folder to other/_internal/DeepFaceLab
rsync -a --exclude="_internal/DeepFaceLab" other/ "$DFL_DIR/other"
rsync -q -av --remove-source-files --exclude="setup.sh" --exclude=other/ ./ "$DFL_DIR/"
find ./ -type d -empty -not -name keep_folder -delete

# Take everything out of the other dir
mv other/* .
rmdir other

# Add folders for app data
mkdir _internal/_e
mkdir _internal/_e/u

# Install CUDA
echo "-------------------------------------------------------"
echo "Installing CUDA and cuDNN"
echo "-------------------------------------------------------"
# Install cuDNN
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cudnn-cuda-12
rm cuda-keyring_1.1-1_all.deb

# Add CUDA to PATH
sudo chown $USER:$USER ~/.bashrc
echo 'export CUDA_HOME=/usr/local/cuda-12.8' >> ~/.bashrc
echo 'export DYLD_LIBRARY_PATH=$CUDA_HOME/lib64:$DYLD_LIBRARY_PATH' >> ~/.bashrc
echo 'export PATH=$CUDA_HOME/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export LD_RUN_PATH=$CUDA_HOME/lib64:$LD_RUN_PATH' >> ~/.bashrc
source ~/.bashrc

# Install Python 3.10
echo "-------------------------------------------------------"
echo "Installing Python with other requirements"
echo "-------------------------------------------------------"
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.10 python3.10-venv python3.10-distutils -y

# Install other requirements
sudo apt install ffmpeg -y
sudo apt install libpulse-mainloop-glib0 -y

# Download XnView
echo "-------------------------------------------------------"
echo "Downloading XnView"
echo "-------------------------------------------------------"
curl -L "https://www.xnview.com/download.php?file=XnViewMP-linux-x64.deb" -o "XnViewMP-linux-x64.deb"
ar x "XnViewMP-linux-x64.deb"

mkdir _internal/XnView
DATA_ARCHIVE=$(ls data.tar.*)
tar -xf "$DATA_ARCHIVE" -C _internal/XnView/
rm "XnViewMP-linux-x64.deb" control.tar.* data.tar.* debian-binary

mv _internal/XnView/opt/XnView/* _internal/XnView
rm -rf _internal/XnView/usr
rm -rf _internal/XnView/opt

# Make virtual environment and install requirements
echo "-------------------------------------------------------"
echo "Creating virtual environment"
echo "-------------------------------------------------------"
cd _internal/DeepFaceLab
python3.10 -m venv venv

echo "-------------------------------------------------------"
echo "Installing requirements"
echo "-------------------------------------------------------"
./venv/bin/pip install --upgrade pip
./venv/bin/pip install --no-deps -r requirements.txt
cd ../../

# Download pretrain models and genericXseg
echo "-------------------------------------------------------"
echo "Downloading pretrain models and genericXseg"
echo "-------------------------------------------------------"
cd _internal/
wget https://github.com/deepartist/DeepFaceLab_Colab/releases/download/1.0.0/{genericXseg.zip,pretrain_FFHQ.zip,pretrain_Quick96.zip}

# Extract all zip files into the current directory (_internal)
unzip -o \*.zip
ls -l

# Clean up the zip files
rm genericXseg.zip pretrain_FFHQ.zip pretrain_Quick96.zip

# Return to root directory
cd ..

# Create workspace directory and its subfolders
echo "-------------------------------------------------------"
echo "Creating workspace directories"
echo "-------------------------------------------------------"
mkdir -p workspace
mkdir -p workspace/data_dst
mkdir -p workspace/data_src
mkdir -p workspace/model

# Move setup.sh to DFL_DIR
mv "setup.sh" "$DFL_DIR/"

echo "-------------------------------------------------------"
echo "FINISHED"
echo "EveryThing is loaded, just put data_src.mp4 and data_dst.mp4 file inside workspace folder and you are good to go...  "
