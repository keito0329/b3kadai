FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# uvのインストール
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1

WORKDIR /app

# uvが作る仮想環境をデフォルトの実行環境にする
ENV PATH="/app/.venv/bin:${PATH}"

# PyTorch Geometricの依存関係にはコンパイルが必要なものがあるため、
# 必要なビルドツールをインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# uvで依存関係を同期
# --no-dev は開発用ツールを除外する場合
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project

COPY . .
