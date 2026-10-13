return { -- Claude Code IDE integration: share selections, review Claude's edits as nvim diffs
  'coder/claudecode.nvim',
  opts = {
    -- Built-in terminal (no snacks.nvim). The WebSocket server runs regardless, so a
    -- Claude Code session in another terminal can also connect with `/ide`.
    terminal = { provider = 'native' },
  },
  cmd = {
    'ClaudeCode',
    'ClaudeCodeFocus',
    'ClaudeCodeSelectModel',
    'ClaudeCodeAdd',
    'ClaudeCodeSend',
    'ClaudeCodeTreeAdd',
    'ClaudeCodeStatus',
    'ClaudeCodeStart',
    'ClaudeCodeStop',
    'ClaudeCodeOpen',
    'ClaudeCodeClose',
    'ClaudeCodeDiffAccept',
    'ClaudeCodeDiffDeny',
    'ClaudeCodeCloseAllDiffs',
  },
  keys = {
    { '<leader>a', nil, desc = '[A]I / Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle [C]laude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = '[F]ocus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = '[R]esume Claude session' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = '[C]ontinue last Claude session' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current [b]uffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[S]end selection to Claude' },
    { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add file from explorer', ft = { 'oil' } },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[A]ccept Claude diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = '[D]eny Claude diff' },
    { '<leader>aS', '<cmd>ClaudeCodeStart<cr>', desc = '[S]tart server (for /ide)' },
  },
}
