# OXY-Audit MCP Plugin

四审计合一平台的 MCP (Model Context Protocol) 插件 - 主机/日志/数据库/网络审计

## 服务配置

```json
{
  "mcpServers": {
    "oxy-audit": {
      "command": "python",
      "args": ["-m", "oxyaudit.mcp_server"],
      "env": {
        "OXY_API_KEY": ""
      }
    }
  }
}
```

## 环境变量

- OXY_API_URL: API 地址 (默认 http://localhost:8000)
- OXY_API_KEY: API 密钥 (留空使用模拟数据)

## MCP Tools (11个)

| 工具 | 功能 |
|------|------|
| oxy_list_hosts | 列出所有受管主机 |
| oxy_get_host_info | 获取主机详细信息 |
| oxy_check_host_security | 主机安全检查 |
| oxy_query_logs | 查询日志 |
| oxy_detect_threats | 威胁检测 |
| oxy_list_databases | 列出受管数据库 |
| oxy_check_db_privileges | 数据库权限检查 |
| oxy_scan_network | 网络扫描 |
| oxy_list_alerts | 告警列表 |
| oxy_get_risk_score | 获取风险评分 |
| oxy_generate_report | 生成审计报告 |

## 许可证

MIT License
