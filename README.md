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

首次运行会提示你配置 API Key，按提示编辑 `~/.claude_env` 后重新运行即可。

**获取 API Key**: 访问 [阿里云百炼控制台](https://bailian.console.aliyun.com/)

### 3. 启动 Claude Code

```bash
claude
```

---

## ⚠️ Windows 用户注意

如果你是在 **Windows** 上使用 Claude Code，配置文件路径不同：

| 平台 | settings.json 路径 |
|------|-------------------|
| Linux/macOS | `~/.claude/settings.json` |
| Windows | `%APPDATA%\Claude\settings.json` |

Windows 手动配置步骤：

1. 复制 `settings.json.template` 内容
2. 将 `${ANTHROPIC_AUTH_TOKEN}` 替换为你的真实 API Key
3. 保存到 `%APPDATA%\Claude\settings.json`
4. 设置环境变量：
   - `ANTHROPIC_AUTH_TOKEN` = 你的API Key
   - `ANTHROPIC_BASE_URL` = `https://coding.dashscope.aliyuncs.com/apps/anthropic`

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
├── install.sh              # 一键安装脚本（Linux/macOS）
├── settings.json.template  # Claude 配置模板
├── claude.json.template    # Claude 用户数据模板
├── .env.example           # 环境变量示例
├── .gitignore            # Git 忽略规则
└── README.md             # 本文件
```

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

### Q: Windows 上提示无法连接到 Anthropic？

A: 请确保：
1. `settings.json` 放在正确的位置（`%APPDATA%\Claude\settings.json`）
2. 环境变量已正确设置
3. Claude Code 版本较新（v2.1.50+）

## License

MIT
