set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)
set cyan (set_color -o cyan)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'no'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate 'D'
set __fish_git_prompt_char_stagedstate 'S'
set __fish_git_prompt_char_untrackedfiles 'U'
#set __fish_git_prompt_char_stashstate 'A'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'


function fish_right_prompt
end

function fish_prompt
  set last_status $status
  printf '%s%s λ ' (prompt_pwd) (__fish_git_prompt)
end
