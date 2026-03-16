# OXY-Audit MCP Plugin

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/python-3.11%2B-blue" alt="Python">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
  <img src="https://img.shields.io/badge/MCP-1.1.0%2B-green" alt="MCP">
</p>

> 四审计合一平台的 MCP (Model Context Protocol) 插件 - 主机/日志/数据库/网络审计

## ✨ 功能特性

- **主机审计** - SSH/RDP 会话审计、命令审计、主机安全检查
- **日志审计** - 日志查询、威胁检测、模式分析  
- **数据库审计** - 数据库监控、权限检查、SQL 查询审计
- **网络审计** - 网络扫描、连接检查、C2 流量检测
- **告警管理** - 告警列表、风险评分、报告生成

## 📦 安装

```bash
pip install oxy-audit-mcp
```

或从源码安装：

```bash
git clone https://github.com/oxy-audit/mcp-plugin.git
cd mcp-plugin
pip install -e .
```

## ⚙️ 配置

### 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `OXY_API_URL` | OXY-Audit API 地址 | `http://localhost:8000` |
| `OXY_API_KEY` | API 认证密钥 | (必填) |
| `OXY_TIMEOUT` | 请求超时(秒) | `30` |
| `OXY_VERIFY_SSL` | 是否验证SSL | `true` |

### 快速配置

```bash
# 复制配置模板
cp .env.example .env

# 编辑 .env 文件
OXY_API_URL=http://your-oxy-audit-server:8000
OXY_API_KEY=your-api-key-here
```

## 🚀 使用方法

### 方式一：命令行运行

```bash
# 设置环境变量后运行
export OXY_API_KEY=your-api-key
python -m oxyaudit.mcp_server
```

### 方式二：在 Python 代码中使用

```python
from oxyaudit.tools import list_hosts, query_logs
import asyncio

async def main():
    # 查询主机列表
    hosts = await list_hosts(limit=10)
    print(hosts)
    
    # 查询日志
    logs = await query_logs(query="error", limit=50)
    print(logs)

asyncio.run(main())
```

### 方式三：作为 MCP 客户端工具

本插件实现了 MCP 协议，可被任何 MCP 客户端调用：

```json
{
  "name": "oxy-audit",
  "command": "python",
  "args": ["-m", "oxyaudit.mcp_server"],
  "env": {
    "OXY_API_KEY": "${OXY_API_KEY}"
  }
}
```

## 🛠️ MCP Tools 清单

| 工具名 | 功能 | 参数 |
|--------|------|------|
| `oxy_list_hosts` | 列出所有受管主机 | `limit`, `offset` |
| `oxy_get_host_info` | 获取主机详细信息 | `host_id` |
| `oxy_check_host_security` | 主机安全检查 | `host_id` |
| `oxy_query_logs` | 查询日志 | `query`, `start_time`, `end_time`, `log_type`, `limit` |
| `oxy_detect_threats` | 威胁检测 | `source_type`, `severity` |
| `oxy_list_databases` | 列出受管数据库 | `db_type` |
| `oxy_check_db_privileges` | 数据库权限检查 | `database`, `user` |
| `oxy_scan_network` | 网络扫描 | `target`, `scan_type` |
| `oxy_list_alerts` | 告警列表 | `status`, `limit` |
| `oxy_get_risk_score` | 获取风险评分 | `scope` |
| `oxy_generate_report` | 生成审计报告 | `report_type`, `time_range`, `format` |

## 📋 使用示例

### 示例1：查询主机安全状态

```python
# 获取所有主机
hosts = await list_hosts(limit=50)

# 检查每台主机的安全状态
for host in hosts["hosts"]:
    security = await check_host_security(host["id"])
    print(f"{host['name']}: 风险分数 {security['risk_score']}")
```

### 示例2：威胁检测

```python
# 检测所有高危威胁
threats = await detect_threats(
    source_type="all",
    severity="high"
)

print(f"发现 {threats['total']} 个高危威胁")
for threat in threats["threats"]:
    print(f"- {threat['description']}")
```

### 示例3：生成审计报告

```python
# 生成7天详细审计报告
report = await generate_report(
    report_type="detailed",
    time_range="7d",
    format="json"
)

print(f"报告ID: {report['report_id']}")
print(f"总事件数: {report['summary']['total_events']}")
```

## 🔧 开发

### 本地开发

```bash
# 克隆项目
git clone https://github.com/oxy-audit/mcp-plugin.git
cd mcp-plugin

# 创建虚拟环境
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
# 或 .venv\Scripts\activate  # Windows

# 安装依赖
pip install -e ".[dev]"

# 运行测试
pytest tests/ -v

# 运行 lint
ruff check oxyaudit/
black --check oxyaudit/
```

### 使用模拟数据

未配置 `OXY_API_KEY` 时，插件会自动使用模拟数据，方便开发测试：

```python
# 无需配置 API 即可测试
from oxyaudit.tools.host_audit import list_hosts_mock

result = await list_hosts_mock()
print(result)
```

## 📁 项目结构

```
oxy-audit-mcp/
├── README.md                 # 本文件
├── LICENSE                   # MIT 许可证
├── pyproject.toml           # 项目配置
├── requirements.txt          # Python 依赖
├── mcp.json                # MCP 配置清单
├── .env.example            # 配置模板
├── oxyaudit/
│   ├── __init__.py
│   ├── mcp_server.py       # MCP 服务器入口
│   ├── core/
│   │   ├── __init__.py
│   │   └── config.py       # 配置管理
│   └── tools/
│       ├── __init__.py
│       ├── host_audit.py   # 主机审计
│       ├── log_audit.py    # 日志审计
│       ├── db_audit.py     # 数据库审计
│       ├── net_audit.py    # 网络审计
│       └── alerts.py       # 告警管理
├── tests/
│   └── test_tools.py       # 测试用例
└── .github/
    └── workflows/
        └── ci.yml          # CI/CD 工作流
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/xxx`)
3. 提交更改 (`git commit -m 'Add xxx'`)
4. 推送分支 (`git push origin feature/xxx`)
5. 创建 Pull Request

## 📄 许可证

MIT License - see [LICENSE](LICENSE) file for details.

## 🔗 相关链接

- [OXY-Audit 官网](https://oxy-audit.local)
- [MCP 协议文档](https://modelcontextprotocol.io)
- [GitHub 仓库](https://github.com/oxy-audit/mcp-plugin)
