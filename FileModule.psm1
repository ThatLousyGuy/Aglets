Function Find-FilesContaining
{
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$SearchStr,
    [string]$SearchFiles='*.*',
    [switch]$Files,
    [int]$Before=0,
    [int]$After=0
)
    if ($Files)
    {
        Get-ChildItem -Recurse -Include $SearchFiles |
            Select-String "$SearchStr" -Context $Before,$After |
            Select-Object Path
    }
    else
    {
        Get-ChildItem -Recurse -Include $SearchFiles |
            Select-String "$SearchStr" -Context $Before,$After
    }
}
Set-Alias ffc Find-FilesContaining

Function Show-FilesRecursive
{
    Get-ChildItem -r -i *.* | Select FullName
}
Set-Alias ef Show-FilesRecursive
