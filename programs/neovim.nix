{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [curl];
    extraLuaConfig = ''
               vim.opt.number = true

                local o = vim.o
             local g = vim.g

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
    '';

    plugins = with pkgs.vimPlugins; [
      copilot-vim
      vim-elixir
      nvim-lspconfig
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
               require'nvim-treesitter.configs'.setup {
              highlight = {enable = true}
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

          local expert_cmd = "/home/claudio/.local/bin/expert"

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
                        vim.keymap.set("n", "<leader>ff", builtin.git_files, {})
                        vim.keymap.set('n', '<leader>fg', builtin.live_grep,
                                       {desc = 'Telescope live grep'})
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
