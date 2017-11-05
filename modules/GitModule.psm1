<#
.SYNOPSIS
Copies default .gitignore and .gitattribute files to the current directory

.DESCRIPTION
The default .gitignore file is optimized for Visual Studio and VS Code. The default .gitattributes file defaults the project to check in as LF check out as whatever line endings.
#>
Function Add-GitInitFiles
{
    Copy-Item $PSScriptRoot\..\assets\.gitignore .
    Copy-Item $PSScriptRoot\..\assets\.gitattributes .
    Copy-Item $PSScriptRoot\..\assets\mit-license.txt .\LICENSE
}
Set-Alias getgitfiles Add-GitInitFiles

<#
.SYNOPSIS
Initializes git directory and adds default .gitignore and .gitattributes file

.DESCRIPTION
Initializes git directory and calls Add-GitInitFiles
#>
Function Initialize-GitDirectory
{
    git init
    Add-GitInitFiles
}
Set-Alias gitinit Initialize-GitDirectory