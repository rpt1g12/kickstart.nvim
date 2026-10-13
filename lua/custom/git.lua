-- Shared git helpers for diffview/gitsigns mappings.
local M = {}

-- The remote's default branch for the current repo, e.g. "origin/main" or "origin/master".
-- Run `git remote set-head origin --auto` once in a repo if origin/HEAD is missing.
function M.default_branch()
  local ref = vim.fn.systemlist('git rev-parse --abbrev-ref origin/HEAD')[1]
  if vim.v.shell_error == 0 and ref and ref ~= '' then
    return ref
  end
  return 'origin/main'
end

return M
