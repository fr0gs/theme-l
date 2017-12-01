# name: L
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _is_git_staged
  echo (command git diff --cached --no-ext-diff --quiet --exit-code ^/dev/null)
end

function _is_git_stashed
  echo (command git rev-parse --verify --quiet refs/stash >/dev/null)
end


function fish_prompt
  set -l blue (set_color -o blue)
  set -l brblue (set_color -o brblue)
  set -l red (set_color -o red)
  set -l brred (set_color -o brred)
  set -l green (set_color -o green)
  set -l normal (set_color normal)
  set -l yellow (set_color -o yellow)
  set -l bryellow (set_color -o bryellow)


  set -l lambda $yellow(echo "λ")
  set -l cwd $blue(basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set git_info $green(_git_branch_name)
    set git_info ":$git_info"

    if [ (_is_git_staged) ]
      set git_info $bryellow(_git_branch_name)
      set git_info ":$git_info"
    end
    if [ (_is_git_dirty) ] # If it is staged and dirty, dirty takes priority
      set git_info $red(_git_branch_name)
      set git_info ":$git_info*"
    end
    if [ (_is_git_stashed) ]
      set git_info ":$git_info (stash)"
    end
  end

  echo -n -s $cwd $git_info $normal ' ' $lambda ' '
end
