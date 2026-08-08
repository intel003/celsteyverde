$html = Get-Content -Path "c:/Users/sebas/Documents/pagina wep/candidatos.html" -Raw -Encoding UTF8

$html = $html -replace "EstadÃ­stica", "Estad&iacute;stica"
$html = $html -replace "DifusiÃ³n", "Difusi&oacute;n"
$html = $html -replace "AdministraciÃ³n", "Administraci&oacute;n"
$html = $html -replace "OrganizaciÃ³n", "Organizaci&oacute;n"
$html = $html -replace "CapacitaciÃ³n", "Capacitaci&oacute;n"
$html = $html -replace "DocumentaciÃ³n", "Documentaci&oacute;n"
$html = $html -replace "GÃ©neros", "G&eacute;neros"
$html = $html -replace "BursÃ¡tiles", "Burs&aacute;tiles"
$html = $html -replace "PrevisiÃ³n", "Previsi&oacute;n"

# Fix the color pattern
$cards = [regex]::Matches($html, '(?s)<div class="candidato-card".*?</div>\s*</div>\s*</div>\s*</div>')
if ($cards.Count -gt 0) {
    # Not using regex to replace one by one, let's use a simpler approach
    # We will split the HTML by '<span class="candidato-puesto text-'
    $parts = $html -split '<span class="candidato-puesto text-'
    $newHtml = $parts[0]
    for ($i = 1; $i -lt $parts.Length; $i++) {
        $colorClass = if ([math]::Floor(($i - 1) / 2) % 2 -eq 0) { "celeste" } else { "verde" }
        # The split removed `<span class="candidato-puesto text-`, and the rest of the string starts with `celeste">` or `verde">`
        # We need to replace the `celeste` or `verde` at the start of $parts[$i]
        $rest = $parts[$i] -replace "^(celeste|verde)", $colorClass
        $newHtml += '<span class="candidato-puesto text-' + $rest
    }
    $html = $newHtml
}

Set-Content -Path "c:/Users/sebas/Documents/pagina wep/candidatos.html" -Value $html -Encoding UTF8
Write-Host "Done"
