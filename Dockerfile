FROM python:3.12-slim

WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 拷贝代码
COPY img_downloader_web_zip_only.py .

# 创建临时目录（默认）
RUN mkdir -p /app/tmp_zip

# 环境变量（可选）
ENV TMP_DIR=/app/tmp_zip
ENV PYTHONUNBUFFERED=1

# 暴露端口（Zeabur 会自动映射）
EXPOSE 5000

# 使用 gunicorn 启动 Flask 应用
# 关键点：绑定到 $PORT（Zeabur 会注入 PORT 环境变量）
CMD ["sh", "-c", "gunicorn -b 0.0.0.0:${PORT:-5000} img_downloader_web_zip_only:app --workers 4 --threads 8 --timeout 120"]
