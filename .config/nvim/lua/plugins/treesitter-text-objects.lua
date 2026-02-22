return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',

    branch = 'main',

    keys = {
      {
        '[f',
        function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end,
        desc = 'prev function',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']f',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,
        desc = 'next function',
        mode = { 'n', 'x', 'o' },
      },
      {
        '[F',
        function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end,
        desc = 'prev function end',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']F',
        function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end,
        desc = 'next function end',
        mode = { 'n', 'x', 'o' },
      },
      {
        '[a',
        function() require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects') end,
        desc = 'prev argument',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']a',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects') end,
        desc = 'next argument',
        mode = { 'n', 'x', 'o' },
      },
      {
        '[A',
        function() require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects') end,
        desc = 'prev argument end',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']A',
        function() require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects') end,
        desc = 'next argument end',
        mode = { 'n', 'x', 'o' },
      },
      {
        '[s',
        function() require('nvim-treesitter-textobjects.move').goto_previous_start('@block.outer', 'textobjects') end,
        desc = 'prev block',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']s',
        function() require('nvim-treesitter-textobjects.move').goto_next_start('@block.outer', 'textobjects') end,
        desc = 'next block',
        mode = { 'n', 'x', 'o' },
      },
      {
        '[S',
        function() require('nvim-treesitter-textobjects.move').goto_previous_end('@block.outer', 'textobjects') end,
        desc = 'prev block',
        mode = { 'n', 'x', 'o' },
      },
      {
        ']S',
        function() require('nvim-treesitter-textobjects.move').goto_next_end('@block.outer', 'textobjects') end,
        desc = 'next block',
        mode = { 'n', 'x', 'o' },
      },
      {
        'gan',
        function() require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner') end,
        desc = 'swap next argument',
      },
      {
        'gap',
        function() require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner') end,
        desc = 'swap prev argument',
      },
    },

    opts = {
      move = {
        enable = true,
        set_jumps = true,
      },
      swap = {
        enable = true,
      },
    },
  }
