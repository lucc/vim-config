-- options setup by luc
-- vim: foldmethod=marker spelllang=en

-- Use neovim-remote as $EDITOR to open files in the same instance.
vim.env.EDITOR = 'nvr'

-- basic {{{1

vim.opt.backup = true
vim.opt.backupdir:remove(".")
vim.opt.backupskip:append("/dev/shm/*")
vim.opt.hidden = true
vim.opt.confirm = true
vim.opt.textwidth = 78
vim.opt.shiftwidth = 2
vim.opt.number = true
-- scroll when the courser is 2 lines from the border line
vim.opt.scrolloff = 2
vim.opt.shortmess = { c = true }
vim.opt.startofline = false
vim.opt.switchbuf = "useopen"
vim.opt.colorcolumn = "+1"
vim.opt.mouse = "a"
vim.opt.showcmd = true
vim.opt.splitright = true
vim.opt.virtualedit = "block"
vim.opt.diffopt = "filler,vertical"
-- default: blank,buffers,curdir,folds,help,options,tabpages,winsize
vim.opt.sessionoptions:append("resize,winpos")
-- use /bin/sh as shell to have a shell with a simple prompt TODO fix zsh
-- prompt
--vim.opt.shell = "/bin/sh"
-- hopefully this is not to demanding (=short)
vim.opt.updatetime = 200
vim.opt.directory:append("~/tmp")
vim.opt.directory:append("/tmp")
vim.opt.inccommand = "split"
vim.opt.undofile = true

-- shada {{{1
-- default: '100,<50,s10,h
-- the flag ' is for filenames for marks
-- the flag < is the nummber of lines saved per register
-- the flag s is the max size saved for registers in kb
-- the flag h is to disable hlsearch
-- the flag % is to remember (whole) buffer list
-- the flag n is the name of the viminfo file
-- include bufferlist
vim.opt.shada:append("%")
-- save all lines from registers
vim.opt.shada:remove("<")
-- save all items smaller than 100K
vim.opt.shada:append("s100")

-- cpoptions {{{1
vim.opt.cpoptions:append("$")  -- don't redraw the display while executing c, s, ... cmomands

-- terminal stuff {{{1

vim.opt.title = true

if vim.env.COLORTERM == 'truecolor' or vim.env.KONSOLE_DBUS_SERVICE ~= nil or string.match(vim.env.TERM, 'st.*') then
  vim.opt.termguicolors = true
end

--vim.opt.pumblend = 20

-- searching {{{1
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- spellchecking {{{1

-- on Mac OS X the spellchecking files are in:
-- MacVim.app/Contents/Resources/vim/runtime/spell
vim.opt.spelllang = { "de", "en" }
if #vim.opt.spellfile == 0 then
  vim.opt.spellfile = {
    vim.fn.stdpath("config").."/spell/de.utf-8.add",
    vim.fn.stdpath("config").."/spell/en.utf-8.add",
    vim.fn.stdpath("config").."/spell/names.utf-8.add",
  }
end
vim.opt.spell = false

-- folding {{{1

vim.opt.foldmethod = "syntax"
-- fold code by indent
--vim.opt.foldmethod = "indent"
-- but open all (20) folds on startup
--vim.opt.foldlevelstart = 20
-- enable folding for functions, heredocs and if-then-else stuff in sh files.
vim.g.sh_fold_enabled = 7

-- path {{{1
-- vim.opt.the path for file searching
vim.opt.path = {
  ".",    -- first the directory of the current file
  ",",    -- then the current working directory
  "./**", -- all files below the current file
  ".;",   -- all dirs above the current file
  "~/",   -- and the home directory
}

-- formatoptions {{{1
-- formatoptions default is tcq
vim.opt.formatoptions:append("n")  -- recognize numbered lists
vim.opt.formatoptions:append("r")  -- insert comment leader when hitting <enter>
vim.opt.formatoptions:append("j")  -- remove comment leader when joining lines
vim.opt.formatoptions:append("l")  -- do not break lines which are already long

-- wildmenu and wildignore {{{1
vim.opt.wildmode = "longest:full,full"

vim.opt.wildignore = {
  -- version control
  ".git",
  ".hg",
  ".svn",
  -- latex intermediate files
  "*.aux",
  "*.fdb_latexmk",
  "*.fls",
  "*.idx",
  "*.out",
  "*.toc",
  -- binary documents and office documents
  "*.djvu",
  "*.doc",    -- Microsoft Word
  "*.docx",   -- Microsoft Word
  "*.dvi",
  "*.ods",    -- Open Document spreadsheet
  "*.odt",    -- Open Document spreadsheet template
  "*.pdf",
  "*.ps",
  "*.xls",    -- Microsoft Excel
  "*.xlsx",   -- Microsoft Excel
  -- binary images
  "*.bmp",
  "*.gif",
  "*.jpeg",
  "*.jpg",
  "*.png",
  -- music
  "*.mp3",
  "*.flac",
  -- special vim files
  ".*.sw?",  -- Vim swap files
  "*.spl",   -- compiled spell word lists
  -- OS specific files
  ".DS_Store",
  -- compiled and binary files
  "*.class",      -- java
  "*.dll",        -- windows libraries
  "*.exe",        -- windows executeables
  "*.o",          -- object files
  "*.obj",        -- ?
  "*.pyc",        -- Python byte code
  "*.luac",       -- Lua byte code
  "__pycache__",  -- python stuff
  "*.egg-info",   -- python stuff
  -- unsuported archives and images
  "*.dmg",
  "*.iso",
  "*.tar",
  "*.tar.bz2",
  "*.tar.gz",
  "*.tbz2",
  "*.tgz",
}

-- setting variables for special settings {{{1
vim.g.mapleader = ','

vim.g.vimsyn_folding = 'afmpPrt'
-- augroups ___________/ ||||||
-- fold functions _______/|||||
-- fold mzscheme script __/||||
-- fold perl     script ___/|||
-- fold python   script ____/||
-- fold ruby     script _____/|
-- fold tcl      script ______/
vim.g.netrw_browsex_viewer = 'xdg-open'

-- Hard code paths that work for Arch Linux and CentOS.
--vim.g.python3_host_prog = 'python3'
--vim.g.python_host_prog = 'python2'
-- Disable python 2 support
vim.g.loaded_python_provider = 0

-- taken from http://stackoverflow.com/a/7490288
vim.g.php_folding = 0        -- Set PHP folding of classes and functions.
--vim.g.php_htmlInStrings = 1  -- Syntax highlight HTML code inside PHP strings.
--vim.g.php_sql_query = 1      -- Syntax highlight SQL code inside PHP strings.
--vim.g.php_noShortTags = 1    -- Disable PHP short tags.
