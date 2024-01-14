return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    {
      'nvim-telescope/telescope-project.nvim'
    },
  },
  config = function()
    local ts = require('telescope')
    ts.setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    }
    pcall(ts.load_extension, 'fzf')
    ts.load_extension('project')

    local tb = require('telescope.builtin')
    local utils = require('utils')

    local function telescope_live_grep_open_files()
      require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end
    local function live_grep_git_root()
      local git_root = utils.find_git_root()
      if git_root then
        tb.live_grep {
          search_dirs = { git_root },
        }
      end
    end

    local function find_files_git_root()
      local git_root = utils.find_git_root()
      if git_root then
        tb.find_files {
          cwd = git_root,
        }
      end
    end

    vim.keymap.set('n', '<leader>?', tb.oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', tb.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>ff', function()
      tb.find_files({ cwd = utils.get_cur_dir_or_cwd() })
    end, { desc = '[F]ind [File]' })
    vim.keymap.set('n', '<leader>fg', tb.live_grep, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      tb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 20,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })


    vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

    vim.keymap.set('n', '<leader>bl', tb.buffers, { desc = 'List Buffers' })

    vim.keymap.set('n', '<leader>pf', find_files_git_root, { desc = '[F]ind [File] Git Root' })
    vim.keymap.set('n', '<leader>ps', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })

    vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
    vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
  end
}
