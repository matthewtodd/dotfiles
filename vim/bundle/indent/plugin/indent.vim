" blatantly stolen from
" http://github.com/austintaylor/.vim/blob/e058a3d2a07f59ec1a8cc283475b24d9abcbe71a/.vimrc#L214-259

onoremap <silent>ai :<C-u>call indent#indent_text_object(0)<CR>
onoremap <silent>ii :<C-u>call indent#indent_text_object(1)<CR>
vnoremap <silent>ai :<C-u>call indent#indent_text_object(0)<CR><Esc>gv
vnoremap <silent>ii :<C-u>call indent#indent_text_object(1)<CR><Esc>gv

function! indent#indent_text_object(inner)
  if &filetype == 'haml' || &filetype == 'sass' || &filetype == 'python'
    let meaningful_indentation = 1
  else
    let meaningful_indentation = 0
  endif
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") =~ "^\\s*$"
    return
  endif
  let p = line(".") - 1
  let nextblank = getline(p) =~ "^\\s*$"
  while p > 0 && (nextblank || indent(p) >= i )
    -
    let p = line(".") - 1
    let nextblank = getline(p) =~ "^\\s*$"
  endwhile
  if (!a:inner)
    -
  endif
  normal! 0V
  call cursor(curline, 0)
  let p = line(".") + 1
  let nextblank = getline(p) =~ "^\\s*$"
  while p <= lastline && (nextblank || indent(p) >= i )
    +
    let p = line(".") + 1
    let nextblank = getline(p) =~ "^\\s*$"
  endwhile
  if (!a:inner && !meaningful_indentation)
    +
  endif
  normal! $
endfunction
