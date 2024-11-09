# 使用 python:3.9-bookworm 作为基础镜像
FROM python:3.9-bookworm

WORKDIR /app

COPY . .

# 安装必要的系统工具和 Python 依赖
RUN apt update && \
    apt install -y ffmpeg git curl nodejs npm jq && \
    pip install -r requirements.txt

# 创建目录并下载 biliupR 最新版本
RUN VERSION=$(curl -s https://api.github.com/repos/biliup/biliup-rs/releases/latest | jq -r '.tag_name') && \
    FILENAME="biliupR-$VERSION-$(uname -m)-linux" && \
    wget "https://github.com/biliup/biliup-rs/releases/download/$VERSION/$FILENAME.tar.xz" && \
    tar -xf $FILENAME.tar.xz && \
    chmod +x $FILENAME/biliup && \
    mv $FILENAME/biliup /app/tools/ && \
    rm -rf $FILENAME.tar.xz $FILENAME

ENTRYPOINT ["python3", "-u", "main.py"]
