FROM python:3.9-slim
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
RUN pip install --no-cache-dir --upgrade -r requirements.txt

#CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
CMD ["gunicorn", "app.main:app", "-w", "4", "-t", "2", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]
