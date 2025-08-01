FROM nvidia/cuda:12.9.0-runtime-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y htop wget curl mc git

RUN apt-get install -y python3.10 python3.10-venv python3.10-dev python3-pip pipx libgl1-mesa-glx nano

RUN pipx install nvitop

RUN git clone https://github.com/comfyanonymous/ComfyUI.git

RUN groupadd -g 1000 -o ai
RUN useradd -m -u 1000 -g ai -o -s /bin/bash ai
RUN chown -R ai:ai /ComfyUI

USER ai

WORKDIR ComfyUI

RUN python3.10 -m venv venv

RUN . venv/bin/activate && pip install --pre torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/cu129 onnxruntime-gpu numba diffusers

RUN . venv/bin/activate && pip install  opencv-contrib-python==4.8.1.78 opencv-python==4.8.1.78 opencv-python-headless==4.7.0.72

RUN . venv/bin/activate && pip install -r requirements.txt

CMD . venv/bin/activate && exec python main.py --listen 0.0.0.0
