Get-ChildItem $PSScriptRoot\modules\*.psm1 | Import-Module

$Global:DefaultBookmarksFile = "$PSScriptRoot\bookmarks.txt"
$Global:BookmarksFiles = @($Global:DefaultBookmarksFile)
Function Open-BookmarkFromGlobalFiles
{
    param([string]$Alias)
    Open-BookmarkFromFiles $Global:BookmarksFiles $Alias
}
Set-Alias b Open-BookmarkFromGlobalFiles

Function Find-BookmarksFromGlobalFiles
{
    param([string]$Alias)
    Write-Host
    Write-Host
    Write-Host "    Closest alias matches to '$Alias'"
    Write-Host
    Write-Host

    Get-FuzzyBookmarksFromFiles $Global:BookmarksFiles $Alias
}
Set-Alias fb Find-BookmarksFromGlobalFiles

Function Get-ParentDirectory
{
    param([string]$Path)
    Set-Clipboard (Split-Path -Parent $Path)
}
Set-Alias clipp Get-ParentDirectory

Function Start-ParentDirectory
{
    param([string]$Path)
    start (Split-Path -Parent $Path)
}
Set-Alias startp Start-ParentDirectory