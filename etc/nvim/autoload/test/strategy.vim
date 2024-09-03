function! s:neovim_new_term(cmd) abort
  let term_position = get(g:, 'test#neovim#term_position', 'vert botright 80')
  execute term_position . ' new'
  " execute 'set winfixwidth'
  call termopen(a:cmd)
endfunction

function! s:neovim_reopen_term(bufnr) abort
  let l:current_window = win_getid()
  let term_position = get(g:, 'test#neovim#term_position', 'vert botright 80')
  execute term_position . ' sbuffer ' . a:bufnr
  " execute 'set winfixwidth'

  let l:new_window = win_getid()
  call win_gotoid(l:current_window)
  return l:new_window
endfunction

function! test#strategy#neovim_sticky(cmd) abort
  let l:cmd = [a:cmd, '']
  let l:tag = '_test_vim_neovim_sticky'
  let l:buffers = getbufinfo({ 'buflisted': 1 })
    \ ->filter({i, v -> has_key(v.variables, l:tag)})

  if len(l:buffers) == 0
    let l:current_window = win_getid()
    call s:neovim_new_term(&shell)
    let b:[l:tag] = 1
    let l:buffers = getbufinfo(bufnr())
    call win_gotoid(l:current_window)
  else
    if !get(g:, 'test#preserve_screen', 0)
      let l:cmd = [&shell == 'cmd.exe' ? 'cls': 'clear'] + l:cmd
    endif
    if get(g:, 'test#neovim_sticky#kill_previous', 0)
      let l:cmd = [""] + l:cmd
    endif
  endif

  let l:win = win_findbuf(l:buffers[0].bufnr)
  if !len(l:win) && get(g:, 'test#neovim_sticky#reopen_window', 1)
    let l:win = [s:neovim_reopen_term(l:buffers[0].bufnr)]
  endif

  call chansend(l:buffers[0].variables.terminal_job_id, l:cmd)
  if len(l:win) > 0
    call win_execute(l:win[0], 'normal G', 1)
  endif
endfunction
