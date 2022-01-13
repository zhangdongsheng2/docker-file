#密码管理器
## 简介
Bitwarden 是一款开源密码管理器，它会将所有密码加密存储在服务器上，
它的工作方式与 LastPass、1Password 或 Dashlane 相同。


## 搭建
1. 官方的版本搭建对服务器要求很高，搭建不容易，GitHub上有人用 Rust 实现了 Bitwarden 服务器，
项目叫 vaultwarden，并且提供了 Docker 镜像， 这个实现更进一步降低了对机器配置的要求，
并且 Docker 镜像体积很小，部署非常方便。这个项目目前在GitHub也有13.8k的star，非常受欢迎。

2. 项目：https://github.com/dani-garcia/vaultwarden
3. 直接启动 docker-compose 内部web端口是80.
4. 购买域名开启ssl证书: 创建账号，需要在开启了ssl证书的情况下才会成功。
5. 使用直接在设置中配置服务器地址即可, 下面任一即可.
   * https://##.##info.cn:33307
   * http://##.##info.cn:33303

