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