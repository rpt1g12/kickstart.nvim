-- Hot-reload config on save, so edits apply without restarting nvim.
--   lua/custom/plugins/*.lua → refresh lazy's specs, then `:Lazy reload` the plugins in that file
--   lua/custom/*.lua         → drop the module from package.loaded so the next require re-reads it
-- init.lua is not handled: lazy.nvim refuses to re-run `require('lazy').setup`.
local M = {}

local config_lua = vim.fn.stdpath 'config' .. '/lua/'

-- Plugin names (as lazy.nvim knows them, e.g. 'telescope-frecency.nvim') declared by a spec file's
-- return value. A spec file returns either one spec ({ 'owner/repo', ... }) or a list of specs.
---@param spec table
---@return string[]
local function spec_plugin_names(spec, names)
  names = names or {}
  if type(spec[1]) == 'string' or spec.name or spec.dir then
    -- A single spec: lazy keys it by `name` when set, otherwise by the last path segment of the
    -- repo (or of `dir` for a local plugin).
    local name = spec.name or (spec[1] or spec.dir):match '([^/]+)$'
    table.insert(names, name)
  else
    -- A list of specs, possibly nested (lazy allows lists inside lists).
    for _, s in ipairs(spec) do
      if type(s) == 'table' then
        spec_plugin_names(s, names)
      end
    end
  end
  return names
end

---@param file string absolute path of the saved file
local function reload_plugin_file(file)
  local ok, spec = pcall(dofile, file)
  if not ok or type(spec) ~= 'table' then
    vim.notify('reload: could not evaluate ' .. vim.fn.fnamemodify(file, ':~') .. '\n' .. tostring(spec), vim.log.levels.ERROR)
    return
  end

  -- Re-read every spec so `:Lazy reload` runs the new config/opts, not the ones from startup.
  require('lazy.core.plugin').load()

  local plugins = require('lazy.core.config').plugins
  local reloaded = {}
  for _, name in ipairs(spec_plugin_names(spec)) do
    local plugin = plugins[name]
    -- Only reload what is already loaded; lazy-loaded plugins pick up the new spec when they load.
    if plugin and plugin._.loaded then
      require('lazy.core.loader').reload(plugin)
      table.insert(reloaded, name)
    end
  end
  if #reloaded > 0 then
    vim.notify('reloaded: ' .. table.concat(reloaded, ', '))
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('custom-config-reload', { clear = true }),
    pattern = config_lua .. 'custom/*.lua',
    desc = 'Hot-reload nvim config on save',
    callback = function(ev)
      local file = vim.fs.normalize(ev.file)
      if file:find('/custom/plugins/', 1, true) then
        reload_plugin_file(file)
      else
        local module = file:sub(#config_lua + 1):gsub('%.lua$', ''):gsub('/', '.')
        package.loaded[module] = nil
        vim.notify('reloaded module: ' .. module)
      end
    end,
  })
end

return M
