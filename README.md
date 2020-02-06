# Downloader

基于Aria2的一个下载工具，同时提供S3接口用于文件传输。

## 基本框架

* Web服务器（Nginx）
  * 为AriaNg提供服务
  * 反向代理S3服务器
  * 反向代理aria2c的RPC
* S3服务器（MinIO）
  * 为下载得到的文件提供文件传输
* Aria2c
  * 下载文件

## 环境变量

* `RPC_SECRET`: Aria2 RPC 密钥
* `MINIO_ACCESS_KEY`: MinIO Access Key
* `MINIO_SECRET_KEY` MinIO Secret Key

## 卷

* `/data`
  * `/data/config` 配置文件
  * `/data/downloa` 下载内容
