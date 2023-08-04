# Aliases
Set-Alias vim nvim

# Prompt
# Default:
# oh-my-posh init pwsh | Invoke-Expression
# Custom:
oh-my-posh init pwsh --config 'C:/Users/Hayden ... /Documents/PowerShell/myprofile.omp.json' | Invoke-Expression

# Functions
function whereis ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
	Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Terminal Icons
Import-Module Terminal-Icons

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -PredictionViewStyle ListView
