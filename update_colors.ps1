$htmlPath = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
$lines = Get-Content -Path $htmlPath -Encoding UTF8

$output = @()
$inGrid = $false
$count = 0

foreach ($line in $lines) {
    if ($line -match '<div class="candidatas-grid candidatos-uniforme-grid">') {
        $inGrid = $true
        $output += $line
    } elseif ($line -match '</div>' -and $inGrid) {
        # This could close the grid, but let's be careful. Let's just rely on the text color spans.
        $output += $line
    } elseif ($inGrid -and $line -match '<span class="candidato-puesto text-(celeste|verde)">') {
        # Determine the color: 2 celeste, 2 verde
        $color = if (($count % 4) -lt 2) { "celeste" } else { "verde" }
        
        # Replace the class
        $line = $line -replace 'text-celeste|text-verde', "text-$color"
        
        $output += $line
        $count++
    } else {
        $output += $line
    }
}

Set-Content -Path $htmlPath -Value $output -Encoding UTF8
