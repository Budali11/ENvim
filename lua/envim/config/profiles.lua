return {
  default = {
    label = "Default",
    desc = "日常开发：UI、搜索、文件树、LSP、语法高亮",
    features = { "ui", "coding" },
  },
  embedded = {
    label = "Embedded",
    desc = "嵌入式 C/C++：clangd、CMake/Make、DAP、终端任务",
    features = { "ui", "coding", "embedded" },
  },
  minimal = {
    label = "Minimal",
    desc = "轻量模式：只保留核心 UI / 搜索 / 文件管理",
    features = { "ui" },
  },
  full = {
    label = "Full",
    desc = "完整模式：在 default 基础上启用 AI Coding",
    features = { "ui", "coding", "ai" },
  },
  writing = {
    label = "Writing",
    desc = "写作/笔记模式：关闭 LSP 和 AI，保留基础体验",
    features = { "ui" },
  },
}
