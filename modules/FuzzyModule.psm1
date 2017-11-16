<#
.SYNOPSIS
Returns a score representing the string closeness. A higher score means the strings are closer.

.DESCRIPTION
The current implementation returns the length of the longest subsequence of letters in common between the given strings (a.k.a. the greatest common subsequence length).

.EXAMPLE
Get-FuzzyScore cat cart # returns 3
.EXAMPLE
Get-FuzzyScore cat dog # returns 0
.EXAMPLE
ls | Select {Get-FuzzyScore dog $_}
#>
Function Get-FuzzyScore
{
    Param
    (
        [Parameter(Mandatory=$True, Position=1)]
        [string]$FuzzyName="",
        [Parameter(Mandatory=$True, Position=2, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [string]$Name=""
    )
    
    Begin
    {
        $str1 = $FuzzyName.ToLower()
    }

    Process
    {
        $str2 = $Name.ToLower()

        # Degenerate cases
        if (($str1.Length -eq 0) -or ($str2.Length -eq 0))
        {
            return 0
        }
        
        $arr1 = @(0) * $str2.Length + 0
        $arr2 = @(0) * $str2.Length + 0

        for ($i = 1; $i -le $str1.Length; $i++)
        {
            for ($j = 1; $j -le $str2.Length; $j++)
            {
                if ($str1[$i-1] -eq $str2[$j-1])
                {
                    $arr2[$j] = $arr1[$j-1] + 1
                }
                else
                {
                    $arr2[$j] = [math]::Max($arr1[$j], $arr2[$j-1])
                }
            }
            $arr1 = $arr2.Clone()
        }

        return $arr2[-1]
    }
}
Set-Alias fscore Get-FuzzyScore

<#
.SYNOPSIS
Returns the objects with the closest matching strings to the fuzzy string 

.DESCRIPTION
Calls Get-FuzzyScore on all objects and returns the objects sorted in the order (highest fuzzy score, shortest string length)

.EXAMPLE
ls | Get-BestFuzzyMatch filenme -First 10
.EXAMPLE
ls | Get-BestFuzzyMath filenma
.EXAMPLE
ls | Get-BestFuzzyMath filenma -Member Name
#>
Function Get-BestFuzzyMatch
{
    Param
    (
        [Parameter(Mandatory=$True, Position=1)]
        [string]$FuzzyName,
        [Parameter(Mandatory=$True, Position=2, ValueFromPipeline=$True)]
        [object[]]$Inputs,
        [string]$Member="Name",
        [int]$First=1
    )
    # Sort by greatest common subsequence
    # Then sort by shortest length
    # Use the automatic variable $input to have access to the whole pipeline
    return $input | Sort-Object @{Expression={
                                    if ($_.GetType().Name -eq 'string')
                                    {
                                        Get-FuzzyScore $FuzzyName $_
                                    }
                                    else
                                    {
                                        Get-FuzzyScore $FuzzyName $_."$Member"
                                    }}; Descending=$true}, 
                                @{Expression={
                                    if ($_.GetType().Name -eq 'string')
                                    {
                                        $_.Length
                                    }
                                    else
                                    {
                                         ($_."$Member").Length
                                    }}; Ascending=$true} |
                    Select-Object -First $First
}
Set-Alias fuzz Get-BestFuzzyMatch
