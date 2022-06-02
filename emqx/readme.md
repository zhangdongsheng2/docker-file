# 配置说明
## 配置文件
1. data/loaded_plugins : 配置开启的插件
2. etc/emqx.conf : 基础配置, 可配置是否校验密码.
3. etc/plugins/emqx_dashboard.conf : 管理平台相关配置.
4. etc/plugins/emqx_auth_username.conf : 配置认证的账号密码
5. docker-compose 编写配置, (EMQX_)  前缀无用, (EMQX_AUTH__USER__1__USERNAME)  __ 用来代替 . 
```text
   environment:
    - "EMQX_NAME=emqx"
    - "EMQX_HOST=127.0.0.1"
    - "EMQX_ACL_NOMATCH=deny"                   #配置验证不通过就拒绝
    - "EMQX_ALLOW_ANONYMOUS=false"              #配置开启验证
    - "EMQX_LOADED_PLUGINS=emqx_auth_username"  #配置开启的插件, 用户认证插件
    - "EMQX_AUTH__USER__1__USERNAME=mqprd"       #配置连接mqtt的用户名
    - "EMQX_AUTH__USER__1__PASSWORD=fbjLcBESCppsd2dn" #配置连接mqtt的密码
    - "EMQX_DASHBOARD__DEFAULT_USER__PASSWORD=x8n7w3v8p2" #配置管理平台的密码
```

# 插件介绍
1. emqx_dashboard: 这个是大屏可视化页面管理. 对应插件管理配置, 如密码配置: dashboard.default_user.password=public
2. emqx_auth_username: 对应的是mqtt的账号密码验证. 如配置: auth.user.1.username=admin
3. 默认开启插件:emqx_recon,emqx_retainer,emqx_management,emqx_dashboard,emqx_telemetry,emqx_rule_engine,


