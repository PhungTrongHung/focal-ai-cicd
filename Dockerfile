FROM python:3.10-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

COPY requirements.txt /app/requirements.txt

# Install CPU versions of PyTorch
RUN python -m pip install --upgrade pip && \
    pip install \
      torch==2.0.1 \
      torchvision==0.15.2 \
      torchaudio==2.0.2 \
      --index-url https://download.pytorch.org/whl/cpu

# Remove GPU-specific packages from original requirements
RUN python -c "from pathlib import Path; p=Path('/app/requirements.txt'); excluded=('nvidia-', 'torch==', 'torchvision==', 'torchaudio==', 'triton==', 'lit==', 'cmake=='); lines=p.read_text().splitlines(); Path('/app/requirements-cpu.txt').write_text('\n'.join(x for x in lines if not x.lower().startswith(excluded))+'\n')"

RUN pip install -r /app/requirements-cpu.txt

COPY src/ /app/src/

WORKDIR /app/src

CMD ["python", "train.py", "--help"]