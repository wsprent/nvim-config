local M = {}

M.get_cur_dir_or_cwd = function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    return cwd
  end

  -- Extract the directory from the current file's path
  if vim.fn.isdirectory(current_file) > 0 then
    return current_file
  end
  return vim.fn.fnamemodify(current_file, ':h')
end

M.find_git_root = function()
  -- Use the current buffer's path as the starting point for the git search
  local current_dir = M.get_cur_dir_or_cwd()

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return current_dir
  end
  return git_root
end

-- Custom live_grep function to search in git root

return M
