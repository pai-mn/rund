# rund

一个简单轻量的后台进程管理工具。

## 功能

- 后台启动命令并自动记录PID
- 查看所有运行中的进程
- 停止指定的进程

## 使用方法

```bash
# 后台启动命令
./rund start <command>

# 查看运行中的进程
./rund status

# 停止指定PID的进程
./rund stop <pid>
```

## 示例

```bash
# 启动一个Python服务器
./rund start python -m http.server 8000

# 启动一个Node.js应用
./rund start node app.js

# 查看所有进程
./rund status

# 停止PID为12345的进程
./rund stop 12345
```

## 特性

- 自动创建 `~/.rund/pids/` 目录存储PID文件
- 进程状态实时检测（自动清理已死亡的进程）
- 简洁的命令行接口
