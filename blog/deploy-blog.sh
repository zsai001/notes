#!/bin/bash

# 博客部署脚本
# 使用方法: ./deploy-blog.sh

set -e

echo "🚀 开始部署博客..."

# 进入博客目录
cd "$(dirname "$0")"

# 生成静态文件
echo "🔨 生成静态文件..."
hugo --minify

# 检查是否在Git仓库中
if [ ! -d ".git" ]; then
    echo "📦 初始化Git仓库..."
    git init
fi

# 添加所有文件
echo "📝 添加文件到Git..."
git add .

# 提交更改
echo "💾 提交更改..."
git commit -m "Update blog $(date '+%Y-%m-%d %H:%M:%S')" || echo "没有新的更改需要提交"

# 检查远程仓库
if ! git remote | grep -q origin; then
    echo "⚠️  请先设置远程仓库："
    echo "   git remote add origin https://github.com/yourusername/yourusername.github.io.git"
    echo "   然后重新运行此脚本"
    exit 1
fi

# 推送到远程仓库
echo "🚀 推送到远程仓库..."
git push origin main || git push origin master

echo "✅ 博客部署完成！"
echo ""
echo "🌐 您的博客应该可以在以下地址访问："
echo "   https://yourusername.github.io"
echo ""
echo "💡 提示："
echo "   - 首次部署可能需要几分钟才能生效"
echo "   - 记得在GitHub仓库设置中启用GitHub Pages"
echo "   - 可以设置自定义域名"
