#!/bin/bash

# Claude Code 一键安装脚本（阿里云百炼版）
# 支持国内网络环境，使用阿里云镜像源

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置路径
CLAUDE_CONFIG_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_CONFIG_DIR/settings.json"
CLAUDE_JSON_FILE="$CLAUDE_CONFIG_DIR/.claude.json"
ENV_FILE="$HOME/.claude_env"

# 当前脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Claude Code 一键安装脚本${NC}"
echo -e "${BLUE}  阿里云百炼API版本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查并安装 Node.js
install_nodejs() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        echo -e "${GREEN}✓ Node.js 已安装: $NODE_VERSION${NC}"
        return 0
    fi

    echo -e "${YELLOW}正在安装 Node.js...${NC}"

    # 检测系统类型
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v apt-get &> /dev/null; then
            # Debian/Ubuntu
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v yum &> /dev/null; then
            # RHEL/CentOS/Fedora
            curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
            sudo yum install -y nodejs
        elif command -v pacman &> /dev/null; then
            # Arch Linux
            sudo pacman -S nodejs npm
        else
            echo -e "${RED}✗ 不支持的 Linux 发行版，请手动安装 Node.js 20+${NC}"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install node@20
        else
            echo -e "${YELLOW}未检测到 Homebrew，正在安装...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install node@20
        fi
    else
        echo -e "${RED}✗ 不支持的操作系统: $OSTYPE${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Node.js 安装完成${NC}"
}

# 安装 Claude Code
install_claude() {
    if command -v claude &> /dev/null; then
        echo -e "${GREEN}✓ Claude Code 已安装${NC}"
        return 0
    fi

    echo -e "${YELLOW}正在安装 Claude Code...${NC}"

    # 使用国内npm镜像源
    npm config set registry https://registry.npmmirror.com

    # 全局安装 Claude Code
    npm install -g @anthropic-ai/claude-code

    echo -e "${GREEN}✓ Claude Code 安装完成${NC}"
}

# 配置 Claude Code
configure_claude() {
    echo -e "${YELLOW}正在配置 Claude Code...${NC}"

    # 创建配置目录
    mkdir -p "$CLAUDE_CONFIG_DIR"

    # 检查环境变量文件
    if [[ ! -f "$ENV_FILE" ]]; then
        echo -e "${YELLOW}首次使用，需要配置 API Key${NC}"
        echo ""
        echo -e "${BLUE}请在 ~/.claude_env 文件中设置你的阿里云百炼 API Key${NC}"
        echo ""
        echo "格式如下："
        echo "  ANTHROPIC_AUTH_TOKEN=your-api-key-here"
        echo ""
        echo -e "${YELLOW}你可以从 https://bailian.console.aliyun.com/ 获取 API Key${NC}"
        echo ""

        # 创建示例环境变量文件
        cat > "$ENV_FILE" << 'EOF'
# Claude Code 环境变量配置
# 请将此文件中的 your-api-key-here 替换为你的真实 API Key

# 阿里云百炼 API Key
ANTHROPIC_AUTH_TOKEN=your-api-key-here

# 阿里云百炼 API 地址
ANTHROPIC_BASE_URL=https://coding.dashscope.aliyuncs.com/apps/anthropic

# 默认模型（可选）
ANTHROPIC_MODEL=kimi-k2.5
EOF

        echo -e "${YELLOW}已在 $ENV_FILE 创建模板配置文件${NC}"
        echo -e "${YELLOW}请先编辑该文件填入你的 API Key，然后重新运行此脚本${NC}"
        exit 1
    fi

    # 加载环境变量
    source "$ENV_FILE"

    # 验证 API Key 是否已设置
    if [[ "$ANTHROPIC_AUTH_TOKEN" == "your-api-key-here" ]] || [[ -z "$ANTHROPIC_AUTH_TOKEN" ]]; then
        echo -e "${RED}✗ API Key 未设置或仍为默认值${NC}"
        echo -e "${YELLOW}请先编辑 $ENV_FILE 文件并设置有效的 API Key${NC}"
        exit 1
    fi

    # 复制 settings.json 模板
    if [[ -f "$SCRIPT_DIR/settings.json.template" ]]; then
        # 读取模板并替换环境变量
        envsubst < "$SCRIPT_DIR/settings.json.template" > "$SETTINGS_FILE"
        echo -e "${GREEN}✓ settings.json 配置完成${NC}"
    else
        echo -e "${RED}✗ 未找到 settings.json.template 文件${NC}"
        exit 1
    fi

    # 复制 claude.json 模板（如果存在）
    if [[ -f "$SCRIPT_DIR/claude.json.template" ]]; then
        cp "$SCRIPT_DIR/claude.json.template" "$CLAUDE_JSON_FILE"
        echo -e "${GREEN}✓ .claude.json 配置完成${NC}"
    fi

    # 设置权限
    chmod 600 "$SETTINGS_FILE"
    chmod 600 "$ENV_FILE"
    [[ -f "$CLAUDE_JSON_FILE" ]] && chmod 600 "$CLAUDE_JSON_FILE"

    echo -e "${GREEN}✓ Claude Code 配置完成${NC}"
}

# 添加到 shell 配置文件
add_to_shell_config() {
    local shell_rc=""
    local current_shell="$(basename "$SHELL")"

    case "$current_shell" in
        bash)
            shell_rc="$HOME/.bashrc"
            ;;
        zsh)
            shell_rc="$HOME/.zshrc"
            ;;
        fish)
            shell_rc="$HOME/.config/fish/config.fish"
            ;;
        *)
            shell_rc="$HOME/.bashrc"
            ;;
    esac

    # 检查是否已添加
    if grep -q "source.*\.claude_env" "$shell_rc" 2>/dev/null; then
        echo -e "${GREEN}✓ 环境变量已在 $shell_rc 中配置${NC}"
        return 0
    fi

    echo -e "${YELLOW}正在将环境变量添加到 $shell_rc...${NC}"

    cat >> "$shell_rc" << EOF

# Claude Code 环境变量
if [ -f ~/.claude_env ]; then
    source ~/.claude_env
fi
EOF

    echo -e "${GREEN}✓ 环境变量已添加到 $shell_rc${NC}"
    echo -e "${YELLOW}注意：请运行 'source $shell_rc' 或重新登录以使更改生效${NC}"
}

# 显示使用说明
show_usage() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  安装完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "使用方法："
    echo "  1. 直接运行: claude"
    echo "  2. 在任意目录下输入 'claude' 即可启动"
    echo ""
    echo "常用命令："
    echo "  claude              - 启动 Claude Code"
    echo "  claude --help       - 查看帮助"
    echo "  claude --version    - 查看版本"
    echo ""
    echo "配置文件位置："
    echo "  - Claude 配置: ~/.claude/settings.json"
    echo "  - API Key: ~/.claude_env"
    echo ""
    echo -e "${YELLOW}提示：如果这是首次安装，请运行以下命令使环境变量生效：${NC}"
    echo "  source ~/.claude_env"
    echo ""
}

# 主函数
main() {
    # 安装依赖
    install_nodejs
    install_claude

    # 配置
    configure_claude
    add_to_shell_config

    # 显示使用说明
    show_usage
}

# 运行主函数
main
