function Validate-File([string] $file) {
    $file_exists = Test-Path $file
    
    if (-not $file_exists) {
        "ERROR: '$file' does not exist" | Write-Error
        return $false 
    }

    # If file exists, convert $file into a Full path name, as it may be given relatively
    $file = (Get-Item -Path $file).FullName

    $lines_in_file = [System.IO.File]::ReadAllLines($file)
    $line_tab_detected = Detect-Tab $lines_in_file

    if ($line_tab_detected -gt 0) {
        "ERROR in '$file'`nTAB detected on line $line_tab_detected" | Write-Error 
        return $false
    }

    return $true
}

function Detect-Tab($lines) {
    for($i = 0; $i -lt $lines.count; $i++) {
        [string] $line = $lines[$i]
        if ($line.Contains("`t")) {
            return ($i + 1) 
        }
    }

    return 0
}
