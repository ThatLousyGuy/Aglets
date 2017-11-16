Get-ChildItem $PSScriptRoot\modules\*.psm1 | Import-Module

$Global:DefaultBookmarksFile = "$PSScriptRoot\bookmarks.txt"
$Global:BookmarksFiles = @($Global:DefaultBookmarksFile)
Function Open-BookmarkFromGlobalFiles
{
    param([string]$Alias)
    Open-BookmarkFromFiles $Global:BookmarksFiles $Alias
}
Set-Alias b Open-BookmarkFromGlobalFiles