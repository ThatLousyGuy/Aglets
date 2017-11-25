Function Get-Gif
{
    Param(
        [Parameter(Mandatory=$True, Position=1)]
        [string]$InputFile,
        [Parameter(Mandatory=$True, Position=2)]
        [string]$OutputFile
    )
    ffmpeg.exe -v warning -i $InputFile -lavfi "fps=30,scale=640:-1:flags=experimental,split[x][y],[x]palettegen=stats_mode=diff[pal],[y][pal]paletteuse=new=1" $OutputFile
}