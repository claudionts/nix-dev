{
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      curl
      ripgrep
      fd
      nodejs
      tree-sitter
      gcc
      gnumake
    ];
    
    extraLuaConfig = ''
      -- ============================================================================
      -- CONFIGURAÇÃO MODERNA DO NEOVIM COM LUA NATIVO
      -- ============================================================================

      -- Configurações básicas do Vim
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Configurações de opções
      local opt = vim.opt
      local g = vim.g

      -- Aparência
      opt.number = true
      opt.relativenumber = true
      opt.cursorline = true
      opt.termguicolors = true
      opt.background = "dark"
      opt.signcolumn = "yes"
      opt.colorcolumn = "80"
      opt.scrolloff = 8
      opt.sidescrolloff = 8

      -- Comportamento
      opt.clipboard = "unnamedplus"
      opt.swapfile = false
      opt.backup = false
      opt.undofile = true
      opt.undolevels = 10000
      opt.history = 10000
      opt.updatetime = 300
      opt.timeoutlen = 500
      opt.ttimeoutlen = 10

      -- Busca
      opt.ignorecase = true
      opt.smartcase = true
      opt.hlsearch = true
      opt.incsearch = true

      -- Indentação
      opt.autoindent = true
      opt.smartindent = true
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.expandtab = true
      opt.softtabstop = 2

      -- Interface
      opt.showmode = false
      opt.showcmd = true
      opt.cmdheight = 1
      opt.laststatus = 3
      opt.wrap = false
      opt.linebreak = true
      opt.breakindent = true

      -- Splits
      opt.splitbelow = true
      opt.splitright = true

      -- Filetypes
      vim.filetype.add({
        extension = {
          flow = 'json',
          eex = 'elixir',
          heex = 'elixir',
        },
        pattern = {
          ['.*%.ex$'] = 'elixir',
          ['.*%.exs$'] = 'elixir',
          ['.*%.eex$'] = 'elixir',
          ['.*%.heex$'] = 'elixir',
        },
      })

      -- Configurações globais
      g.markdown_fenced_languages = {
        "python", "elixir", "bash", "dockerfile", "sh=bash", "javascript", "typescript"
      }

      -- Keymaps básicos
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Limpar busca
      keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
      keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

      -- Navegação melhorada
      keymap("n", "<C-d>", "<C-d>zz", opts)
      keymap("n", "<C-u>", "<C-u>zz", opts)
      keymap("n", "n", "nzzzv", opts)
      keymap("n", "N", "Nzzzv", opts)

      -- Movimentação entre janelas
      keymap("n", "<C-h>", "<C-w>h", opts)
      keymap("n", "<C-j>", "<C-w>j", opts)
      keymap("n", "<C-k>", "<C-w>k", opts)
      keymap("n", "<C-l>", "<C-w>l", opts)

      -- Redimensionar janelas
      keymap("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
      keymap("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
      keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
      keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

      -- Mover linhas
      keymap("n", "<A-j>", "<cmd>m .+1<CR>==", opts)
      keymap("n", "<A-k>", "<cmd>m .-2<CR>==", opts)
      keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
      keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

      -- Preservar clipboard ao colar
      keymap("v", "p", '"_dP', opts)

      -- Seleção visual melhorada
      keymap("v", "<", "<gv", opts)
      keymap("v", ">", ">gv", opts)

      -- Salvar e sair
      keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
      keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
      keymap("n", "<leader>x", "<cmd>x<CR>", { desc = "Save and quit" })

      -- Buffer navigation
      keymap("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
      keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
      keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

      -- Terminal
      keymap("t", "<Esc>", "<C-\\><C-n>", opts)
      keymap("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })

      -- ============================================================================
      -- CONFIGURAÇÃO DO LAZY.NVIM
      -- ============================================================================
      
      -- Instalar Lazy.nvim se não estiver instalado
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        -- ============================================================================
        -- PLUGINS DE APARÊNCIA
        -- ============================================================================
        
        -- Tema moderno
        {
          "catppuccin/nvim",
          name = "catppuccin",
          priority = 1000,
          config = function()
            require("catppuccin").setup({
              flavour = "mocha",
              transparent_background = false,
              show_end_of_buffer = false,
              term_colors = false,
              dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
              },
              no_italic = false,
              no_bold = false,
              no_underline = false,
              styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
              },
              color_overrides = {},
              custom_highlights = {},
              integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                notify = false,
                mini = false,
                treesitter = true,
                mason = true,
                lsp_trouble = true,
                which_key = true,
              },
            })
            vim.cmd.colorscheme("catppuccin")
          end,
        },

        -- Statusline
        {
          "nvim-lualine/lualine.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require("lualine").setup({
              options = {
                theme = "catppuccin",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
              },
              sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
              },
            })
          end,
        },

        -- Bufferline
        {
          "akinsho/bufferline.nvim",
          version = "*",
          dependencies = "nvim-tree/nvim-web-devicons",
          config = function()
            require("bufferline").setup({
              options = {
                mode = "buffers",
                themable = true,
                numbers = "none",
                close_command = "bdelete! %d",
                right_mouse_command = "bdelete! %d",
                left_mouse_command = "buffer %d",
                middle_mouse_command = nil,
                indicator = {
                  icon = "▎",
                  style = "icon",
                },
                buffer_close_icon = "󰅖",
                modified_icon = "●",
                close_icon = "󰅖",
                left_trunc_marker = "󰅂",
                right_trunc_marker = "󰅃",
                max_name_length = 30,
                max_prefix_length = 30,
                tab_size = 21,
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = false,
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                  local icon = level:match("error") and "󰅚 " or "󰀪 "
                  return " " .. icon .. count
                end,
                offsets = {
                  {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "left",
                    separator = true,
                  },
                },
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_close_icon = true,
                show_tab_indicators = true,
                persist_buffer_sort = true,
                separator_style = "thin",
                enforce_regular_tabs = false,
                always_show_bufferline = true,
                sort_by = "insert_after_current",
              },
            })
          end,
        },

        -- Indent guides
        {
          "lukas-reineke/indent-blankline.nvim",
          main = "ibl",
          config = function()
            require("ibl").setup({
              indent = {
                char = "│",
                tab_char = "│",
              },
              scope = {
                enabled = false,
              },
              exclude = {
                filetypes = {
                  "help",
                  "alpha",
                  "dashboard",
                  "neo-tree",
                  "Trouble",
                  "lazy",
                  "mason",
                },
              },
            })
          end,
        },

        -- ============================================================================
        -- PLUGINS DE FUNCIONALIDADE
        -- ============================================================================

        -- LSP e Mason
        {
          "williamboman/mason.nvim",
          config = function()
            require("mason").setup({
              ui = {
                border = "rounded",
                icons = {
                  package_installed = "✓",
                  package_pending = "➜",
                  package_uninstalled = "✗",
                },
              },
            })
          end,
        },

        {
          "williamboman/mason-lspconfig.nvim",
          dependencies = { "williamboman/mason.nvim" },
          config = function()
            require("mason-lspconfig").setup({
              ensure_installed = {
                "lua_ls",
                "elixirls",
                "lexical",
                "tsserver",
                "jsonls",
                "html",
                "cssls",
                "tailwindcss",
                "pyright",
                "rust_analyzer",
              },
              automatic_installation = true,
            })
          end,
        },

        {
          "neovim/nvim-lspconfig",
          dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "folke/neodev.nvim",
          },
          config = function()
            local lspconfig = require("lspconfig")
            local cmp_lsp = require("cmp_nvim_lsp")

            -- Configuração global do LSP
            local on_attach = function(client, bufnr)
              local opts = { noremap = true, silent = true, buffer = bufnr }
              
              -- Keymaps do LSP
              keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = bufnr })
              keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
              keymap("n", "K", vim.lsp.buf.hover, { desc = "Show hover", buffer = bufnr })
              keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation", buffer = bufnr })
              keymap("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help", buffer = bufnr })
              keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder", buffer = bufnr })
              keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder", buffer = bufnr })
              keymap("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, { desc = "List workspace folders", buffer = bufnr })
              keymap("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Go to type definition", buffer = bufnr })
              keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
              keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action", buffer = bufnr })
              keymap("n", "gr", vim.lsp.buf.references, { desc = "Show references", buffer = bufnr })
              keymap("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
              end, { desc = "Format", buffer = bufnr })
            end

            -- Configuração de capabilities
            local capabilities = cmp_lsp.default_capabilities()

            -- Lua LSP
            lspconfig.lua_ls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                },
              },
            })

            -- Elixir LSP (Lexical)
            local expert_cmd = vim.fn.expand("~/.local/bin/expert")
            lspconfig.lexical.setup({
              cmd = { expert_cmd },
              root_dir = function(fname)
                return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
              end,
              filetypes = { "elixir", "eelixir", "heex" },
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {},
            })

            -- TypeScript LSP
            lspconfig.tsserver.setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })

            -- JSON LSP
            lspconfig.jsonls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })

            -- HTML LSP
            lspconfig.html.setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })

            -- CSS LSP
            lspconfig.cssls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })

            -- Python LSP
            lspconfig.pyright.setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
        },

        -- Autocompletar
        {
          "hrsh7th/nvim-cmp",
          dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
          },
          config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
              snippet = {
                expand = function(args)
                  luasnip.lsp_expand(args.body)
                end,
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  else
                    fallback()
                  end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
              }),
              sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
              }, {
                { name = "buffer" },
                { name = "path" },
              }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
              mapping = cmp.mapping.preset.cmdline(),
              sources = {
                { name = "buffer" },
              },
            })

            cmp.setup.cmdline(":", {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                { name = "path" },
              }, {
                { name = "cmdline" },
              }),
            })
          end,
        },

        -- Treesitter
        {
          "nvim-treesitter/nvim-treesitter",
          build = ":TSUpdate",
          config = function()
            require("nvim-treesitter.configs").setup({
              ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "elixir",
                "eex",
                "heex",
                "javascript",
                "typescript",
                "html",
                "css",
                "json",
                "yaml",
                "toml",
                "python",
                "rust",
                "bash",
                "dockerfile",
                "gitignore",
                "markdown",
                "markdown_inline",
              },
              sync_install = false,
              auto_install = true,
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
              indent = {
                enable = true,
              },
              incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection = "<C-space>",
                  node_incremental = "<C-space>",
                  scope_incremental = "<C-s>",
                  node_decremental = "<C-backspace>",
                },
              },
              textobjects = {
                select = {
                  enable = true,
                  lookahead = true,
                  keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                  },
                },
                move = {
                  enable = true,
                  set_jumps = true,
                  goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                  },
                  goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                  },
                  goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                  },
                  goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                  },
                },
              },
            })
          end,
        },

        -- Telescope
        {
          "nvim-telescope/telescope.nvim",
          tag = "0.1.6",
          dependencies = { "nvim-lua/plenary.nvim" },
          config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({
              defaults = {
                vimgrep_arguments = {
                  "rg",
                  "--color=never",
                  "--no-heading",
                  "--with-filename",
                  "--line-number",
                  "--column",
                  "--smart-case",
                  "--hidden",
                  "--glob=!.git",
                },
                prompt_prefix = "  ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                  horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                  },
                  vertical = {
                    mirror = false,
                  },
                  width = 0.87,
                  height = 0.80,
                  preview_cutoff = 120,
                },
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                file_ignore_patterns = { "node_modules" },
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                path_display = { "truncate" },
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                use_less = true,
                set_env = { ["COLORTERM"] = "truecolor" },
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                mappings = {
                  i = {
                    ["<C-n>"] = require("telescope.actions").cycle_history_next,
                    ["<C-p>"] = require("telescope.actions").cycle_history_prev,
                    ["<C-j>"] = require("telescope.actions").move_selection_next,
                    ["<C-k>"] = require("telescope.actions").move_selection_previous,
                    ["<C-c>"] = require("telescope.actions").close,
                    ["<Down>"] = require("telescope.actions").move_selection_next,
                    ["<Up>"] = require("telescope.actions").move_selection_previous,
                    ["<CR>"] = require("telescope.actions").selected_entry,
                    ["<C-x>"] = require("telescope.actions").select_horizontal,
                    ["<C-v>"] = require("telescope.actions").select_vertical,
                    ["<C-t>"] = require("telescope.actions").select_tab,
                    ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
                    ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
                    ["<PageUp>"] = require("telescope.actions").results_scrolling_up,
                    ["<PageDown>"] = require("telescope.actions").results_scrolling_down,
                    ["<Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_worse,
                    ["<S-Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_better,
                    ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
                    ["<M-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
                    ["<C-l>"] = require("telescope.actions").complete_tag,
                    ["<C-_>"] = require("telescope.actions").which_key,
                  },
                  n = {
                    ["<esc>"] = require("telescope.actions").close,
                    ["<CR>"] = require("telescope.actions").selected_entry,
                    ["<C-x>"] = require("telescope.actions").select_horizontal,
                    ["<C-v>"] = require("telescope.actions").select_vertical,
                    ["<C-t>"] = require("telescope.actions").select_tab,
                    ["<Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_worse,
                    ["<S-Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_better,
                    ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
                    ["<M-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
                    ["j"] = require("telescope.actions").move_selection_next,
                    ["k"] = require("telescope.actions").move_selection_previous,
                    ["H"] = require("telescope.actions").move_to_top,
                    ["M"] = require("telescope.actions").move_to_middle,
                    ["L"] = require("telescope.actions").move_to_bottom,
                    ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
                    ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
                    ["<PageUp>"] = require("telescope.actions").results_scrolling_up,
                    ["<PageDown>"] = require("telescope.actions").results_scrolling_down,
                    ["?"] = require("telescope.actions").which_key,
                  },
                },
              },
              pickers = {
                find_files = {
                  hidden = true,
                },
              },
              extensions = {
                fzf = {
                  fuzzy = true,
                  override_generic_sorter = true,
                  override_file_sorter = true,
                  case_mode = "smart_case",
                },
              },
            })

            -- Keymaps do Telescope
            keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
            keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
            keymap("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
            keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
            keymap("n", "<leader>fc", builtin.commands, { desc = "Find commands" })
            keymap("n", "<leader>fq", builtin.quickfix, { desc = "Find quickfix" })
            keymap("n", "<leader>fl", builtin.loclist, { desc = "Find location list" })
            keymap("n", "<leader>fgs", builtin.git_status, { desc = "Find git status" })
            keymap("n", "<leader>fgb", builtin.git_branches, { desc = "Find git branches" })
            keymap("n", "<leader>fgc", builtin.git_commits, { desc = "Find git commits" })
            keymap("n", "<leader>fgt", builtin.git_stash, { desc = "Find git stash" })
          end,
        },

        -- File explorer
        {
          "nvim-tree/nvim-tree.lua",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require("nvim-tree").setup({
              sort_by = "case_sensitive",
              view = {
                width = 30,
                side = "left",
                preserve_window_proportions = true,
                number = false,
                relativenumber = false,
                signcolumn = "yes",
                mappings = {
                  list = {
                    { key = "u", action = "dir_up" },
                    { key = "o", action = "system_open" },
                  },
                },
              },
              renderer = {
                group_empty = true,
              },
              filters = {
                dotfiles = true,
              },
              git = {
                enable = true,
                ignore = false,
                show_on_dirs = true,
                show_on_open_dirs = true,
                timeout = 400,
              },
              actions = {
                open_file = {
                  quit_on_open = false,
                  resize_window = true,
                  window_picker = {
                    enable = true,
                    picker = "default",
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                    exclude = {
                      filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
                      buftype = { "nofile", "terminal", "help" },
                    },
                  },
                },
                remove_file = {
                  close_window = true,
                },
              },
            })

            keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
            keymap("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", { desc = "Find file in explorer" })
          end,
        },

        -- Git integration
        {
          "lewis6991/gitsigns.nvim",
          config = function()
            require("gitsigns").setup({
              signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
              },
              signcolumn = true,
              numhl = false,
              linehl = false,
              word_diff = false,
              watch_gitdir = {
                interval = 1000,
                follow_files = true,
              },
              attach_to_untracked = true,
              current_line_blame = false,
              current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 1000,
                ignore_whitespace = false,
              },
              sign_priority = 6,
              update_debounce = 100,
              status_formatter = nil,
              max_file_length = 40000,
              preview_config = {
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
              },
              on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                  opts = opts or {}
                  opts.buffer = bufnr
                  keymap(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                  if vim.wo.diff then
                    return "]c"
                  end
                  vim.schedule(function()
                    gitsigns.next_hunk()
                  end)
                  return "<Ignore>"
                end, { expr = true, desc = "Jump to next hunk" })

                map("n", "[c", function()
                  if vim.wo.diff then
                    return "[c"
                  end
                  vim.schedule(function()
                    gitsigns.prev_hunk()
                  end)
                  return "<Ignore>"
                end, { expr = true, desc = "Jump to prev hunk" })

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
                map("v", "<leader>hs", function()
                  gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Stage hunk" })
                map("v", "<leader>hr", function()
                  gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Reset hunk" })
                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
                map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
                map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
                map("n", "<leader>hb", function()
                  gitsigns.blame_line({ full = true })
                end, { desc = "Blame line" })
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame line" })
                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
                map("n", "<leader>hD", function()
                  gitsigns.diffthis("~")
                end, { desc = "Diff this ~" })
                map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
              end,
            })
          end,
        },

        -- Git commands
        {
          "tpope/vim-fugitive",
          config = function()
            keymap("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
            keymap("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
            keymap("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
            keymap("n", "<leader>gl", "<cmd>Git pull<CR>", { desc = "Git pull" })
            keymap("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
            keymap("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
            keymap("n", "<leader>gr", "<cmd>Gread<CR>", { desc = "Git read" })
            keymap("n", "<leader>gw", "<cmd>Gwrite<CR>", { desc = "Git write" })
            keymap("n", "<leader>ge", "<cmd>Gedit<CR>", { desc = "Git edit" })
            keymap("n", "<leader>gv", "<cmd>GV<CR>", { desc = "Git log" })
            keymap("n", "<leader>gV", "<cmd>GV!<CR>", { desc = "Git log current file" })
          end,
        },

        -- Copilot
        {
          "github/copilot.vim",
          config = function()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_tab_fallback = ""

            keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
              expr = true,
              replace_keycodes = false,
              desc = "Accept copilot suggestion",
            })
            keymap("i", "<C-;>", "<Plug>(copilot-dismiss)", { desc = "Dismiss copilot" })
            keymap("i", "<C-]>", "<Plug>(copilot-next)", { desc = "Next copilot suggestion" })
            keymap("i", "<C-[>", "<Plug>(copilot-previous)", { desc = "Previous copilot suggestion" })
          end,
        },

        -- Copilot Chat
        {
          "CopilotChat.nvim",
          config = function()
            require("CopilotChat").setup({
              debug = false,
              window = {
                layout = "vertical",
                width = 0.5,
                height = 0.5,
              },
              mappings = {
                complete = {
                  detail = "Use @<Tab> or /<Tab> for options.",
                  insert = "<C-Space>",
                },
                close = {
                  normal = "q",
                  insert = "<C-c>",
                },
                reset = {
                  normal = "<C-r>",
                  insert = "<C-r>",
                },
                submit_prompt = {
                  normal = "<CR>",
                  insert = "<C-CR>",
                },
                accept_diff = {
                  normal = "<C-y>",
                  insert = "<C-y>",
                },
                yank_diff = {
                  normal = "gy",
                },
                show_diff = {
                  normal = "gd",
                },
                show_system_prompt = {
                  normal = "gp",
                },
                show_user_selection = {
                  normal = "gs",
                },
              },
            })

            -- Keymaps do CopilotChat
            keymap({ "n", "v" }, "<leader>cc", function()
              require("CopilotChat").toggle()
            end, { desc = "CopilotChat - Toggle" })

            keymap({ "n", "v" }, "<leader>ce", function()
              require("CopilotChat").ask("Explain this code", {
                selection = require("CopilotChat.select").visual,
              })
            end, { desc = "CopilotChat - Explain code" })

            keymap({ "n", "v" }, "<leader>cf", function()
              require("CopilotChat").ask("Refactor this code to make it cleaner and more efficient", {
                selection = require("CopilotChat.select").visual,
              })
            end, { desc = "CopilotChat - Refactor code" })

            keymap({ "n", "v" }, "<leader>cr", function()
              require("CopilotChat").ask("Review this code and suggest improvements", {
                selection = require("CopilotChat.select").visual,
              })
            end, { desc = "CopilotChat - Review code" })

            keymap({ "n", "v" }, "<leader>ct", function()
              require("CopilotChat").ask("Generate tests for this code", {
                selection = require("CopilotChat.select").visual,
              })
            end, { desc = "CopilotChat - Generate tests" })

            keymap({ "n", "v" }, "<leader>cn", function()
              require("CopilotChat").ask("Suggest better names for variables and functions in this code", {
                selection = require("CopilotChat.select").visual,
              })
            end, { desc = "CopilotChat - Better naming" })
          end,
        },

        -- Elixir tools
        {
          "elixir-tools.nvim",
          config = function()
            require("elixir").setup({
              nextls = { enable = false },
              elixirls = { enable = false },
              projectionist = { enable = true },
            })
          end,
        },

        -- Test runner
        {
          "vim-test/vim-test",
          config = function()
            vim.g["test#echo_command"] = 0

            if vim.fn.exists("$TMUX") == 1 then
              vim.g["test#preserve_screen"] = 1
              vim.g["test#strategy"] = "vimux"
            else
              vim.g["test#strategy"] = "neovim_sticky"
            end

            keymap("n", "<leader>t", "<cmd>TestNearest<CR>", { desc = "Test nearest" })
            keymap("n", "<leader>T", "<cmd>TestFile<CR>", { desc = "Test file" })
            keymap("n", "<leader>a", "<cmd>TestSuite<CR>", { desc = "Test suite" })
            keymap("n", "<leader>l", "<cmd>TestLast<CR>", { desc = "Test last" })
            keymap("n", "<leader>g", "<cmd>TestVisit<CR>", { desc = "Test visit" })
          end,
        },

        -- Which key
        {
          "folke/which-key.nvim",
          event = "VeryLazy",
          init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
          end,
          config = function()
            require("which-key").setup({
              plugins = {
                marks = true,
                registers = true,
                spelling = {
                  enabled = true,
                  suggestions = 20,
                },
                presets = {
                  operators = false,
                  motions = false,
                  text_objects = false,
                  windows = false,
                  nav = false,
                  z = true,
                  g = true,
                },
              },
              operators = { gc = "Comments" },
              key_labels = {
                ["<space>"] = "SPC",
                ["<cr>"] = "RET",
                ["<tab>"] = "TAB",
              },
              icons = {
                breadcrumb = "»",
                separator = "➜",
                group = "+",
              },
              popup_mappings = {
                scroll_down = "<c-d>",
                scroll_up = "<c-u>",
              },
              window = {
                border = "rounded",
                position = "bottom",
                margin = { 1, 0, 1, 0 },
                padding = { 2, 2, 2, 2 },
                winblend = 0,
              },
              layout = {
                height = { min = 4, max = 25 },
                width = { min = 20, max = 50 },
                spacing = 3,
                align = "left",
              },
              ignore_missing = true,
              hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
              show_help = true,
              triggers = "auto",
              triggers_blacklist = {
                i = { "j", "k" },
                v = { "j", "k" },
              },
            })
          end,
        },

        -- Trouble
        {
          "folke/trouble.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require("trouble").setup({
              position = "bottom",
              height = 10,
              width = 50,
              icons = true,
              mode = "workspace_diagnostics",
              fold_open = "",
              fold_closed = "",
              group = true,
              padding = true,
              action_keys = {
                close = "q",
                cancel = "<esc>",
                refresh = "r",
                jump = { "<cr>", "<tab>" },
                open_split = { "<c-x>" },
                open_vsplit = { "<c-v>" },
                open_tab = { "<c-t>" },
                jump_close = { "o" },
                toggle_mode = "m",
                toggle_preview = "P",
                hover = "K",
                preview = "p",
                close_folds = { "zM", "zm" },
                open_folds = { "zR", "zr" },
                toggle_fold = { "zA", "za" },
                previous = "k",
                next = "j",
              },
              indent_lines = true,
              auto_open = false,
              auto_close = false,
              auto_preview = true,
              auto_fold = false,
              auto_jump = { "lsp_definitions" },
              signs = {
                error = "󰅚",
                warning = "󰀪",
                hint = "󰌶",
                information = "󰋼",
                other = "󰗀",
              },
              use_diagnostic_signs = false,
            })

            keymap("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Toggle trouble" })
            keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Workspace diagnostics" })
            keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Document diagnostics" })
            keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>", { desc = "Location list" })
            keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Quickfix" })
            keymap("n", "gR", "<cmd>TroubleToggle lsp_references<CR>", { desc = "LSP references" })
          end,
        },

        -- Comment
        {
          "numToStr/Comment.nvim",
          config = function()
            require("Comment").setup({
              pre_hook = function(ctx)
                local U = require("Comment.utils")

                local location = nil
                if ctx.ctype == U.ctype.block then
                  location = require("ts_context_commentstring.utils").get_cursor_location()
                elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                  location = require("ts_context_commentstring.utils").get_visual_start_location()
                end

                return require("ts_context_commentstring.internal").calculate_commentstring({
                  key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
                  location = location,
                })
              end,
            })
          end,
        },

        -- Context commentstring
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
          dependencies = { "nvim-treesitter/nvim-treesitter" },
        },

        -- Auto pairs
        {
          "windwp/nvim-autopairs",
          event = "InsertEnter",
          config = function()
            require("nvim-autopairs").setup({
              check_ts = true,
              ts_config = {
                lua = { "string", "source" },
                javascript = { "string", "template_string" },
                java = false,
              },
              disable_filetype = { "TelescopePrompt", "spectre_panel" },
              fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'" },
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                offset = 0,
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "PmenuSel",
                highlight_grey = "LineNr",
              },
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
          end,
        },

        -- Surround
        {
          "kylechui/nvim-surround",
          version = "*",
          event = "VeryLazy",
          config = function()
            require("nvim-surround").setup({
              keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "ys",
                normal_cur = "yss",
                normal_line = "yS",
                normal_cur_line = "ySS",
                visual = "S",
                visual_line = "gS",
                delete = "ds",
                change = "cs",
              },
            })
          end,
        },

        -- Terminal
        {
          "akinsho/toggleterm.nvim",
          version = "*",
          config = function()
            require("toggleterm").setup({
              size = 20,
              open_mapping = [[<c-\>]],
              hide_numbers = true,
              shade_filetypes = {},
              shade_terminals = true,
              shading_factor = 2,
              start_in_insert = true,
              insert_mappings = true,
              persist_size = true,
              direction = "float",
              close_on_exit = true,
              shell = vim.o.shell,
              float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                  border = "Normal",
                  background = "Normal",
                },
              },
            })

            keymap("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
            keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
          end,
        },

        -- Notify
        {
          "rcarriga/nvim-notify",
          config = function()
            require("notify").setup({
              background_colour = "#000000",
            })
            vim.notify = require("notify")
          end,
        },

        -- Todo comments
        {
          "folke/todo-comments.nvim",
          dependencies = { "nvim-lua/plenary.nvim" },
          config = function()
            require("todo-comments").setup({
              signs = true,
              sign_priority = 8,
              keywords = {
                FIX = {
                  icon = " ",
                  color = "error",
                  alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
              },
              gui_style = {
                fg = "NONE",
                bg = "BOLD",
              },
              merge_keywords = true,
              highlight = {
                multiline = true,
                multiline_pattern = "^.",
                multiline_context = 10,
                before = "",
                keyword = "wide",
                after = "fg",
                pattern = [[.*<(KEYWORDS)\s*:]],
                comments_only = true,
                max_line_len = 400,
                exclude = {},
              },
              colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF006E" },
              },
              search = {
                command = "rg",
                args = {
                  "--color=never",
                  "--no-heading",
                  "--with-filename",
                  "--line-number",
                  "--column",
                },
                pattern = [[\b(KEYWORDS):]],
              },
            })

            keymap("n", "]t", function()
              require("todo-comments").jump_next()
            end, { desc = "Next todo comment" })
            keymap("n", "[t", function()
              require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" })
            keymap("n", "<leader>xt", "<cmd>TodoTrouble<CR>", { desc = "Todo (Trouble)" })
            keymap("n", "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR>", { desc = "Todo/Fix/Fixme (Trouble)" })
            keymap("n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "Todo" })
            keymap("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", { desc = "Todo/Fix/Fixme" })
          end,
        },
      })

      -- ============================================================================
      -- CONFIGURAÇÕES FINAIS
      -- ============================================================================

      -- Highlight on yank
      local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = "*",
      })

      -- Auto resize panes
      vim.api.nvim_create_autocmd("VimResized", {
        pattern = "*",
        command = "tabdo wincmd =",
      })

      -- Auto format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })

      -- Auto close NvimTree if it's the only window
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          if vim.bo.filetype == "NvimTree" and vim.fn.winnr("$") == 1 then
            vim.cmd("quit")
          end
        end,
      })

      -- Auto open NvimTree on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
          if vim.fn.isdirectory(vim.fn.getcwd() .. "/.git") == 1 then
            vim.cmd("NvimTreeOpen")
          end
        end,
      })

      -- ============================================================================
      -- KEYMAPS FINAIS
      -- ============================================================================

      -- Quick save
      keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

      -- Quick quit
      keymap("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })

      -- Better indenting
      keymap("v", "<", "<gv", { desc = "Indent left" })
      keymap("v", ">", ">gv", { desc = "Indent right" })

      -- Move to window using the <ctrl> hjkl keys
      keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
      keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
      keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
      keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

      -- Resize window using <ctrl> arrow keys
      keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
      keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
      keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
      keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

      -- Move lines up and down
      keymap("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move down" })
      keymap("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move up" })
      keymap("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move down" })
      keymap("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move up" })
      keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
      keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })

      -- Clear search with <esc>
      keymap({ "i", "n" }, "<esc>", "<cmd>noh<CR><esc>", { desc = "Escape and clear hlsearch" })

      -- Clear search, diff update and redraw
      keymap("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / clear hlsearch / diff update" })

      -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
      keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
      keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
      keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
      keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
      keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

      -- Add undo break points
      keymap("i", ",", ",<C-g>u", { desc = "Add undo break point" })
      keymap("i", ".", ".<C-g>u", { desc = "Add undo break point" })
      keymap("i", ";", ";<C-g>u", { desc = "Add undo break point" })

      -- Save file
      keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<CR><esc>", { desc = "Save file" })

      -- Keywordprg
      keymap("n", "<leader>K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover Documentation" })

      -- Terminal
      keymap("n", "<leader>ft", "<cmd>ToggleTerm direction=float<CR>", { desc = "Terminal (float)" })
      keymap("n", "<leader>fT", "<cmd>ToggleTerm direction=vertical size=40<CR>", { desc = "Terminal (vertical)" })
      keymap("n", "<leader>f\\", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal (horizontal)" })

      -- Windows
      keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
      keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
      keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
      keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
      keymap("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
      keymap("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

      -- Tabs
      keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
      keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
      keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
      keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
      keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
      keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

      -- Buffers
      keymap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
      keymap("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

      -- Quickfix
      keymap("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
      keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
      keymap("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
      keymap("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

      -- Lazy
      keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

      -- Mason
      keymap("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })

      -- LSP
      keymap("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
      keymap("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", { desc = "Lsp Install Info" })
      keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
      keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
      keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({async=true})<cr>", { desc = "Format" })
      keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature Help" })
      keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "Quickfix" })
      keymap("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", { desc = "CodeLens Action" })
      keymap("n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Goto Declaration" })
      keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Goto Definition" })
      keymap("n", "<leader>ly", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Goto Type Definition" })
      keymap("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Goto Implementation" })
      keymap("n", "<leader>lR", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "References" })

      -- Diagnostic
      keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
      keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
      keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
      keymap("n", "<leader>cl", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "Diagnostic Quickfix" })

      -- ============================================================================
      -- CONFIGURAÇÃO FINAL
      -- ============================================================================

      print("🚀 Neovim configurado com sucesso!")
    '';

    plugins = with pkgs.vimPlugins; [
      # Dependências básicas
      plenary-nvim
      nvim-web-devicons
      
      # Lazy.nvim será instalado via extraLuaConfig
      # Mason será instalado via extraLuaConfig
      # Todos os outros plugins serão instalados via Lazy.nvim
    ];
  };
}
