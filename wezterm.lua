local wezterm = require 'wezterm'
local act     = wezterm.action

-- 1. 按需改下面 4 个路径
local GIT_BASH   = 'C:/Program Files/Git/bin/bash.exe'
local BG_PIC     = 'terminal.png'
local WSL_DISTRO = 'Ubuntu'
local MSYS2_ROOT = 'C:/msys64/'          -- ← 改这里

local is_windows = wezterm.target_triple:match('windows')
local function norm(p) return (p:gsub('\\','/')) end

-- 2. 生成配置快照
local config = wezterm.config_builder()

-- 3. 外观（你原来的）
config.color_scheme               = 'Tokyo Night'
config.window_decorations         = 'INTEGRATED_BUTTONS|RESIZE'
config.initial_cols               = 110
config.initial_rows               = 30
config.font_size                  = 14.0
config.font                       = wezterm.font_with_fallback {
  { family = 'JetBrainsMono NF', weight = 'Medium' },
  { family = 'HarmonyOS Sans SC', weight = 'Medium' },
}
config.window_background_opacity  = 0.9
config.window_close_confirmation  = 'NeverPrompt'
config.background = {
  {
    source = { File = norm(BG_PIC) },
    hsb    = { hue = 1.0, saturation = 1.0, brightness = 0.3 },
  },
}

-- 4. 默认 Shell（想用 MSYS2 就解开注释）
-- config.default_prog = { 'msys2_shell.cmd', '-defterm', '-here', '-no-start', '-mingw64' }

-- 5. 启动菜单：Git-Bash / PowerShell / CMD / WSL / MSYS2 三环境
config.launch_menu = is_windows and {
  { label = 'Git-Bash',   args = { norm(GIT_BASH) } },
  { label = 'PowerShell', args = { 'powershell.exe' } },
  { label = 'CMD',        args = { 'cmd.exe' } },
  { label = 'WSL ('..WSL_DISTRO..')', args = { 'wsl.exe','-d',WSL_DISTRO } },

  -- MSYS2 系列（官方启动脚本 msys2_shell.cmd）
  { label = 'MSYS2 MINGW64',
    args = { MSYS2_ROOT..'msys2_shell.cmd', '-defterm', '-here', '-no-start', '-mingw64' } },
  { label = 'MSYS2 MINGW32',
    args = { MSYS2_ROOT..'msys2_shell.cmd', '-defterm', '-here', '-no-start', '-mingw32' } },
  { label = 'MSYS2 UCRT64',
    args = { MSYS2_ROOT..'msys2_shell.cmd', '-defterm', '-here', '-no-start', '-ucrt64' } },
} or {
  { label = 'zsh',  args = { '/bin/zsh' } },
  { label = 'bash', args = { '/bin/bash' } },
}

-- 6. 快捷键（你原来的）
config.keys = {
  { key = 'p', mods = 'CTRL', action = act.ShowLauncherArgs{ flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
  { key = '+', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
  { key = '_', mods = 'CTRL|SHIFT', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL|SHIFT', action = act.ResetFontSize },
  { key = 't', mods = 'CTRL', action = act.ShowLauncher },
  { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = false } },
  { key = 'UpArrow',   mods = 'CTRL|SHIFT', action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.SplitVertical  { domain = 'CurrentPaneDomain' } },
}

-- 7. 性能 & 体验（你原来的）
config.front_end         = 'WebGpu'
config.max_fps           = 60
config.scrollback_lines  = 30000
config.enable_scroll_bar = true

return config