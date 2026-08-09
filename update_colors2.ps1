$htmlPath = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
# Read without adding BOM when writing back
$bytes = [System.IO.File]::ReadAllBytes($htmlPath)
$text = [System.Text.Encoding]::UTF8.GetString($bytes)

# Normalize line endings
$lines = $text -split "`r`n|`n"
$output = @()
$count = 0

foreach ($line in $lines) {
    if ($line -match 'class="candidato-puesto text-(celeste|verde)"') {
        $color = if (($count % 4) -lt 2) { "celeste" } else { "verde" }
        $line = $line -replace 'text-(celeste|verde)', "text-$color"
        $count++
    }
    $output += $line
}

# Write without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($htmlPath, $output, $utf8NoBom)
