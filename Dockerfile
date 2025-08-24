# 使用一个轻量级的 Alpine Linux 作为基础镜像
FROM alpine:latest

# 定义 gost 版本，方便未来升级，默认为您指定的 2.12.0
ARG GOST_VERSION=2.12.0

# --- 主要改动区域 ---
# 1. 安装 tar 来处理 .tar.gz 文件，而不是 unzip。
# 2. 更新下载链接和文件名格式以匹配新的发布规则。
# 3. 使用 tar -xzf 命令来解压。
# 4. 假设解压出的文件名为 gost (更通用的情况)。
RUN apk add --no-cache wget tar && \
    wget https://github.com/ginuerzh/gost/releases/download/v${GOST_VERSION}/gost_${GOST_VERSION}_linux_amd64.tar.gz && \
    tar -xzf gost_${GOST_VERSION}_linux_amd64.tar.gz && \
    mv gost /usr/bin/gost && \
    chmod +x /usr/bin/gost && \
    rm gost_${GOST_VERSION}_linux_amd64.tar.gz && \
    apk del wget tar
# --- 改动结束 ---

# PaaS 平台会把外部的 443 端口映射到这个容器内的 8080 端口
EXPOSE 8080

# 启动 gost 的命令保持不变，它依然非常强大和灵活
# 确保这里的用户名、密码与您的 Worker 配置匹配
CMD ["gost", "-L", "socks5+ws://name:pass@:8080"]
