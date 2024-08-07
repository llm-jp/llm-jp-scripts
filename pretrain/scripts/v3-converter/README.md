# チェックポイント変換スクリプト

このスクリプトは、Megatron形式のチェックポイントをHugging Face形式に変換します。

## スペック
- 必要リソース: gpu 1ノード

## 実行方法

### 注意事項
このスクリプトを実行する前に、環境に適したインストーラを実験ディレクトリにインストールしてください (例: /data/experiments/{exp-id}/enviroment)。
以前のチェックポイントが保存されていることを確認してください (例: /data/experiments/{exp-id}/checkpoints/)。

### 実行手順

1. 実験ディレクトリに移動します：
    ```shell
    cd /data/experiments/{exp-id}
    ```

2. スクリプトを実行環境と同じディレクトリにコピーし、ログ出力フォルダを作成します：
    ```shell
    cp {this directory}/convert.sh .
    mkdir logs
    ```

3. スクリプトを実行します：
  - SLURMが入っているクラスタ
    ```shell
    sbatch --partition {partition} convert.sh SOURCE_DIR TARGET_DIR
    ```
  - そのほかのクラスタ
    ```shell
    bash convert.sh SOURCE_DIR TARGET_DIR > logs/convert.out 2> logs/convert.err


### パラメータ

- `SOURCE_DIR`: `iter_NNNNNNN`を含むMegatronチェックポイントディレクトリ
- `TARGET_DIR`: Hugging Face形式の出力ディレクトリ

### 例

```shell
sbatch convert.sh /data/experiments/{exp-id}/checkpoints/iter_0001000 /data/experiments/{exp-id}/hf_checkpoints/iter_0001000
```
