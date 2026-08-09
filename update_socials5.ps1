$data = @{
    "sergio leguizamÃ³n" = @{ "ig" = "https://www.instagram.com/sglegui?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/Sergiog55553274?s=20" }
    "laura nÃºÃ±ez" = @{ "ig" = "https://www.instagram.com/lauranunez9627?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/lauris_nunez?s=20" }
    "oscar carrozas" = @{ "ig" = "https://www.instagram.com/carrozaz?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/oscarcarrozaz?s=20" }
    "sebastiÃ¡n ydrny" = @{ "ig" = "https://www.instagram.com/sebasydrny?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/SYdrny" }
    "jorge lÃ³pez" = @{ "ig" = "https://www.instagram.com/jorgelopezsec?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/jorgelopezsec?s=20" }
    "julieta carbonell" = @{ "ig" = "https://www.instagram.com/carbonell.julieta?igsh=ZDB6czcwYzJmMzNu"; "x" = "https://x.com/carbonell_julii" }
    "mariana lezcano" = @{ "ig" = "https://www.instagram.com/mariana_lezcano12?igsh=MXYwZGJtbXV1dDZ2ag=="; "x" = "https://x.com/soleano" }
    "diego osores" = @{ "ig" = "https://www.instagram.com/diegodelegado.sec?igsh=MTUybGNrd2xyMXZ2bA=="; "x" = "https://x.com/diegoclasher" }
}

$htmlPath = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
$html = Get-Content -Path $htmlPath -Raw -Encoding UTF8

$cards = [regex]::Matches($html, '(?s)<div class="candidato-card" data-name="([^"]+)".*?<div class="candidata-socials">\s*<a href="([^"]*)"[^>]*>.*?</a>\s*<a href="([^"]*)"[^>]*>.*?</a>\s*</div>')

foreach ($card in $cards) {
    $name = $card.Groups[1].Value.Trim().ToLower()
    
    if ($data.ContainsKey($name)) {
        $links = $data[$name]
        
        $socialBlockMatch = [regex]::Match($card.Value, '(?s)<div class="candidata-socials">(.*?)</div>')
        
        $newX = '<a href="' + $links["x"] + '" target="_blank" rel="noopener noreferrer" class="social-icon x-icon" aria-label="X (Twitter)">X</a>'
        $newIg = '<a href="' + $links["ig"] + '" target="_blank" rel="noopener noreferrer" class="social-icon ig-icon" aria-label="Instagram">IG</a>'
        
        $newSocialBlock = "`n                    " + $newX + "`n                    " + $newIg + "`n                "
        
        $html = $html.Replace($socialBlockMatch.Value, '<div class="candidata-socials">' + $newSocialBlock + '</div>')
        Write-Host "Updated $($name)"
    }
}

Set-Content -Path $htmlPath -Value $html -Encoding UTF8
