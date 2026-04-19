# CLAUDE.md

本文档为 Claude Code（claude.ai/code）在本仓库中工作时提供指引。

## 项目定位

Factorio 2.0 **整合包** Mod（`nzh_factorio_mod`），不包含任何 Lua 代码。它只是一个依赖容器，通过硬依赖一次性拉起 NZH 维护的三个开局 Mod 以及一串社区常用 QoL Mod。

仓库中只保留最小文件集：

- `info.json` — 声明硬依赖 `LegendaryMechStart`、`LegendaryShipStart`、`BestLanding`，以及 Factorio 2.0 基础依赖 `base`、`space-age`、`quality`，再加一长串 `?` 可选社区 Mod。
- `locale/zh-CN/zh-CN.cfg` — Mod 名/描述的中文翻译。
- `README.md`、`changelog.txt`、`LICENSE`、`thumbnail.png` — 发布到 Mod portal 给其他人看的元信息。

**如果你打算在这里新建 `.lua` 文件，大概率选错仓库了。** 真正的代码应该放在三个被依赖的开局 Mod 里，或者新建一个专职 Mod；这个整合包故意保持无逻辑，这样底层 Mod 反复迭代时它自己可以一直稳定。

## 常用命令

- **运行 / 迭代**：在 Factorio Mod 列表里启用本包，下次启动时三个硬依赖会自动一起启用。没有构建步骤。（注：Claude Code 跑在 WSL、Mod 文件通过 Windows 挂载访问，Claude 无法直接启动 Factorio；这一步需要你在 Windows 侧手工操作。）
- **打包发布**：把文件夹压缩成 `nzh_factorio_mod_<version>.zip`，压缩包里最外层是这个文件夹本身。版本号必须和 `info.json`、`changelog.txt` 顶条一致。
- **Changelog 格式**：遵循 Factorio 严格格式（99 个 `-` 的分隔行、`Version:`、`Date:`、缩进的 `Changes:` 块）。写英文。

## 版本策略

- `2.0.0` 是本 Mod 转型为整合包的节点，`2.0` 之前的版本里还含有后来迁到各专职 Mod 的 Lua 逻辑。
- 增删硬依赖 → bump minor（用户真实体验变化）。
- 只改 README / locale / `?` 可选列表 → bump patch（已有硬依赖的用户无感）。

## 依赖清单

硬依赖（会自动启用）：
- `LegendaryMechStart` — 传奇机甲开局
- `LegendaryShipStart` — 在 Nauvis 上空预置传奇太空飞船
- `BestLanding` — 着陆区清理 + 行星专属资源 + 传奇蜘蛛
- `base >= 2.0.76`、`space-age`、`quality` — Factorio 2.0 基础 + Space Age + Quality

可选依赖（`?`）仅做加载顺序提示，增删安全。

## 在这里通常该做的事

- **往整合包里加一个新开局 Mod** → 在 `dependencies` 加硬依赖条目、bump version、写 changelog。
- **撤掉一个依赖** → 从 `dependencies` 移除、bump version、在 changelog 说明该功能现在由谁提供（或不再提供）。
- **永远别** 往这里塞 Lua 代码。哪怕是独一无二的功能，也要拆成新 Mod 再让整合包依赖它。

## 语言约定

- Lua 代码注释、`CLAUDE.md`：**中文**。
- `README.md`、`changelog.txt`、`info.json` 的 `description` / `title`、Mod portal 上的内容：**英文**。
- `locale/*.cfg` 按对应语言写（`zh-CN.cfg` 自然是中文）。
- 技术标识符（函数名、API 字段、事件名）不翻译，用反引号原样保留。

## Factorio API 参考

- Wiki：<https://wiki.factorio.com/>
- Mod 站：<https://mods.factorio.com/>
- Mod settings 教程：<https://wiki.factorio.com/Tutorial:Mod_settings>
- Prototype API（data 阶段）：<https://lua-api.factorio.com/latest/index-prototype.html>
- Runtime API（control 阶段）：<https://lua-api.factorio.com/latest/index-runtime.html>
- `info.json` 依赖语法参考：<https://wiki.factorio.com/Tutorial:Mod_structure#info.json>

## 代码风格

- `info.json` 里依赖按"硬依赖在前、`?` 可选依赖按字母序在后"排列，便于 diff。
