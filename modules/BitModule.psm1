<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE
.EXAMPLE
#>
Function ConvertTo-HResult
{
    Param
    (
        [Parameter(Mandatory=$True, Position=1)]
        [int]$Severity,
        [Parameter(Mandatory=$True, Position=2)]
        [int]$Facility,
        [Parameter(Mandatory=$True, Position=3, ValueFromPipeline=$True)]
        [int]$Code
    )
    
    Process
    {
        return ($Severity -shl 31) -bor ($Facility -shl 16) -bor ($code)
    }
}
Set-Alias hr ConvertTo-HResult

Function Convert-IntToHex
{
    param(
        [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$True)]
        [int]$Value
    )
    Process
    {
        return "0x{0:X}" -f $Value
    }
}
Set-Alias hex Convert-IntToHex