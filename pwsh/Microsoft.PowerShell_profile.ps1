Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

# PSReadLine
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo
Set-PSReadLineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+LeftArrow" -Function BackwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+UpArrow" -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key "Ctrl+DownArrow" -Function HistorySearchForward

# New-Alias <alias> <aliased-command>
New-Alias open ii

# oh-my-posh
oh-my-posh init pwsh | Invoke-Expression

# pyenv-venv
pyenv-venv init root

