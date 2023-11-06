# 参考サイト

https://lethediana.sakura.ne.jp/tech/archives/steps-ja/665/

https://github.com/ttnt-1013/FastAPIandSQLAlchemy

上記のサイトから不要部分を削除したものを利用する

## ディレクトリ構造
```
fastapi % tree
.
├── Dockerfile
├── README.md
├── api
│ ├── **pycache**
│ │ └── main.cpython-312.pyc
│ └── main.py
├── docker-compose.yml
└── requirements.txt
```


## Dockerfileでpythonのバージョン指定、リポジトリのアップデートなどの初期設定
```shell:Dockerfile
FROM python:latest
USER root

RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

RUN apt-get install -y vim less \
    && pip install --upgrade pip \
    && pip install --upgrade setuptools

COPY ./api /app
# pip で requirements.txt に指定されているパッケージを追加する
COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt
```

## docker-compose.ymlでコンテナ周りの環境を設定
```yml:docker-compose.yml
version: '3.9'
services:
  edgedb-api:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./api/:/app/
    command: uvicorn app.main:app --reload --workers 1 --host 0.0.0.0 --port 8000
    ports:
      - 8000:8000
```

## /api/main.pyでlocalhost:8000で表示する内容を定義
```python:/api/main.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}
```

## requirements.txtでpipでインストールライブラリを指定する
```txt:requirements.txt
# 便利ツール
# pip-review
# tqdm
# joblib
# jupyterlab

# 分析系
# pandas
# numpy
# scipy
# xlrd
# XlsxWriter
# python-math
# scikit-learn

# 画像系
# matplotlib
# japanize-matplotlib
# Pillow
# opencv-python
# folium
# plotly
# wordcloud

# スクレイピング系
# requests
# beautifulsoup4
# lxml
# selenium

# web系
# Flask
# Flask-Bootstrap4
# Django
# PyMySQL
# tweepy
fastapi>=0.68.0,<0.69.0
pydantic>=1.8.0,<2.0.0
uvicorn>=0.15.0,<0.16.0

sqlalchemy
aiosqlite
```