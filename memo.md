# Graph-RSs-Reproducibility 実行手順メモ

## 1. リポジトリをクローン

git clone https://hogehoge

## 2. lock ファイル更新（依存を変更したとき）

```bash
uv lock
```

## 3. Docker イメージ作成

```bash
DOCKER_BUILDKIT=1 docker build --no-cache -t graph-recsys:cu113-dev .
```

## 4. コンテナ起動（開発向け: ホストをマウント）

```bash
docker run -it --gpus all -v "$(pwd):/app" -w /app graph-recsys:cu113-dev bash
```

## 5. コンテナ内で依存同期

```bash
uv sync --frozen
```

## 6. NGCF 実行（Gowalla）

```bash
CUBLAS_WORKSPACE_CONFIG=:4096:8 \
uv run python -u start_experiments.py --dataset gowalla --model ngcf
```

## 7. 別データセットで実行する場合

```bash
CUBLAS_WORKSPACE_CONFIG=:4096:8 \
uv run python -u start_experiments.py --dataset yelp-2018 --model ngcf
```

```bash
CUBLAS_WORKSPACE_CONFIG=:4096:8 \
uv run python -u start_experiments.py --dataset amazon-book --model ngcf
```

## 8. よくあるエラーと対処

- `ModuleNotFoundError: No module named 'numpy'`
  - `uv sync --frozen` を実行してから `uv run python ...` で起動する。
- `No module named 'sparsesvd'`
  - `external/models/__init__.py` の GFCF import を optional にした最新版コードで実行する（古いイメージを使わない）。
- `Deterministic behavior ... CUBLAS_WORKSPACE_CONFIG`
  - 上記の通り `CUBLAS_WORKSPACE_CONFIG=:4096:8` を付けて起動する。

## 9. コンテナから出る

```bash
exit
```
