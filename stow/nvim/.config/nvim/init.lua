-- ==============================================================================
-- Ricezisto - Minimalist Catppuccin Mocha Mauve Neovim Configuration
-- ==============================================================================

-- 1. Líder Global
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 2. Opções Gerais e Ergonomia
local opt = vim.opt

opt.number = true               -- Número de linha absoluto na linha atual
opt.relativenumber = true       -- Números relativos para saltos rápidos (j/k)
opt.mouse = 'a'                 -- Suporte completo a mouse e scroll
opt.clipboard = 'unnamedplus'   -- Integração com clipboard do sistema (Wayland/wl-copy)

opt.tabstop = 4                 -- Tabulação de 4 espaços
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true            -- Converter tabs em espaços
opt.smartindent = true
opt.autoindent = true
opt.wrap = false                -- Não quebrar linhas automaticamente

opt.ignorecase = true           -- Busca insensível a maiúsculas/minúsculas...
opt.smartcase = true            -- ...exceto se contiver letras maiúsculas
opt.hlsearch = true             -- Destacar resultados da busca
opt.incsearch = true            -- Busca incremental

opt.termguicolors = true        -- Truecolor (24-bit) no terminal Kitty
opt.cursorline = true           -- Destacar linha atual
opt.signcolumn = 'yes'          -- Coluna fixa para sinais/diagnósticos
opt.scrolloff = 8               -- Margem mínima de linhas acima/abaixo ao rolar

opt.splitright = true           -- Novos splits verticais abrem à direita
opt.splitbelow = true           -- Novos splits horizontais abrem abaixo
opt.undofile = true             -- Histórico de desfazer persistente em disco
opt.updatetime = 250            -- Resposta rápida para eventos e updates

-- 3. Paleta Catppuccin Mocha Mauve (Built-in Truecolor Highlight Groups)
local c = {
    base     = '#1e1e2e',
    mantle   = '#181825',
    crust    = '#11111b',
    text     = '#cdd6f4',
    subtext1 = '#bac2de',
    subtext0 = '#a6adc8',
    overlay2 = '#9399b2',
    overlay1 = '#7f849c',
    overlay0 = '#6c7086',
    surface2 = '#585b70',
    surface1 = '#45475a',
    surface0 = '#313244',
    mauve    = '#cba6f7',
    pink     = '#f5c2e7',
    red      = '#f38ba8',
    peach    = '#fab387',
    yellow   = '#f9e2af',
    green    = '#a6e3a1',
    teal     = '#94e2d5',
    sapphire = '#74c7ec',
    blue     = '#89b4fa',
    lavender = '#b4befe',
}

local hl = vim.api.nvim_set_hl

-- Editor & Janelas
hl(0, 'Normal',       { fg = c.text, bg = c.base })
hl(0, 'NormalFloat',  { fg = c.text, bg = c.mantle })
hl(0, 'FloatBorder',  { fg = c.mauve, bg = c.mantle })
hl(0, 'CursorLine',   { bg = c.surface0 })
hl(0, 'CursorLineNr', { fg = c.mauve, bold = true })
hl(0, 'LineNr',       { fg = c.surface2 })
hl(0, 'Visual',       { bg = c.surface1 })
hl(0, 'WinSeparator', { fg = c.surface0 })
hl(0, 'VertSplit',    { fg = c.surface0 })
hl(0, 'SignColumn',   { bg = c.base })

-- Busca & Seleção
hl(0, 'Search',       { fg = c.crust, bg = c.yellow })
hl(0, 'IncSearch',    { fg = c.crust, bg = c.mauve })
hl(0, 'MatchParen',   { fg = c.mauve, bold = true, underline = true })

-- Menus de Autocompletar (Popup)
hl(0, 'Pmenu',        { fg = c.text, bg = c.mantle })
hl(0, 'PmenuSel',     { fg = c.crust, bg = c.mauve, bold = true })
hl(0, 'PmenuSbar',    { bg = c.surface0 })
hl(0, 'PmenuThumb',   { bg = c.overlay0 })

-- Sintaxe
hl(0, 'Comment',      { fg = c.overlay0, italic = true })
hl(0, 'Constant',     { fg = c.peach })
hl(0, 'String',       { fg = c.green })
hl(0, 'Character',    { fg = c.teal })
hl(0, 'Number',       { fg = c.peach })
hl(0, 'Boolean',      { fg = c.peach, bold = true })
hl(0, 'Float',        { fg = c.peach })
hl(0, 'Identifier',   { fg = c.sapphire })
hl(0, 'Function',     { fg = c.blue, bold = true })
hl(0, 'Statement',    { fg = c.mauve })
hl(0, 'Conditional',  { fg = c.mauve })
hl(0, 'Repeat',       { fg = c.mauve })
hl(0, 'Operator',     { fg = c.sapphire })
hl(0, 'Keyword',      { fg = c.mauve, italic = true })
hl(0, 'PreProc',      { fg = c.pink })
hl(0, 'Type',         { fg = c.yellow, bold = true })
hl(0, 'Special',      { fg = c.pink })
hl(0, 'Directory',    { fg = c.blue })
hl(0, 'Title',        { fg = c.mauve, bold = true })
hl(0, 'Error',        { fg = c.red, bold = true })
hl(0, 'ErrorMsg',     { fg = c.red })
hl(0, 'WarningMsg',   { fg = c.yellow })

-- Barra de Status (Statusline Minimalista & Rápida)
hl(0, 'StatusLine',   { fg = c.text, bg = c.mantle })
hl(0, 'StatusLineNC', { fg = c.surface2, bg = c.crust })
hl(0, 'StatusMode',   { fg = c.crust, bg = c.mauve, bold = true })

local mode_map = {
    ['n']  = 'NORMAL',
    ['i']  = 'INSERT',
    ['v']  = 'VISUAL',
    ['V']  = 'V-LINE',
    ['\22'] = 'V-BLOCK',
    ['c']  = 'COMMAND',
    ['R']  = 'REPLACE',
    ['t']  = 'TERMINAL',
}

_G.ricezisto_statusline = function()
    local mode = mode_map[vim.api.nvim_get_mode().mode] or 'NORMAL'
    local file = vim.fn.expand('%:t')
    if file == '' then file = '[Sem Nome]' end
    local modified = vim.bo.modified and ' 󰆓' or ''
    local readonly = vim.bo.readonly and ' 󰌾' or ''
    local line_col = ' %l:%c '
    return string.format('%%#StatusMode# %s %%#StatusLine#  %s%s%s %%=%%#StatusMode#%s', mode, file, modified, readonly, line_col)
end

opt.statusline = '%!v:lua.ricezisto_statusline()'

-- 4. Atalhos Ergonômicos (Keymaps)
local map = vim.keymap.set

-- Salvar e Sair rápidos com Leader (Barra de Espaço)
map('n', '<leader>w', '<cmd>w<cr>', { desc = 'Salvar arquivo' })
map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Fechar janela' })
map('n', '<leader>x', '<cmd>wq<cr>', { desc = 'Salvar e sair' })
map('n', '<leader>c', '<cmd>bd<cr>', { desc = 'Fechar buffer' })

-- Limpar destaque de busca com Escape
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Limpar highlight de busca' })

-- Mover linhas selecionadas no modo Visual
map('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Mover bloco para baixo' })
map('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Mover bloco para cima' })

-- Manter cursor centralizado ao rolar metade da página
map('n', '<C-d>', '<C-d>zz', { desc = 'Rolar para baixo centralizado' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Rolar para cima centralizado' })

-- Navegação intuitiva entre splits com Ctrl + h/j/k/l
map('n', '<C-h>', '<C-w>h', { desc = 'Focar janela esquerda' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focar janela inferior' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focar janela superior' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focar janela direita' })

-- Sair do modo terminal com Escape
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Sair do terminal para modo normal' })
