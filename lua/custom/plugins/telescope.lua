return { -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local builtin = require 'telescope.builtin'
      local telescope_actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      local function grep_with_path_filter(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt_title = picker.prompt_title or ''
        local current_query = action_state.get_current_line()
        local grep_string_query = prompt_title:match '^Find Word %((.*)%)$'
        local is_find_files = prompt_title == 'Find Files'

        if prompt_title ~= 'Live Grep' and not grep_string_query and not is_find_files then
          return telescope_actions.to_fuzzy_refine(prompt_bufnr)
        end

        local cwd = picker.cwd or vim.fn.getcwd()
        vim.ui.input({ prompt = 'File path regex (relative to ' .. cwd .. '): ' }, function(path_pattern)
          if not path_pattern or path_pattern == '' then
            return
          end

          local ok, path_regex = pcall(vim.regex, path_pattern)
          if not ok then
            vim.notify('Invalid file path regex: ' .. path_pattern, vim.log.levels.ERROR)
            return
          end

          local result = vim
            .system({ 'rg', '--files', '--hidden', '--glob', '!.git/**' }, {
              cwd = cwd,
              text = true,
            })
            :wait()
          if result.code ~= 0 and result.code ~= 1 then
            vim.notify(result.stderr, vim.log.levels.ERROR)
            return
          end

          local search_dirs = {}
          for _, path in ipairs(vim.split(result.stdout or '', '\n', { trimempty = true })) do
            if path_regex:match_str(path) then
              table.insert(search_dirs, path)
            end
          end

          if #search_dirs == 0 then
            vim.notify('No files match that path regex', vim.log.levels.INFO)
            return
          end

          telescope_actions.close(prompt_bufnr)
          vim.schedule(function()
            if is_find_files then
              builtin.find_files {
                cwd = cwd,
                search_dirs = search_dirs,
                default_text = current_query,
              }
            elseif grep_string_query then
              builtin.grep_string {
                search = grep_string_query,
                cwd = cwd,
                search_dirs = search_dirs,
              }
            else
              builtin.live_grep {
                cwd = cwd,
                search_dirs = search_dirs,
                default_text = current_query,
              }
            end
          end)
        end)
      end

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        pickers = {
          find_files = {
            find_command = {
              'rg',
              '--files',
              '--hidden',
              '--glob',
              '!.git/**',
              '--sortr=modified',
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          path_display = { 'truncate', 'filename_first', 'smart' },
          mappings = {
            n = { ['<c-d>'] = require('telescope.actions').delete_buffer },
            i = {
              ['<c-h>'] = 'which_key',
              ['<c-d>'] = require('telescope.actions').delete_buffer,
              ['<c-enter>'] = grep_with_path_filter,
            },
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sF', function()
        builtin.find_files { default_text = vim.fn.expand '<cword>' }
      end, { desc = '[S]earch current word in [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sb', ':Telescope git_branches<CR>', { desc = 'Show Git-Branches' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'nvim-telescope/telescope-frecency.nvim',
    -- install the latest stable version
    version = '*',
    config = function()
      require('telescope').setup {
        extensions = {
          frecency = {
            show_filter_column = false,
          },
        },
      }
      require('telescope').load_extension 'frecency'
    end,
  },
  {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local project_actions = require 'telescope._extensions.project.actions'

      require('telescope').setup {
        extensions = {
          project = {
            base_dirs = {
              { path = '~/code/DiceTechnology', max_depth = 3 }, -- Replace with your root projects path
            },
            hidden_files = true, -- Optional: show hidden files in project search
            order_by = 'recent',
            theme = 'dropdown', -- Optional: customize the picker display
            on_project_selected = function(prompt_bufnr)
              local project_path = project_actions.get_selected_path(prompt_bufnr)
              project_actions.change_working_directory(prompt_bufnr)
              vim.schedule(function()
                require('telescope').extensions.frecency.frecency {
                  cwd = project_path,
                  workspace = 'CWD',
                }
              end)
            end,
          },
        },
      }
      require('telescope').load_extension 'project'
      vim.keymap.set('n', '<leader>sp', ':Telescope project<CR>', { desc = '[S]earch [P]rojects' })
    end,
  },
}
