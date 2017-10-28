Function Open-Bookmark
{
param(
    [Parameter(Mandatory=$true)]
    [string]$Page
)
    if (Test-Path -PathType Container $Page)
    {
        cd $Page;
    }
    else
    {
        start $Page;
    }
}

# Bookmarks should be of the form
# [alias]|[page]
Function Open-BookmarkFromFile
{
param(
    [Parameter(Mandatory=$true)]
    [string]$Filename,
    [Parameter(Mandatory=$true)]
    [string]$Alias
)
    # Quit early if the file doesn't exist
    if (-not (Test-Path $Filename))
    {
        return;
    }

    # Split each line on the delimiter and create the alias
    $fileContent = Get-Content $Filename;
    $fileContent |
        ForEach-Object {
            $splitLine = $_.Split("|");
            if ( $splitLine -ne $null -and $splitLine.Length -ge 2 -and $splitLine[0].Trim() -eq $Alias)
            {
                Open-Bookmark $splitLine[1].Trim();
                return;
            }
        };
}
