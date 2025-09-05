return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
