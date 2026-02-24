FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

# uvのインストール
# COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# ENV UV_LINK_MODE=copy \
#     UV_COMPILE_BYTECODE=1
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# WORKDIR /app

# uvが作る仮想環境をデフォルトの実行環境にする
# ENV PATH="/app/.venv/bin:${PATH}"

# PyTorch Geometricの依存関係にはコンパイルが必要なものがあるため、
# 必要なビルドツールをインストール
RUN apt update && apt upgrade -y
RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    git \
    unzip \
    unrar \
    wget \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    vim \
