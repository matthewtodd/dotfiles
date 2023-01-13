set fish_prompt_pwd_dir_length 0

set __fish_git_prompt_showcolorhints true
set __fish_git_prompt_showdirtystate true
set __fish_git_prompt_showstashstate true
set __fish_git_prompt_showuntrackedfiles true
set __fish_git_prompt_showupstream verbose

set __fish_git_prompt_char_upstream_prefix ' u'
set __fish_git_prompt_char_upstream_behind '-'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_diverged '+'

function fish_prompt
  printf '%s%s ' (prompt_pwd | sed -e 's/.*\//…\//') (fish_git_prompt)
end

