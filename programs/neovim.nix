{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [curl ripgrep fd];
    extraLuaConfig = ''
               vim.opt.number = true

                local o = vim.o
             local g = vim.g

             -- Configurar espaço como leader
             vim.g.mapleader = " "
             vim.g.maplocalleader = " "

             o.clipboard = "unnamedplus"

             o.number = true

             vim.opt.numberwidth = 1

             o.swapfile = false

                 g.markdown_fenced_languages = {
                 "python", "elixir", "bash", "dockerfile", 'sh=bash'
             }

      vim.filetype.add({
           extension = {
             flow = 'json',
           },
         })
         vim.keymap.set("n", "<space>h", ":nohlsearch<CR>")
         vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>")

         -- Copilot configuration
         vim.g.copilot_no_tab_map = true

         -- Use vim.cmd for reliable Tab mapping
         vim.cmd([[
           imap <silent><script><expr> <Tab> copilot#Accept("\<CR>")
         ]])
    '';

    plugins = with pkgs.vimPlugins; [
      # Dependências básicas que podem ser úteis
      plenary-nvim
      nvim-web-devicons

      # CopilotChat.nvim - Alternativa mais estável ao Avante
      {
        plugin = CopilotChat-nvim;
        type = "lua";
        config = ''
          require("CopilotChat").setup({
            debug = false, -- Enable debugging
            -- See Configuration section for rest
            window = {
              layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
              width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
              height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
            },
            mappings = {
              complete = {
                detail = 'Use @<Tab> or /<Tab> for options.',
                insert = '<C-Space>',
              },
              close = {
                normal = 'q',
                insert = '<C-c>'
              },
              reset = {
                normal = '<C-r>',
                insert = '<C-r>'
              },
              submit_prompt = {
                normal = '<CR>',
                insert = '<C-CR>'
              },
              accept_diff = {
                normal = '<C-y>',
                insert = '<C-y>'
              },
              yank_diff = {
                normal = 'gy',
              },
              show_diff = {
                normal = 'gd'
              },
              show_system_prompt = {
                normal = 'gp'
              },
              show_user_selection = {
                normal = 'gs'
              },
            },
          })

          -- Keymaps
          vim.keymap.set({'n', 'v'}, '<leader>cc', function()
            require("CopilotChat").toggle()
          end, { desc = 'CopilotChat - Toggle' })

          vim.keymap.set({'n', 'v'}, '<leader>ce', function()
            require("CopilotChat").ask("Explain this code", { selection = require("CopilotChat.select").visual })
          end, { desc = 'CopilotChat - Explain code' })

          vim.keymap.set({'n', 'v'}, '<leader>cf', function()
            require("CopilotChat").ask("Refactor this code to make it cleaner and more efficient", {
              selection = require("CopilotChat.select").visual
            })
          end, { desc = 'CopilotChat - Refactor code' })

          vim.keymap.set({'n', 'v'}, '<leader>cr', function()
            require("CopilotChat").ask("Review this code and suggest improvements", {
              selection = require("CopilotChat.select").visual
            })
          end, { desc = 'CopilotChat - Review code' })

          vim.keymap.set({'n', 'v'}, '<leader>ct', function()
            require("CopilotChat").ask("Generate tests for this code", {
              selection = require("CopilotChat.select").visual
            })
          end, { desc = 'CopilotChat - Generate tests' })

          vim.keymap.set({'n', 'v'}, '<leader>cn', function()
            require("CopilotChat").ask("Suggest better names for variables and functions in this code", {
              selection = require("CopilotChat.select").visual
            })
          end, { desc = 'CopilotChat - Better naming' })
        '';
      }

      copilot-vim
      vim-elixir
      nvim-lspconfig
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
               require('nvim-treesitter.configs').setup {
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
              indent = {
                enable = true,
              },
          }
        '';
      }
      {
        plugin = elixir-tools-nvim;
        type = "lua";
        config = ''
          require("elixir").setup({
            nextls = {enable = false},
            elixirls = {enable = false},
            projectionist = {enable = true},
          })
        '';
      }
      nvim-lspconfig
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Configure Expert LSP for Elixir
          -- Expert is already installed at ~/projects/expert/

          -- Detectar sistema operacional e definir caminho correto
          local function get_expert_cmd()
            local uname = vim.fn.system("uname"):gsub("%s+", "")
            if uname == "Darwin" then
              -- macOS
              return "/Users/claudio/.local/bin/expert"
            else
              -- Linux/Ubuntu
              return "/home/claudio/.local/bin/expert"
            end
          end

          local expert_cmd = get_expert_cmd()

          require('lspconfig').lexical.setup {
            cmd = { expert_cmd },
            root_dir = function(fname)
              return require('lspconfig').util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
            end,
            filetypes = { "elixir", "eelixir", "heex" },
            settings = {}
          }
        '';
      }
      vim-projectionist

      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require("telescope")
             telescope.setup({
                 defaults = {
                     vimgrep_arguments = {
                         "rg", "--color=never", "--no-heading", "--with-filename",
                         "--line-number", "--column", "--smart-case", "--hidden",
                         "--glob=!.git"
                     }
                 }
             })

             local builtin = require("telescope.builtin")

             -- Função para tentar git_files primeiro, com fallback para find_files
             local function project_files()
               local git_dir = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
               if vim.v.shell_error == 0 then
                 builtin.git_files({})
               else
                 builtin.find_files({})
               end
             end

             vim.keymap.set("n", "<leader>ff", project_files, {desc = 'Telescope project files'})
             vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = 'Telescope live grep'})
             vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        '';
      }
      vimux
      {
        plugin = vim-test;
        config = ''
                 	  let g:test#echo_command = 0

                 if exists('$TMUX')
                   let g:test#preserve_screen = 1
                   let g:test#strategy = 'vimux'
          else
            let g:test#strategy = 'neovim_sticky'
                 endif

                 nmap <silent> <leader>t :TestNearest<CR>
                 nmap <silent> <leader>T :TestFile<CR>
                 nmap <silent> <leader>a :TestSuite<CR>
                 nmap <silent> <leader>l :TestLast<CR>
                 nmap <silent> <leader>g :TestVisit<CR>
        '';
      }
      vim-fugitive
      {
        plugin = gitlinker-nvim;
        type = "lua";
        config = "require'gitlinker'.setup()";
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
           require('gitsigns').setup{
             on_attach = function(bufnr)
            local gitsigns = require('gitsigns')

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
              if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
              else
                gitsigns.nav_hunk('next')
              end
            end)

            map('n', '[c', function()
              if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
              else
                gitsigns.nav_hunk('prev')
              end
            end)
          end
           }
        '';
      }

      file-line
    ];
  };
}
