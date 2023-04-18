return { 'neoclide/coc.nvim',
  branch = 'release',
  requires = { 'neoclide/coc-sources', 'Shougo/neco-vim', 'neoclide/coc-neco' },
  config = function()
    vim.g.coc_global_extensions = {
      'coc-git',
      'coc-json',
      'coc-snippets',
      'coc-vimtex',
      'coc-syntax',
    }
    vim.g.coc_data_home = "~/.local/share/coc"
    vim.cmd[[
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)
    inoremap <expr> <Tab>   pumvisible() ? "\<C-N>"      : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>"      : "\<Tab>"
    inoremap <expr> <CR>    pumvisible() ? "\<C-Y>\<CR>" : "\<CR>"
    nnoremap <silent> KK <CMD>call CocAction("doHover")<CR>
    ]]
  end,
}
