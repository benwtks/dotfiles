# Based on Robby Russell's theme

local ret_status="%(?:%{$fg_bold[green]%}○:%{$fg_bold[red]%}○)"
local ret_status_end="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"

PROMPT='%{$fg[cyan]%} %n@%m %{$reset_color%}in %{$fg_bold[green]%}%c%{$reset_color%} $(git_prompt_info)
${ret_status_end} %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="on %{$fg_bold[blue]%}git:(%{$fg_bold[red]%}  "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} ) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%} )"
