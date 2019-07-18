##########################################################################################
# Powershell script to batch convert files to .tx using maketx.exe
# Insert this file into the folder containing the images you want to converted
# Change the $cmd variable to the location of your maketx.exe
# Run this script and all images in the folder and subfolders will be converted to .tx   
##########################################################################################

Write-Output $PSScriptRoot

Get-ChildItem -Recurse $PSScriptRoot |
ForEach-Object {
    $file = $_.FullName
    $file_tx = ($_.DirectoryName + '\' + $_.BaseName + '.tx')
    $arg1 = '-v'
    $arg2 = '-u'
    $arg3 = '--oiio'
    $arg4 = '-o'        
    $cmd = "C:\solidangle\mtoadeploy\2017\bin\maketx.exe"

    # Check if the current index is a file and not a folder
    if (Test-Path -Path $file -PathType Leaf) {
        # If current index is a file, check if a .tx of it already exists
        if (Test-Path -Path $file_tx) {
            $file_d = (Get-ItemProperty -Path $file -Name LastWriteTime).lastwritetime
            $file_tx_d = (Get-ItemProperty -Path $file_tx -Name LastWriteTime).lastwritetime

            # Check if the file is newer than its .tx variant
            if ($file_d -gt $file_tx_d) {
                & $cmd $arg1 $arg2 $arg3 $file $arg4 $file_tx
            }
            else {
                Write-Output "Tx file was found and is newer than the non-tx file!"
            }
        }

        # If no .tx file was found, create one
        else {
            & $cmd $arg1 $arg2 $arg3 $file $arg4 $file_tx
        }
    }
}