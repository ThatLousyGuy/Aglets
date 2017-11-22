Import-Module $PSScriptRoot\FuzzyModule.psm1

Function Open-Bookmark
{
param(
    [Parameter(Mandatory=$true)]
    [string]$Page
)
    $expandedPage = $ExecutionContext.InvokeCommand.ExpandString($Page)
    if (Test-Path -PathType Container $expandedPage)
    {
        cd $expandedPage
    }
    else
    {
        start $expandedPage
    }
}

# Bookmarks should be of the form
# [alias]|[page]
Function Open-BookmarkFromFiles
{
param(
    [Parameter(Mandatory=$true)]
    [string[]]$Filenames,
    [Parameter(Mandatory=$true)]
    [string]$Alias
)
    # Quit early if the file doesn't exist
    $validFiles = $Filenames | Where-Object { Test-Path $_ }
    if ($validFiles.Count -eq 0)
    {
        return
    }

    # Split each line on the delimiter and create the alias
    $validFiles | Get-ChildItem | Get-Content |
        ForEach-Object {
            $splitLine = $_.Split("|")
            if ( $splitLine -ne $null -and $splitLine.Length -ge 2 -and $splitLine[0].Trim() -eq $Alias)
            {
                Open-Bookmark $splitLine[1].Trim()
                return
            }
        }
}

Function Get-FuzzyBookmarksFromFiles
{
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Filenames,
        [Parameter(Mandatory=$true)]
        [string]$Alias,
        [int]$First=5
    )

    # Quit early if the file doesn't exist
    $validFiles = $Filenames | Where-Object { Test-Path $_ }
    if ($validFiles.Count -eq 0)
    {
        return
    }

    $validFiles | Get-ChildItem | Get-Content |
        Where-Object { $_ -like '*|*' } |
        ForEach-Object {
            $splitLine = $_.Split("|");
            $ob = New-Object System.Object;
            $ob | Add-Member -Type NoteProperty -Name Alias -Value $splitLine[0].Trim();
            $ob | Add-Member -Type NoteProperty -Name Path -Value $ExecutionContext.InvokeCommand.ExpandString($splitLine[1].Trim())
            return $ob
        } | 
        Get-BestFuzzyMatch -Member Alias -FuzzyName $Alias -First $First |
        Select-Object Alias, Path
}