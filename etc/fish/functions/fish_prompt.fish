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
  # Show any backgrounded job, since I get confused about whether I've backgrounded vim all the time.
  # jobs -c shows the command name only, not the PID or anything.
  # jobs -l shows only the latest background job, which is probably good enough for me.
  # Use tail -1 because jobs still prints out a Command header.
  set -l last_job_command (jobs -cl | tail -1)

  if test -n $last_job_command
    set last_job " "$(set_color brmagenta)"["$last_job_command"]"$(set_color normal)
  end

  printf '%s%s%s ' (prompt_pwd | sed -e 's/.*\//…\//') (fish_git_prompt) $last_job
end

