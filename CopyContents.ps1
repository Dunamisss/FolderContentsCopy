<#
.SYNOPSIS
Generates a clean UTF-8 encoded text file listing of all files in a specified folder on the Desktop.

.DESCRIPTION
This script creates a UTF-8 encoded text file on the Desktop that lists all files
in the specified folder (without subdirectories), sorted alphabetically. The output
file name includes the folder name for easy identification. Error handling is
implemented to handle various edge cases and provide meaningful feedback.

.PARAMETER FolderPath
The path of the folder to generate a file listing for.

.EXAMPLE
.\CopyContents.ps1 "C:\MyFolder"
Generates a file listing for C:\MyFolder on the Desktop.
#>

#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Path of the folder to process")]
    [ValidateScript({
        if (-not (Test-Path -Path $_ -PathType Container)) {
            throw "The path '$_' is not a valid folder or does not exist"
        }
        $true
    })]
    [string]$FolderPath
)

# Set strict mode for better error handling
Set-StrictMode -Version Latest

try {
    # Get the Desktop Folder Path - uses reliable method
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    Write-Verbose "Desktop path detected: $DesktopPath"

    # Clean up the folder name for the filename
    $FolderName = Split-Path $FolderPath -Leaf
    $FileName = "Contents - $FolderName.txt"
    $OutputPath = Join-Path -Path $DesktopPath -ChildPath $FileName

    Write-Verbose "Generating file listing for: $FolderPath"
    Write-Verbose "Output will be saved to: $OutputPath"

    # Remove existing file if it exists to avoid appending to old content
    if (Test-Path -Path $OutputPath -PathType Leaf) {
        Write-Verbose "Removing existing output file: $OutputPath"
        Remove-Item -Path $OutputPath -Force -ErrorAction Stop
    }

    # Get all files in the current folder (NOT subdirectories)
    # Sort them alphabetically for neatness
    $Files = Get-ChildItem -Path $FolderPath -File -ErrorAction Stop | Sort-Object Name

    if ($null -eq $Files -or $Files.Count -eq 0) {
        Write-Warning "The folder '$FolderPath' contains no files"
        # Create empty file to indicate processing completed
        New-Item -Path $OutputPath -ItemType File -Force | Out-Null
        return
    }

    Write-Verbose "Found $($Files.Count) files"

    # Extract file names directly and write all at once for better performance
    $FileNames = $Files | Select-Object -ExpandProperty Name
    $FileNames | Out-File -FilePath $OutputPath -Encoding UTF8 -NoClobber -ErrorAction Stop

    Write-Verbose "File listing successfully created: $OutputPath"

}
catch [System.IO.IOException] {
    Write-Error "IO Error: $_"
    Write-Error "Error details: $($_.Exception.Message)"
    Write-Error "Target: $($_.Exception.TargetSite)"
    return 1
}
catch [System.Security.SecurityException] {
    Write-Error "Security Error: Access denied. You don't have permissions to access this location"
    Write-Error "Error details: $($_.Exception.Message)"
    return 2
}
catch {
    Write-Error "An unexpected error occurred: $_"
    Write-Error "Error details: $($_.Exception.Message)"
    Write-Error "Stack trace: $($_.ScriptStackTrace)"
    return 99
}

Write-Verbose "Script execution completed successfully"
return 0