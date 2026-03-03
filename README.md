# Claude Code 一键部署（阿里云百炼版）

专为国内用户设计的 Claude Code 一键安装配置方案，使用阿里云百炼 API，支持国内网络环境。

## 特性

- 🚀 一键安装，自动配置
- 🇨🇳 国内网络友好，使用阿里云镜像源
- 🔐 API Key 安全存储在本地环境变量
- ⚙️ 预配置阿里云百炼 API 端点

## 快速开始

### 1. 克隆仓库

```bash
git clone git@github.com:sant-liustu/claude-envset.git
cd claude-envset
```

### 2. 运行安装脚本

```bash
chmod +x install.sh
./install.sh
```

脚本会自动检测是否需要配置 API Key，如果检测到是首次使用，会提示你编辑 `~/.claude_env` 文件。

### 3. 配置 API Key（首次使用）

如果脚本提示需要配置 API Key，请编辑 `~/.claude_env` 文件：

```bash
vim ~/.claude_env  # 填入你的 ANTHROPIC_AUTH_TOKEN
```

编辑完成后重新运行 `./install.sh`。

### 4. 启动 Claude Code

```bash
claude
```

## 支持的模型

阿里云百炼平台支持以下模型：

| 模型 | 说明 |
|------|------|
| `kimi-k2.5` | Kimi K2.5（推荐） |
| `glm-4.7` | 智谱 GLM-4.7 |
| `claude-sonnet-4` | Claude Sonnet 4 |
| `claude-haiku-4.5` | Claude Haiku 4.5 |

修改 `~/.claude_env` 中的 `ANTHROPIC_MODEL` 即可切换模型。

## 文件说明

```
.
├── install.sh              # 一键安装脚本
├── settings.json.template  # Claude 配置模板
├── .env.example           # 环境变量示例
├── .gitignore            # Git 忽略规则
└── README.md             # 本文件
```

## 手动配置（可选）

如果不想使用安装脚本，可以手动配置：

1. 安装 Node.js 20+
2. 安装 Claude Code: `npm install -g @anthropic-ai/claude-code`
3. 创建 `~/.claude/settings.json`，参考 `settings.json.template`
4. 设置环境变量 `ANTHROPIC_AUTH_TOKEN`

## 常见问题

### Q: 安装过程中提示权限不足？

A: 尝试使用 sudo 运行，或确保当前用户有 npm 全局安装权限：
```bash
sudo ./install.sh
```

### Q: 如何更新 API Key？

A: 直接编辑 `~/.claude_env` 文件，然后重新运行 `./install.sh` 或重启终端。

### Q: 如何卸载 Claude Code？

A: 运行以下命令：
```bash
npm uninstall -g @anthropic-ai/claude-code
rm -rf ~/.claude
rm ~/.claude_env
```

## License

MIT
