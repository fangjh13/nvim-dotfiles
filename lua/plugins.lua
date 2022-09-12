-- [[ plugs.lua ]]

return require('packer').startup({function(use)
  -- [[ Plugins Go Here ]]
  use {                                              -- filesystem navigation
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',       -- filesystem icons
    config = function() require('nvim-tree').setup{} end
  }

  -- [[ Theme ]]
  use { 'mhinz/vim-startify' }                       -- start screen
  use { 'DanilaMihailov/beacon.nvim' }               -- cursor jump
  use {
    'nvim-lualine/lualine.nvim',                     -- statusline
    requires = {'kyazdani42/nvim-web-devicons',
                opt = true}
  }
  use { 'Mofiqul/dracula.nvim' }

  -- [[ Dev ]]
  use {
    'nvim-telescope/telescope.nvim',                 -- fuzzy finder
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { 'majutsushi/tagbar' }                        -- code structure
  use { 'Yggdroot/indentLine' }                      -- see indentation
  use { 'tpope/vim-fugitive' }                       -- git integration
  use { 'junegunn/gv.vim' }                          -- commit history
  use { 
      'windwp/nvim-autopairs',                       -- auto insert pairs
      config = function() require('nvim-autopairs').setup{} end
  }  

  -- [[ Completion ]]
  use {"hrsh7th/nvim-cmp"}
  use {"SirVer/ultisnips"}
  use {
      "quangnguyen30192/cmp-nvim-ultisnips",
      config = function() 
          require("cmp_nvim_ultisnips").setup{}
        end
  }
  

end,
config = {
    package_root = vim.fn.stdpath('config') .. '/site/pack'
}})

