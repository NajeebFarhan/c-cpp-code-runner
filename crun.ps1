function crun {
    param (
        [string]$fileName,
        [string[]]$argv
    )

    # Check if the file name is provided
    if (-not $fileName) {
        Write-Host "Usage: Run-CProgram <source-file.c/cpp> [args...]"
        return
    }

    # Check if the file exists
    if (-Not (Test-Path $fileName)) {
        Write-Host "File $fileName does not exist."
        return
    }

    # Determine the file extension
    $fileExtension = [System.IO.Path]::GetExtension($fileName).ToLower()
    if ($fileExtension -ne ".c" -and $fileExtension -ne ".cpp") {
        Write-Host "File must have a .c or .cpp extension."
        return
    }

    # Extract the base name without the extension
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $exeName = "$baseName.exe"

    # Compile the C or C++ program
    if ($fileExtension -eq ".c") {
        gcc $fileName -o $exeName
    }
    elseif ($fileExtension -eq ".cpp") {
        g++ $fileName -o $exeName
    }

    # Check if the compilation was successful
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Compilation failed."
        return
    }

    # Run the executable with the provided arguments
    & .\$exeName $argv

    # Remove the executable
    Remove-Item .\$exeName 
}