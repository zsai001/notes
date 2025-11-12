#!/bin/bash

# 一键博客生成脚本
# 使用方法: ./generate-blog.sh

set -e

echo "🚀 开始一键生成博客..."

# 检查Hugo是否安装
if ! command -v hugo &> /dev/null; then
    echo "❌ Hugo未安装，正在安装..."
    if command -v brew &> /dev/null; then
        brew install hugo
    else
        echo "请先安装Homebrew或手动安装Hugo"
        echo "访问: https://gohugo.io/installation/"
        exit 1
    fi
fi

# 进入博客目录
cd "$(dirname "$0")"

# 如果不存在Hugo站点，创建新站点
if [ ! -f "config.yaml" ] && [ ! -f "config.toml" ] && [ ! -f "config.json" ]; then
    echo "📝 创建新的Hugo站点..."
    hugo new site . --force
    
    # 下载推荐主题 PaperMod
    echo "🎨 下载PaperMod主题..."
    git init
    git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
    
    # 创建基础配置
    cat > config.yaml << EOF
baseURL: 'https://yourusername.github.io/'
languageCode: 'zh-cn'
title: '我的知识博客'
theme: 'PaperMod'

params:
  env: production
  title: '我的知识博客'
  description: '知识探索与智慧积累'
  author: '您的名字'
  keywords: [博客, 知识, 学习, 思考]
  
  # 主题配置
  themeVariant: [ "auto", "light", "dark" ]
  defaultTheme: "light"
  disableThemeToggle: false
  
  # 导航菜单
  menu:
    main:
      - identifier: home
        name: 首页
        url: /
        weight: 10
      - identifier: posts
        name: 文章
        url: /posts/
        weight: 20
      - identifier: tags
        name: 标签
        url: /tags/
        weight: 30
      - identifier: categories
        name: 分类
        url: /categories/
        weight: 40

# 内容配置
markup:
  goldmark:
    renderer:
      unsafe: true
EOF

    # 创建示例文章
    echo "📄 创建示例文章..."
    hugo new posts/hello-world.md
    
    # 编辑示例文章内容
    cat > content/posts/hello-world.md << EOF
---
title: "欢迎来到我的知识博客"
date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
draft: false
tags: ["欢迎", "博客"]
categories: ["公告"]
---

# 欢迎来到我的知识博客！

这是我的第一篇博客文章。在这里，我将分享我的学习心得、思考感悟和生活智慧。

## 关于这个博客

这个博客基于Hugo构建，使用PaperMod主题，具有以下特点：

- 🚀 **快速生成** - 几秒内生成整个网站
- 📱 **响应式设计** - 完美适配各种设备
- 🌙 **暗色模式** - 支持明暗主题切换
- 🔍 **搜索功能** - 快速找到想要的内容
- 📊 **标签分类** - 方便内容组织

## 开始使用

1. 编辑 `content/posts/` 目录下的文章
2. 运行 `./generate-blog.sh` 生成博客
3. 运行 `hugo server` 本地预览

希望您喜欢这个博客！🎉
EOF

fi

# 生成静态文件
echo "🔨 生成静态文件..."
hugo --minify

echo "✅ 博客生成完成！"
echo ""
echo "📁 静态文件位置: public/"
echo "🌐 本地预览命令: hugo server"
echo "🚀 部署命令: ./deploy-blog.sh"
echo ""
echo "💡 提示："
echo "   - 编辑 content/posts/ 目录下的文章"
echo "   - 运行 hugo server 进行本地预览"
echo "   - 访问 http://localhost:1313 查看效果"
