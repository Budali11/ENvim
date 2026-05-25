# ENvim

一个类似 LazyVim 的 Neovim 插件整合包骨架，重点支持：

- 启动界面
- Profile 机制
- lazy.nvim 插件管理
- File Explorer
- 通知弹窗
- Buffer/Tab 管理
- LSP
- 文件/文本搜索
- 平滑滚动动画
- 缩进提示线
- AI Coding
- 嵌入式 C/C++ 工作流
- 易扩展的快捷键和插件入口

## 目录结构

```text
.
├─ after
│  ├─ ftplugin
│  │  └─ asm.lua
│  └─ syntax
│     └─ asm.vim
├─ init.lua
└─ lua
   └─ envim
      ├─ config
      │  ├─ autocmds.lua
      │  ├─ filetypes.lua
      │  ├─ keymaps.lua
      │  ├─ lazy.lua
      │  ├─ options.lua
      │  ├─ profiles.lua
      │  ├─ statusline.lua
      │  └─ ui.lua
      ├─ core
      │  └─ profile.lua
      ├─ plugins
      │  ├─ ai.lua
      │  ├─ colorscheme.lua
      │  ├─ editor.lua
      │  ├─ lsp.lua
      │  ├─ ui.lua
      │  └─ user.lua
      └─ profiles
         ├─ init.lua
         └─ embedded
            ├─ config.lua
            ├─ helpers.lua
            └─ plugins.lua
```

## 结构说明

- `lua/envim/plugins/*`：所有 **通用插件**
- `lua/envim/config/keymaps.lua`：所有 **通用快捷键**
- `lua/envim/config/ui.lua`：所有 **通用 UI 参数**
- `lua/envim/config/statusline.lua`：底部 **全局状态栏**
- `lua/envim/config/filetypes.lua`：额外 **filetype 识别**
- `lua/envim/profiles/<name>/*`：某个 profile 独有的配置、辅助函数、插件
- `after/syntax/asm.vim`：对内置 `asm` 语法的 **后置覆盖**
- `after/ftplugin/asm.lua`：对 `asm` filetype 的 **后置 buffer-local 设置**

也就是说，现在 UI 相关的可调参数会集中放在 `config/ui.lua`，公共能力仍然留在 profile 外面。

### `after/` 目录说明

`after/` 是 Neovim 的标准覆盖机制。

- 先加载 runtime 里原本的 `syntax/asm.vim`、`ftplugin/asm.vim`
- 再加载本配置里的 `after/syntax/asm.vim`、`after/ftplugin/asm.lua`

这个仓库现在用它来修正 ARM GNU assembler 的阅读体验：

- `.s` / `.S` / `.asm` 统一识别为 `asm`
- 禁用 Treesitter 的 `asm` 高亮
- 回退到 Neovim 内置 `asm` 语法
- 再通过 `after/syntax/asm.vim` 把 ARM 注释规则覆盖成 `@`
- 保留 `#1` 这类立即数和 `#include` / `#ifdef` 这类预处理行不被误判为注释
- 通过 `after/ftplugin/asm.lua` 设置 `commentstring = "@ %s"`

## UI 配置入口

编辑：

```text
lua/envim/config/ui.lua
```

当前已经集中到这里的内容包括：

- dashboard header
- 通知弹窗持续时间
- bufferline 样式
- 平滑滚动参数
- 缩进线字符

例如通知时间：

```lua
notifier = {
  timeout = 3000,
}
```

## 已实现能力

1. **启动界面**：`snacks.nvim` dashboard
2. **Profile 机制**：`default / embedded / minimal / full / writing`
3. **方便装插件**：`lazy.nvim`
4. **File Explorer**：`Snacks.explorer()`
5. **消息提醒弹窗**：`snacks.nvim` notifier
6. **底部状态栏**：单条全局 statusline，显示当前 Profile / LSP / 诊断 / 文件信息
7. **Tab / Buffer 管理**：`bufferline.nvim`
8. **LSP**：`mason.nvim + mason-lspconfig.nvim + nvim-lspconfig`，C/C++ 使用 `clangd`
9. **搜索**：
   - `<leader>ff` 文件搜索
   - `<leader>fg` 全局文本搜索
   - `<leader>fw` 搜索当前光标单词 / 选中文本
10. **ARM 汇编阅读**：`.s` / `.S` / `.asm` 使用 `asm` filetype，禁用 Treesitter asm 高亮，采用 ARM 注释规则 `@`
11. **代码大纲侧栏**：`outline.nvim`，列出函数/类型/符号树并支持回车跳转
12. **平滑滚动**：`neoscroll.nvim`
13. **缩进提示线**：`indent-blankline.nvim`
14. **AI Coding**：`copilot.lua + CopilotChat.nvim`
15. **嵌入式 C/C++**：`cmake-tools.nvim + overseer.nvim + toggleterm.nvim + nvim-dap + trouble.nvim`
16. **快捷键扩展**：`which-key.nvim` + `jk -> <Esc>`

## Profile 说明

Profile 定义在 `lua/envim/config/profiles.lua`。

- `minimal`：只保留基础 UI
- `default`：常规开发
- `embedded`：嵌入式 C/C++ 开发
- `full`：开发 + AI
- `writing`：偏写作/笔记

### 切换 Profile

- `:ENProfile` 查看当前 profile
- `:ENProfile embedded` 切换到 `embedded`
- `:ENProfilePick` 选择 profile

切换后会立即应用到当前 Neovim 会话：

- 重新解析 `lazy.nvim` 插件集合
- 注册新 profile 的 lazy-load 触发器
- 对当前 buffer 主动刷新 `FileType`
- 如果新 profile 启用了 `coding`，会加载 LSP 并执行 `:LspStart`

限制：Neovim 运行中已经加载过的插件不能被真正卸载；切到更轻量的 profile 后，新的插件集合和后续 buffer 会按新 profile 运行，但已加载插件的内存状态会保留到退出 Neovim。

## Embedded Profile

`embedded` profile 现在集中在：

```text
lua/envim/profiles/embedded/
```

其中：

- `config.lua`：工具链和任务配置
- `helpers.lua`：OpenOCD / GDB / 终端辅助逻辑
- `plugins.lua`：embedded 专属插件与按键

### Embedded 配置入口

编辑：

```text
lua/envim/profiles/embedded/config.lua
```

默认配置：

```lua
return {
  toolchain = {
    gdb = "arm-none-eabi-gdb",
    openocd = "openocd",
  },
  dap = {
    gdb_target = "localhost:3333",
    openocd_args = {},
    stop_at_entry = false,
  },
  tasks = {
    build = "make",
    flash = nil,
    monitor = nil,
  },
}
```

### Embedded 快捷键

#### CMake

- `<leader>mg`：CMake Generate
- `<leader>mb`：CMake Build
- `<leader>mr`：CMake Run
- `<leader>ms`：选择 CMake build target

#### Make / 任务 / 终端

- `<leader>mm`：打开 Overseer 任务运行器
- `<leader>mt`：切换 Overseer 任务列表
- `<leader>mq`：Overseer Quick Action
- `<C-\\>`：打开/关闭终端
- `<leader>mk`：执行 `tasks.build`
- `<leader>mf`：执行 `tasks.flash`
- `<leader>mi`：执行 `tasks.monitor`
- `<leader>mo`：执行 OpenOCD

#### Debug

- `<F5>`：开始/继续调试
- `<F10>`：Step Over
- `<F11>`：Step Into
- `<F12>`：Step Out
- `<leader>db`：切换断点
- `<leader>dB`：条件断点
- `<leader>du`：切换 DAP UI
- `<leader>dr`：打开 REPL

#### Diagnostics

- `<leader>xx`：Diagnostics
- `<leader>xq`：Quickfix
- `<leader>xs`：Symbols

## 常用快捷键

### 基础

- `jk`：退出插入模式
- `<leader>w`：保存
- `<leader>q`：退出当前窗口

### Explorer / Search

- `<leader>e`：打开文件树
- `<leader>ff`：搜索文件
- `<leader>fg`：全局搜索文本
- `<leader>fw`：搜索当前单词
- `<leader>fb`：搜索已打开 buffer

### Buffer / Tab

- `<Tab>`：切到下一个 buffer
- `<S-Tab>`：切到上一个 buffer
- `<leader>bd`：关闭当前 buffer
- `<leader>to`：新建 tab
- `<leader>tx`：多 tab 时关闭当前 tab；单 tab 时关闭当前 buffer

### LSP

- `gd`：跳转定义
- `gr`：查找引用
- `gi`：跳转实现
- `K`：悬停文档
- `<leader>ca`：Code Action
- `<leader>cr`：Rename
- `<leader>cf`：格式化
- `<leader>co`：打开/关闭代码大纲侧栏（函数/类型/符号）

### Profile / 插件

- `<leader>pp`：选择 profile
- `<leader>pi`：查看 profile 信息
- `<leader>ps`：执行 `:Lazy sync`

### AI（仅 `full` profile）

- `<leader>aa`：打开/关闭 AI Chat
- `<leader>ax`：解释代码
- `<leader>ar`：Review 代码
- `<leader>af`：修复代码

## 如何添加新插件

### 添加通用插件

编辑：

```text
lua/envim/plugins/user.lua
```

### 添加 profile 专属插件

在：

```text
lua/envim/profiles/<profile>/
```

里新增对应模块，并在 `lua/envim/profiles/init.lua` 注册。

## 使用建议

建议使用 **Neovim 0.11+**。

首次启动后：

1. 打开 Neovim
2. 切到 `embedded` profile（如果你要做嵌入式开发）
3. 等待 `lazy.nvim` 自动安装插件
4. 执行 `:Mason`
5. 安装/确认 `clangd`
6. 准备本机工具链：`arm-none-eabi-gdb`、`openocd`、CMake / Make
