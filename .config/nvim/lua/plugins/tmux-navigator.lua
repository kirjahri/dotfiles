return {
  'christoomey/vim-tmux-navigator',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  keys = {
    { '<C-h>', '<cmd>C-u>TmuxNavigateLeft<CR>', desc = 'Move focus to left window' },
    { '<C-l>', '<cmd><C-u>TmuxNavigateRight<CR>', desc = 'Move focus to right window' },
    { '<C-k>', '<cmd><C-u>TmuxNavigateUp<CR>', desc = 'Move focus to upper window' },
    { '<C-j>', '<cmd><C-u>TmuxNavigateDown<CR>', desc = 'Move focus to lower window' },
  },
}
