if exists("current_compiler")
  finish
endif

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

runtime compiler/cargo.vim
let current_compiler = "rust"

CompilerSet makeprg=cargo\ check\ --message-format=short\ $*

let &cpo = s:cpo_save
unlet s:cpo_save
