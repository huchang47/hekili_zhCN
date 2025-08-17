# Hekili

**Hekili** 是一个功能强大、高度可配置的**魔兽世界优先级助手**。它支持**所有🗡️输出和🛡️坦克专精**。➕治疗专精也受支持，主要关注**输出技能**，非常适合单人内容或PvE战斗中的空闲时间。

[➡️ 最新中文版](https://github.com/huchang47/hekili_zhCN/releases/latest)


## ✨ 它能做什么？

Hekili 通过推荐战斗中应该使用的技能来帮助你更有效地游戏。

它的**核心特性**是显示多个即将到来的连续动作，让你能够提前计划，而不是仅仅对单个不断变化的图标做出反应。这种方法减少了视野局限，帮助你更好地专注于战斗本身。

这些建议是基于从[**SimulationCraft**](https://www.simulationcraft.org)和[**RaidBots**](https://www.raidbots.com/simbot)继承的**技能优先级列表(APL)逻辑**提供的。这种集成有助于确保你在游戏中的决策与你已经在使用的天赋、装备和属性优化工具保持一致。APL会**经常更新**以反映职业平衡、机制和理论研究的变化。

**Hekili** 可以帮助你：
- 提高输出伤害
- 学习和掌握新的专精
- 提高操作的一致性，并将你的决策与理论模拟进行对比

## 🔧 它是如何工作的？

**Hekili** 使用你当前角色状态 — 包括冷却时间、资源、增益/减益效果和附近的敌人 — 来**模拟未来几个技能**，使用你专精的 APL 逻辑。它假设你按顺序执行其建议。

如果你施放了其他技能，插件会**立即重新评估**你的游戏状态并实时更新建议。

其他功能包括：
- 可选的独立显示：
  - AOE 技能
  - 冷却技能
  - 防御技能
  - 打断技能
    - 引导你在敌人施法后期进行打断
    - 过滤显示史诗钥石优先级技能
- 冷却、防御、打断、药水的开关控制：
  - 你可以通过启用或禁用开关选项来手动控制是否使用像 2 分钟冷却这样的主要技能。
  - 这些开关可以绑定到快捷键或宏，让你能够根据每场战斗灵活控制。
  - 除了使用开关，你还可以在专门的冷却显示中显示这些技能，让你在时机最佳时手动施放。
  - 当与战斗机制知识结合时，这个系统特别强大 — 例如，为爆发阶段或小怪刷新保留冷却可以带来可观的 DPS 提升。
- 兼容 **ElvUI**、**Bartender** 和其他界面插件
- 自定义选项
  - 从多种显示风格中选择以满足你的需求 — 从单一的自动显示到 AOE 专用或双显示设置
  - 调整外观和感觉：调整图标大小、间距、布局、字体和透明度
  - 在图标上显示技能快捷键，或将默认图标替换为其他技能或材质
  - 禁用单个技能以适应你的游戏风格 — 例如，如果你更喜欢将使用饰品宏写入冷却技能中，你可以完全隐藏该饰品
  - 高级用户可以使用熟悉的 **SimulationCraft 风格语法**编辑或创建自己的动作列表

## 🚀 开始使用

### 1. **安装插件**

安装 **Hekili** 有两种主要方式：

- **插件管理器**（推荐）：自动安装并保持插件更新
- **手动下载**：从 [**GitHub Releases**](https://github.com/huchang47/hekili_zhCN/releases/latest) 下载并解压 `.zip` 文件到 `Interface/AddOns` 目录

#### 推荐的插件管理器
由于 **Hekili** 经常更新，我们建议使用以下可信赖的工具之一：
- [**新手盒子**](https://www.wclbox.com/) - 一个简单易用的插件管理器，对中文用户友好。
- [**CurseForge**](https://www.curseforge.com/download) – 一个广泛使用的通用插件管理器。我们推荐使用 Windows 或 macOS 的独立桌面版本，以避免额外的界面叠加。
- [**Wago App**](https://addons.wago.io/download) – 如果你同时使用 **WeakAuras**、**Plater scripts** 或其他 Wago 托管的内容，这是理想的选择。
- [**WowUp**](https://wowup.io/) – 支持 **CurseForge** 和 **Wago** 后端，并包含自己的插件库。除非你使用其他工具来管理 WeakAuras，否则我们建议使用 **CurseForge** 版本。
- [**CurseBreaker**](https://github.com/AcidWeb/CurseBreaker) (适合💪进阶用户) – 一个轻量级命令行界面(CLI)工具，支持 **Wago**、**WoWInterface**、**Tukui**、**ElvUI**、**GitHub** 等。使用 **WoWInterface** 更新时无需额外设置。

### 2. 游戏内设置

使用小地图图标或输入命令：`/hekili`

## 🛠 需要帮助？

### 🐛 错误报告

如果遇到问题：

1. 安装 [**BugSack**](https://www.curseforge.com/wow/addons/bugsack) 和 [**BugGrabber**](https://www.curseforge.com/wow/addons/bug-grabber)
2. 重现问题，生成一个[**快照**](https://github.com/Hekili/hekili/wiki/Report-An-Issue#how-do-i-get-a-snapshot)，然后打开 BugSack 检查 LUA 错误
3. 在[**问题页面**](https://github.com/Hekili/hekili/issues/new/choose)提交报告，请务必包含你刚刚获取的快照和 LUA 错误（如果有）

### ❓ 其他支持

- 在[**大漩涡数据港**](https://www.wowdata.cn)获取最新资讯和数据统计
- 查看[**Wiki**](https://github.com/Hekili/hekili/wiki)
- 在[**Hekili Discord**](https://discord.gg/3cCTFxM)中提问

---

## 🙏 致谢

- 基于[**SimulationCraft**](https://www.simulationcraft.org/)的逻辑，该项目由众多优秀的开发者和理论研究者维护
- 使用了[**Ace3**](https://www.wowace.com/projects/ace3)、[**LibRangeCheck**](https://www.wowace.com/projects/librangecheck-2-0)等库
- 由[**Hekili**](https://github.com/Hekili)、[**Syrif**](https://github.com/syrifgit)、[**Nerien**](https://github.com/johnnylam88)维护，并得到社区贡献者的大力帮助
- 本中文版由[**胡里胡涂(huchang47)**](https://github.com/huchang47)长期更新维护

---

## 🧪 开发者说明

如果你正在开发自定义专精模块、改进现有逻辑或为插件开发做贡献：

- 查看[**开发者资源**](https://github.com/Hekili/hekili/wiki/Developer-Stuff)页面
- 使用 `/hekili` 命令并在快照标签页中检查实时决策过程
- 查看现有和历史[**拉取请求**](https://github.com/Hekili/hekili/pulls)
- 查看现有和历史[**问题**](https://github.com/Hekili/hekili/issues)
