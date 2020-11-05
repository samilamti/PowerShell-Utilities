. ./Use-Location.ps1

$RepositoryPaths = @('PATH 1'; 'PATH 2'; '...'; 'PATH N')

$DefaultPrompt = @{ NoNewLine = $true; ForegroundColor = [ConsoleColor]::White; BackgroundColor = [ConsoleColor]::Black }
$HighlightPrompt = @{ NoNewLine = $true; ForegroundColor = [ConsoleColor]::Yellow; BackgroundColor = [ConsoleColor]::Black }
$DefaultAnswerPrompt = @{ NoNewLine = $true; ForegroundColor = [ConsoleColor]::Cyan; BackgroundColor = [ConsoleColor]::Black }

$RepositoryPaths | ForEach-Object {
    Use-Location $_ {
        $(git branch --list) |
        
        # Exclude active branch, "main" and "master" branches.
        Where-Object { $_ -notmatch '\* ' } |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -ne "main" -and $_ -ne "master" } |

        # Stash away our candidate branches so that the user can make decisions on them
        Select-Object -PipelineVariable Candidates |

        ForEach-Object { 
            Write-Host "Would you like to delete " @DefaultPrompt
            Write-Host $_ @HighlightPrompt
            Write-Host "? (" @DefaultPrompt
            Write-Host "Y" @DefaultAnswerPrompt
            Write-Host "/n) " @DefaultPrompt
            Read-Host -PipelineVariable Responses 
        } |

        # Remove any branches that the user confirmed
        Where-Object { $Responses -notmatch "n" } |
        ForEach-Object { git branch --delete --force $Candidates }
    }
}
