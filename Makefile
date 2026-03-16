.PHONY: help install test lint format clean build publish run

help:
	@echo "OXY-Audit MCP Plugin - 开发命令"
	@echo ""
	@echo "可用命令:"
	@echo "  make install    - 安装项目依赖"
	@echo "  make test       - 运行测试"
	@echo "  make lint       - 运行代码检查"
	@echo "  make format     - 代码格式化"
	@echo "  make clean      - 清理缓存文件"
	@echo "  make build      - 构建包"
	@echo "  make publish    - 发布到 PyPI"
	@echo "  make run        - 运行 MCP 服务器"

install:
	pip install -e ".[dev]"

test:
	pytest tests/ -v --cov=oxyaudit --cov-report=term-missing

lint:
	ruff check oxyaudit/
	black --check oxyaudit/

format:
	black oxyaudit/
	ruff --fix oxyaudit/

clean:
	rm -rf build/ dist/ *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type d -name ".pytest_cache" -exec rm -rf {} +

build:
	python -m build

publish:
	twine upload dist/*

run:
	python -m oxyaudit.mcp_server
