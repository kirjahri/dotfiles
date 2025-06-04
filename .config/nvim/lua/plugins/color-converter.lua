return {
  'NTBBloodbath/color-converter.nvim',
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('color-converter').setup {}

    vim.keymap.set('n', '<leader>c', require('color-converter').cycle, { desc = '[c]ycle between colors' })
  end,
}
