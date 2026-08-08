$data = @{
    "celeste poelstra" = @{ "ig" = "https://www.instagram.com/celespoel?igsh=bGpqd2g5eGt6b3pm"; "x" = "https://x.com/celestePoelstr2" }
    "daniel mayorano" = @{ "ig" = "https://www.instagram.com/danielmayorano?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/DanielMayorano" }
    "julieta carbonell" = @{ "ig" = "https://www.instagram.com/carbonell.julieta?igsh=ZDB6czcwYzJmMzNu"; "x" = "https://x.com/carbonell_julii" }
    "axel silecki" = @{ "ig" = "https://www.instagram.com/megatechdelegadxs?igsh=MTdjcHE0ZWN2amtleg=="; "x" = "https://x.com/MegaDelegados" }
    "romina solano" = @{ "ig" = "https://www.instagram.com/romina.solano_?igsh=dW81amlnb2pvbGtu"; "x" = "https://x.com/romina_diffupar" }
    "mariana lezcano" = @{ "ig" = "https://www.instagram.com/mariana_lezcano12?igsh=MXYwZGJtbXV1dDZ2ag=="; "x" = "https://x.com/soleano" }
    "diego osores" = @{ "ig" = "https://www.instagram.com/diegodelegado.sec?igsh=MTUybGNrd2xyMXZ2bA=="; "x" = "https://x.com/diegoclasher" }
    "karol churio" = @{ "ig" = "https://www.instagram.com/delegadasvnbsas?igsh=aDdmZDhwc3o1NmRz"; "x" = "https://x.com/delegadxssec" }
    "sergio ortiz" = @{ "ig" = "https://www.instagram.com/ortiz.sergio_ok_?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/Sergio_OrtizOk?s=20" }
    "sebastian ydrny" = @{ "ig" = "https://www.instagram.com/sebasydrny?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/SYdrny" }
    "silvio gramajo" = @{ "ig" = "https://www.instagram.com/silvio_gramajo_06?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/silvio_gramajo?s=20" }
    "laura nÃºÃ±ez" = @{ "ig" = "https://www.instagram.com/lauranunez9627?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/lauris_nunez?s=20" }
    "laura nuñez" = @{ "ig" = "https://www.instagram.com/lauranunez9627?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/lauris_nunez?s=20" }
    "sergio leguizamon" = @{ "ig" = "https://www.instagram.com/sglegui?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/Sergiog55553274?s=20" }
    "diego rojas" = @{ "ig" = "https://www.instagram.com/diego.r.rojas.5?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/diegoteruben80?s=20" }
    "oscar carrozas" = @{ "ig" = "https://www.instagram.com/carrozaz?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/oscarcarrozaz?s=20" }
    "jorge lÃ³pez" = @{ "ig" = "https://www.instagram.com/jorgelopezsec?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/jorgelopezsec?s=20" }
    "jorge lópez" = @{ "ig" = "https://www.instagram.com/jorgelopezsec?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/jorgelopezsec?s=20" }
}

$htmlPath = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
$html = Get-Content -Path $htmlPath -Raw -Encoding UTF8

$allNames = @()
$missingNames = @()

$cards = [regex]::Matches($html, '(?s)<div class="candidato-card" data-name="([^"]+)".*?<div class="candidata-socials">(.*?)</div>\s*</div>')

foreach ($card in $cards) {
    $name = $card.Groups[1].Value.Trim().ToLower()
    $allNames += $name
    
    if ($data.ContainsKey($name)) {
        $links = $data[$name]
        $socialBlock = $card.Groups[2].Value
        
        # Replace hrefs in the social block
        # The first SVG is X, the second is Instagram
        $socialBlockParts = $socialBlock -split '<a href="[^"]*"'
        if ($socialBlockParts.Length -ge 3) {
            $newSocialBlock = $socialBlockParts[0] + '<a href="' + $links["x"] + '" target="_blank"' + $socialBlockParts[1] + '<a href="' + $links["ig"] + '" target="_blank"' + $socialBlockParts[2]
            
            # Reconstruct the card match to replace exactly this instance
            # Since $html -replace can be tricky with multiple identical parts, we replace using substring
            $html = $html.Replace($card.Groups[2].Value, $newSocialBlock)
        }
    } else {
        $missingNames += $name
    }
}

Set-Content -Path $htmlPath -Value $html -Encoding UTF8
$missingNames | Out-File "c:/Users/sebas/Documents/pagina wep/missing_socials.txt" -Encoding UTF8
Write-Host "Updated!"
