--------------------------------------------------------------------------------
-- 1. CORE SETTINGS
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.clipboard:append('unnamedplus')
vim.opt.wrap = false
vim.opt.laststatus = 2
vim.opt.scrolloff = 8
vim.opt.updatetime = 250

vim.opt.shortmess:append("IsI")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true

--------------------------------------------------------------------------------
-- 2. BOOTSTRAP LAZY.NVIM
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- 3. PLUGINS
--------------------------------------------------------------------------------
require("lazy").setup({
    -- THEME
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("tokyonight-night") end },
    
    -- STATUS BAR (ICONS ENABLED)
    { 
        "nvim-lualine/lualine.nvim", 
        dependencies = { "nvim-tree/nvim-web-devicons" }, 
        config = function() 
            require("lualine").setup({ 
                options = { 
                    theme = "tokyonight",
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = { 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches' },
                } 
            }) 
        end 
    },

    -- FILE TREE
    { 
        "nvim-neo-tree/neo-tree.nvim", 
        branch = "v3.x", 
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" }, 
        config = function()
            vim.keymap.set('n', '<leader>t', ':Neotree toggle<CR>', { silent = true })
        end 
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local status, configs = pcall(require, "nvim-treesitter.configs")
            if not status then configs = require("nvim-treesitter.config") end
            configs.setup({
                ensure_installed = { "c", "cpp", "python", "lua", "bash", "markdown" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- LSP CONFIGURATION (Updated for Neovim 0.11 native API)
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            
            -- Native Enable calls
            vim.lsp.enable('clangd')
            vim.lsp.enable('pyright')

            -- Server Configurations
            vim.lsp.config('clangd', { 
                capabilities = capabilities, 
                cmd = { 
                    "clangd", 
                    "--background-index", 
                    "--clang-tidy",
                    "--compile-commands-dir=build" -- Ensures clangd finds CMake/Bear output
                } 
            })
            
            vim.lsp.config('pyright', { capabilities = capabilities })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                end,
            })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                        else fallback() end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" }, { name = "path" } }),
            })
        end,
    },

    -- TELESCOPE (Updated with Ignore Patterns)
    { 
        "nvim-telescope/telescope.nvim", 
        -- branch = "0.1.x", 
        dependencies = { "nvim-lua/plenary.nvim" }, 
        config = function()
            local builtin = require("telescope.builtin")
            
            require("telescope").setup({
                defaults = {
                    -- Ignores build artifacts and binaries to keep searches clean
                    file_ignore_patterns = { "build/.*", "%.o", "%.out", "%.appimage", "node_modules/" },
                    path_display = { "truncate" },
                }
            })

            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope Find Files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Telescope Live Grep" })
            -- NEW: Search only inside the file you are currently editing
            vim.keymap.set('n', '<leader>fb', builtin.current_buffer_fuzzy_find, { desc = "Find in Current Buffer" })
        end 
    },

    { "stevearc/conform.nvim", config = function()
        require("conform").setup({
            formatters_by_ft = { cpp = { "clang-format" }, c = { "clang-format" }, python = { "black" } },
            format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
        })
    end },
    
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    -- GIT SIGNS
    { 
        "lewis6991/gitsigns.nvim", 
        config = function()
            require('gitsigns').setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation between changes
                    map('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, {expr=true, desc = "Next Hunk"})

                    map('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, {expr=true, desc = "Prev Hunk"})

                    -- Actions
                    map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage Hunk" })
                    map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset Hunk" })
                    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage Selected Lines" })
                    map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview Hunk" })
                    map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = "Git Blame Line" })
                end
            })
        end 
    },

    -- GIT DIFF
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>', { desc = "Git Diff View" })
            vim.keymap.set('n', '<leader>gx', ':DiffviewClose<CR>', { desc = "Close Diff View" })
        end
    },

    -- Neogit : A visual GIT
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local neogit = require("neogit")
            neogit.setup({
                integrations = { diffview = true }, -- Connects Neogit to your Diffview plugin
                kind = "floating", -- Opens Neogit in a floating window over your code
            })
            vim.keymap.set("n", "<leader>gn", neogit.open, { desc = "Neogit Status" })
        end
    },
    -- SESSION MANAGEMENT
    {
        "stevearc/resession.nvim",
        config = function()
            local resession = require("resession")
            resession.setup()

            vim.keymap.set("n", "<leader>ss", resession.save, { desc = "Save Session" })
            vim.keymap.set("n", "<leader>sl", resession.load, { desc = "Load Session" })

            vim.api.nvim_create_autocmd("VimLeavePre", {
                callback = function()
                    resession.save("last", { dir = "session", notify = false })
                end,
            })

            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    if vim.fn.argc() == 0 then
                        resession.load("last", { dir = "session", silence_errors = true })
                    end
                end,
            })
        end,
    },
    -- DEBUGGER
    {
        "mfussenegger/nvim-dap",
        dependencies = { 
            "rcarriga/nvim-dap-ui", 
            "nvim-neotest/nvim-nio", 
            "mfussenegger/nvim-dap-python",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            require("mason").setup()
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.35 },
                            { id = "stacks", size = 0.35 },
                            { id = "breakpoints", size = 0.15 },
                            { id = "watches", size = 0.15 },
                        },
                        size = 30,
                        position = "left",
                    },
                    {
                        elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
                        size = 8,
                        position = "bottom",
                    },
                },
            })

            local cmd = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/codelldb"
            dap.adapters.codelldb = {
                type = 'server',
                port = "${port}",
                executable = { command = cmd, args = {"--port", "${port}"} }
            }

            require('dap-python').setup('/home/mundo/.local/pipx/venvs/debugpy/bin/python')

            dap.configurations.cpp = {
                {
                    name = "Launch",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local exe = vim.fn.getcwd() .. '/' .. vim.fn.expand('%:t:r')
                        return vim.fn.executable(exe) == 1 and exe or vim.fn.input('Path: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }
            dap.configurations.c = dap.configurations.cpp

            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
            
            vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
            vim.keymap.set('n', '<leader>dc', dap.continue)
            vim.keymap.set('n', '<leader>dx', dapui.toggle)
        end,
    },
}, { rocks = { enabled = false, hererocks = false } })

--------------------------------------------------------------------------------
-- 4. CUSTOM KEYBINDINGS
--------------------------------------------------------------------------------
-- Fast Compile/Run for single files
vim.keymap.set('n', '<leader>r', ':w<CR>:!g++ -g % -o %< && ./%<<CR>', { desc = "C++ Run" })
vim.keymap.set('n', '<leader>p', ':w<CR>:!python3 %<CR>', { desc = "Python Run" })
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })
vim.keymap.set('n', '<leader>dq', function() require("dap").terminate() require("dapui").close() end, { desc = "Debug Quit" })

-- Shortcut to quickly edit this config file
vim.keymap.set('n', '<leader>ev', ':edit $MYVIMRC<CR>', { desc = "Edit Neovim Config" })

