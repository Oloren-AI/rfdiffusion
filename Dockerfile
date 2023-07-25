FROM nvcr.io/nvidia/cuda:11.6.2-cudnn8-runtime-ubuntu20.04

RUN apt-get -q update \ 
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  git \
  python3.9 \
  python3-pip

RUN git clone https://github.com/RosettaCommons/RFdiffusion.git

WORKDIR /RFdiffusion/

RUN python3.9 -m pip install -q -U --no-cache-dir pip \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get clean \
  && pip install -q --no-cache-dir \
  dgl==1.0.2+cu116 -f https://data.dgl.ai/wheels/cu116/repo.html \
  torch==1.12.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116 \
  e3nn==0.3.3 \
  wandb==0.12.0 \
  pynvml==11.0.0 \
  git+https://github.com/NVIDIA/dllogger#egg=dllogger \
  decorator==5.1.0 \
  hydra-core==1.3.2 \
  pyrsistent==0.19.3

RUN pip install -q --no-cache-dir /RFdiffusion/env/SE3Transformer
RUN pip install --no-cache-dir /RFdiffusion --no-deps

RUN apt-get update && apt-get install -y wget
RUN bash /RFdiffusion/scripts/download_models.sh $HOME/models
  
ENV DGLBACKEND="pytorch"

RUN pip install oloren

COPY app.py .

CMD ["python3.9", "app.py"]