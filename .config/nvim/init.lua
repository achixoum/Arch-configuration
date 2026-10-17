vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"

    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })

   if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "failed to clone lazy.nvim:\n", "errormsg" },
            { out, "warningmsg" },
            { "\npress any key to exit..." },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Leader Key
--------------------------------------------------------------------------------
-- Set Space as your leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "


--------------------------------------------------------------------------------
-- Native GUI-style Shift-Arrow Selection
--------------------------------------------------------------------------------
-- 'startsel' allows Shift+Arrows to start a selection
-- 'stopsel' makes any unshifted cursor movement stop the selection
vim.opt.keymodel = "startsel,stopsel"

-- 'select' tells Neovim that Shift-key selection should enter Select mode
-- (so Backspace/Delete or typing immediately replaces the text)
-- 'mouse' ensures mouse drag selection also behaves like a standard editor
vim.opt.selectmode = "key,mouse"

--------------------------------------------------------------------------------
-- Terminal (<C-t>)
--------------------------------------------------------------------------------
-- Opens a terminal in a bottom split and drops straight into terminal input mode
local function toggle_terminal()
  -- Look for an existing terminal buffer to reuse or toggle
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  -- Open a bottom 15-line split if none exists
  vim.cmd("botright 15split | terminal")
  vim.cmd("startinsert")
end

vim.opt.clipboard = "unnamedplus"


--------------------------------------------------------------------------------
-- 2. Ctrl + Shift + Left/Right (Word-by-Word Selection)
--------------------------------------------------------------------------------
-- In Insert mode: trigger Visual selection and jump back/forward a full word
vim.keymap.set("i", "<C-S-Left>",  "<C-o>vb", { desc = "Select previous word" })
vim.keymap.set("i", "<C-S-Right>", "<C-o>ve", { desc = "Select next word" })

-- In Visual mode: continue expanding selection word-by-word
vim.keymap.set("v", "<C-S-Left>",  "b",        { desc = "Expand selection previous word" })
vim.keymap.set("v", "<C-S-Right>", "e",        { desc = "Expand selection next word" })


-------------------------------------------------------------------------------
-- 3. Select All (<C-a>)
--------------------------------------------------------------------------------
-- Select the entire buffer across Normal, Insert, and Visual modes
vim.keymap.set("n", "<C-a>", "ggVG",         { desc = "Select all" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG",    { desc = "Select all" })
vim.keymap.set("v", "<C-a>", "<Esc>ggVG",    { desc = "Select all" })

--------------------------------------------------------------------------------
-- 4. Copy (<C-c>) and Paste (<C-v>)
--------------------------------------------------------------------------------
-- Copy: In Visual mode, yank selection to the system clipboard
vim.keymap.set("v", "<C-c>", '"+y',          { desc = "Copy selection to clipboard" })

-- Paste: In Normal mode, paste after cursor
vim.keymap.set("n", "<C-v>", '"+p',          { desc = "Paste from clipboard" })

-- Paste: In Insert mode, paste directly without exiting insert mode
vim.keymap.set("i", "<C-v>", "<C-r>+",       { desc = "Paste from clipboard" })

vim.keymap.set("n", "<leader>t", toggle_terminal, { desc = "Toggle Terminal" })

-- Paste: In Visual mode, replace selection without overwriting clipboard register
vim.keymap.set("v", "<C-v>", '"_d"+P',       { desc = "Paste over selection" })

vim.keymap.set({ "n", "i", "t" }, "<C-\\>", toggle_terminal, { desc = "Open terminal" })

-- Easy exit from terminal mode back to normal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
--------------------------------------------------------------------------------
-- Save File (<C-s>)
--------------------------------------------------------------------------------
-- Saves the file from Insert mode and returns cursor to Insert mode
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

--------------------------------------------------------------------------------
-- Navigation with Ctrl + Arrows (Insert & Normal Modes)
--------------------------------------------------------------------------------
-- Move by word (Left/Right) and by paragraph/block (Up/Down)
vim.keymap.set("i", "<C-Left>",  "<C-o>b",  { desc = "Jump backward word" })
vim.keymap.set("i", "<C-Right>", "<C-o>w",  { desc = "Jump forward word" })
vim.keymap.set("i", "<C-Up>",    "<C-o>{",  { desc = "Jump paragraph up" })
vim.keymap.set("i", "<C-Down>",  "<C-o>}",  { desc = "Jump paragraph down" })

vim.keymap.set("n", "<C-Left>",  "b",       { desc = "Jump backward word" })
vim.keymap.set("n", "<C-Right>", "w",       { desc = "Jump forward word" })
vim.keymap.set("n", "<C-Up>",    "{",       { desc = "Jump paragraph up" })
vim.keymap.set("n", "<C-Down>",  "}",       { desc = "Jump paragraph down" })

--------------------------------------------------------------------------------
-- GUI-Style Selection with Shift + Arrows (Insert & Select Modes)
--------------------------------------------------------------------------------
-- Select mode behaves like standard editors: typing or pressing Backspace/Delete
-- replaces or deletes the entire highlighted range immediately.

vim.keymap.set("i", "<S-Right>", "<Esc>v<Right>", { desc = "Select right" })
vim.keymap.set("i", "<S-Left>",  "<Esc>v<Left>",  { desc = "Select left" })
vim.keymap.set("i", "<S-Up>",    "<Esc>v<Up>",    { desc = "Select up" })
vim.keymap.set("i", "<S-Down>",  "<Esc>v<Down>",  { desc = "Select down" })

-- Keep expanding while in Visual Mode
vim.keymap.set("v", "<S-Right>", "<Right>")
vim.keymap.set("v", "<S-Left>",  "<Left>")
vim.keymap.set("v", "<S-Up>",    "<Up>")
vim.keymap.set("v", "<S-Down>",  "<Down>")
-- 2. Continue expanding/shrinking the selection while already selecting:
vim.keymap.set("s", "<S-Right>", "<C-o>l",   { desc = "Expand selection right" })
vim.keymap.set("s", "<S-Left>",  "<C-o>h",   { desc = "Expand selection left" })
vim.keymap.set("s", "<S-Down>",  "<C-o>j",   { desc = "Expand selection down" })
vim.keymap.set("s", "<S-Up>",    "<C-o>k",   { desc = "Expand selection up" })

-- Normal mode: undo
vim.keymap.set('n', '<M-z>', 'u', { noremap = true, silent = true, desc = 'Undo last change' })

-- Insert mode: undo and stay in insert mode
vim.keymap.set('i', '<M-z>', '<C-o>u', { noremap = true, silent = true, desc = 'Undo in insert mode' })


-- Lazy.nvim
require("lazy").setup({

    spec = {

        -----------------------------------------------------------
        -- COLORS
        -----------------------------------------------------------

        {
            "nickkadutskyi/jb.nvim",
            lazy = false,
            priority = 1000,

            config = function()
                vim.cmd("colorscheme jb")
            end,
        },


        -----------------------------------------------------------
        -- TELESCOPE
        -----------------------------------------------------------

        {
            "nvim-telescope/telescope.nvim",
            version = "*",

            dependencies = {
                "nvim-lua/plenary.nvim",

                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    build = "make",
                },
            },
        },


        -----------------------------------------------------------
        -- NEO-TREE
        -----------------------------------------------------------

        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            lazy = false,

            dependencies = {
                "nvim-lua/plenary.nvim",
                "muniftanjim/nui.nvim",
                "nvim-tree/nvim-web-devicons",
            },

            opts = {
                window = {
                    mappings = {
                        -- Press 'Y' to copy the absolute file/dir path to system clipboard
                        ["C"] = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.setreg("+", path)
                            vim.notify("Copied full path: " .. path)
                        end,

                        -- Press 'y' to copy just the filename/dirname
                        ["c"] = function(state)
                            local node = state.tree:get_node()
                            local name = node.name
                            vim.fn.setreg("+", name)
                            vim.notify("Copied name: " .. name)
                        end,
                    },
                },
            },
        },


        -----------------------------------------------------------
        -- TREESITTER
        -----------------------------------------------------------

        {
            "nvim-treesitter/nvim-treesitter",

            lazy = false,
            build = ":TSUpdate",

            config = function()

                require("nvim-treesitter").setup({
                    install_dir = vim.fn.stdpath("data") .. "/site",
                })

                require("nvim-treesitter").install({
                    "c",
                    "cpp",
                    "python",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                    "java",
                    "c_sharp",
                })

                vim.api.nvim_create_autocmd("FileType", {

                    pattern = {
                        "c",
                        "cpp",
                        "python",
                        "lua",
                        "vim",
                        "vimdoc",
                        "query",
                        "markdown",
                        "java",
                        "cs",
                    },

                    callback = function(args)
                        vim.treesitter.start(args.buf)
                    end,
                })
            end,
        },


        -----------------------------------------------------------
        -- MASON
        -----------------------------------------------------------

        {
            "mason-org/mason.nvim",

            config = function()
                require("mason").setup()
            end,
        },


        -----------------------------------------------------------
        -- MASON + LSPCONFIG
        -----------------------------------------------------------

        {
            "mason-org/mason-lspconfig.nvim",

            dependencies = {
                "mason-org/mason.nvim",
                "neovim/nvim-lspconfig",
            },

            config = function()

                require("mason-lspconfig").setup({
                    ensure_installed = {
                        "clangd",
                        "pyright",
                        "lua_ls",
                    },
                })

            end,
        },


        -----------------------------------------------------------
        -- LSPCONFIG
        -----------------------------------------------------------

        {
            "neovim/nvim-lspconfig",

            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
            },

            config = function()

                local capabilities =
                    require("cmp_nvim_lsp").default_capabilities()


                -- C / C++
                vim.lsp.config("clangd", {
                    capabilities = capabilities,
                })


                -- Python
                vim.lsp.config("pyright", {
                    capabilities = capabilities,
                })


                -- Lua
                vim.lsp.config("lua_ls", {
                    capabilities = capabilities,
                })


                -- Enable language servers
                vim.lsp.enable({
                    "clangd",
                    "pyright",
                    "lua_ls",
                })

            end,
        },


        -----------------------------------------------------------
        -- AUTOCOMPLETION
        -----------------------------------------------------------

        {
            "hrsh7th/nvim-cmp",

            dependencies = {

                "hrsh7th/cmp-nvim-lsp",

                "L3MON4D3/LuaSnip",

                "saadparwaiz1/cmp_luasnip",
            },

            config = function()

                local cmp = require("cmp")
                local luasnip = require("luasnip")


                cmp.setup({

                    snippet = {

                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },


                    mapping = cmp.mapping.preset.insert({

                        ["<C-Space>"] =
                            cmp.mapping.complete(),

                        ["<CR>"] =
                            cmp.mapping.confirm({
                                select = true,
                            }),

                        ["<Tab>"] =
                            cmp.mapping.select_next_item(),

                        ["<S-Tab>"] =
                            cmp.mapping.select_prev_item(),
                    }),


                    sources = {

                        {
                            name = "nvim_lsp",
                        },

                        {
                            name = "luasnip",
                        },
                    },
                })

            end,
        },

    },


    -----------------------------------------------------------
    -- LAZY OPTIONS
    -----------------------------------------------------------

    install = {
        colorscheme = {
            "jb",
        },
    },

    checker = {
        enabled = true,
    },
})


---------------------------------------------------------------
-- TELESCOPE KEYBINDS
---------------------------------------------------------------

local builtin = require("telescope.builtin")

vim.keymap.set(
    "n",
    "<C-l>",
    builtin.find_files,
    {}
)

vim.keymap.set(
    "n",
    "<leader>fg",
    builtin.live_grep,
    {
        desc = "Telescope live grep",
    }
)


---------------------------------------------------------------
-- NEO-TREE KEYBINDS
---------------------------------------------------------------

vim.keymap.set(
    "n",
    "<C-t>",
    "<cmd>Neotree toggle<CR>",
    {
        desc = "Toggle Neo-tree",
    }
)

vim.keymap.set(
    "n",
    "<leader>f",
    "<cmd>Neotree focus<CR>",
    {
        desc = "Focus Neo-tree",
    }
)


---------------------------------------------------------------
-- GENERAL KEYBINDS
---------------------------------------------------------------

vim.keymap.set(
    "n",
    "<leader>w",
    "<cmd>w<CR>",
    {
        desc = "Save file",
    }
)

vim.keymap.set(
    "n",
    "<leader>q",
    "<cmd>q<CR>",
    {
        desc = "Quit file",
    }
)

