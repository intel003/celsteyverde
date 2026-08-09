$htmlPath = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
$lines = Get-Content -Path $htmlPath -Encoding UTF8

$output = @()
$inSocials = $false
$target = $null

foreach ($line in $lines) {
    if ($line -match '<div class="candidato-card" data-name="([^"]+)"') {
        $name = $matches[1]
        if ($name -match "jorge") { $target = "jorge" }
        elseif ($name -match "ydrny") { $target = "sebas" }
        elseif ($name -match "laura") { $target = "laura" }
        elseif ($name -match "leguizam") { $target = "sergio" }
        else { $target = $null }
        $output += $line
    } elseif ($line -match '<div class="candidata-socials">') {
        $output += $line
        if ($target) {
            $inSocials = $true
            if ($target -eq "jorge") {
                $output += '                            <a href="https://x.com/jorgelopezsec?s=20" target="_blank" rel="noopener noreferrer" class="social-icon x-icon" aria-label="X (Twitter)">X</a>'
                $output += '                            <a href="https://www.instagram.com/jorgelopezsec?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==" target="_blank" rel="noopener noreferrer" class="social-icon ig-icon" aria-label="Instagram">IG</a>'
            } elseif ($target -eq "sebas") {
                $output += '                            <a href="https://x.com/SYdrny" target="_blank" rel="noopener noreferrer" class="social-icon x-icon" aria-label="X (Twitter)">X</a>'
                $output += '                            <a href="https://www.instagram.com/sebasydrny?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==" target="_blank" rel="noopener noreferrer" class="social-icon ig-icon" aria-label="Instagram">IG</a>'
            } elseif ($target -eq "laura") {
                $output += '                            <a href="https://x.com/lauris_nunez?s=20" target="_blank" rel="noopener noreferrer" class="social-icon x-icon" aria-label="X (Twitter)">X</a>'
                $output += '                            <a href="https://www.instagram.com/lauranunez9627?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==" target="_blank" rel="noopener noreferrer" class="social-icon ig-icon" aria-label="Instagram">IG</a>'
            } elseif ($target -eq "sergio") {
                $output += '                            <a href="https://x.com/Sergiog55553274?s=20" target="_blank" rel="noopener noreferrer" class="social-icon x-icon" aria-label="X (Twitter)">X</a>'
                $output += '                            <a href="https://www.instagram.com/sglegui?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==" target="_blank" rel="noopener noreferrer" class="social-icon ig-icon" aria-label="Instagram">IG</a>'
            }
            Write-Host "Updated $target"
        } else {
            $inSocials = "skip"
        }
    } elseif ($inSocials -eq $true) {
        if ($line -match '</div>') {
            $inSocials = $false
            $output += $line
        }
    } elseif ($inSocials -eq "skip") {
        $output += $line
        if ($line -match '</div>') {
            $inSocials = $false
        }
    } else {
        $output += $line
    }
}

Set-Content -Path $htmlPath -Value $output -Encoding UTF8
