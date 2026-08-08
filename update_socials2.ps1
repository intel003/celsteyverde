$data = @{
    "sebastiã¡n ydrny" = @{ "ig" = "https://www.instagram.com/sebasydrny?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/SYdrny" }
    "laura nãºã±ez" = @{ "ig" = "https://www.instagram.com/lauranunez9627?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/lauris_nunez?s=20" }
    "sergio leguizamã³n" = @{ "ig" = "https://www.instagram.com/sglegui?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/Sergiog55553274?s=20" }
    "karol victoria churio" = @{ "ig" = "https://www.instagram.com/delegadasvnbsas?igsh=aDdmZDhwc3o1NmRz"; "x" = "https://x.com/delegadxssec" }
}

$htmlPath = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
$html = Get-Content -Path $htmlPath -Raw -Encoding UTF8

$cards = [regex]::Matches($html, '(?s)<div class="candidato-card" data-name="([^"]+)".*?<div class="candidata-socials">(.*?)</div>\s*</div>')

foreach ($card in $cards) {
    $name = $card.Groups[1].Value.Trim().ToLower()
    
    if ($data.ContainsKey($name)) {
        $links = $data[$name]
        $socialBlock = $card.Groups[2].Value
        
        $socialBlockParts = $socialBlock -split '<a href="[^"]*"'
        if ($socialBlockParts.Length -ge 3) {
            $newSocialBlock = $socialBlockParts[0] + '<a href="' + $links["x"] + '" target="_blank"' + $socialBlockParts[1] + '<a href="' + $links["ig"] + '" target="_blank"' + $socialBlockParts[2]
            
            $html = $html.Replace($card.Groups[2].Value, $newSocialBlock)
        }
    }
}

Set-Content -Path $htmlPath -Value $html -Encoding UTF8
Write-Host "Updated second batch!"
