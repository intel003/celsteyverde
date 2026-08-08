$data = @{
    "ailen basualdo" = @{ "ig" = "https://www.instagram.com/ailenbasualdo.sec?igsh=MWVsdXh0MjU4bjhuOA%3D%3D&utm_source=qr"; "x" = "#" }
    "estela lopez" = @{ "ig" = "https://www.instagram.com/estela_lopez89?igsh=MXA5bGpyZmN0ejlqMw=="; "x" = "https://x.com/LopezEste1989" }
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
Write-Host "Updated Ailen Basualdo and Estela Lopez!"
