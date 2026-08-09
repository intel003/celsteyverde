$data = @{
    "celeste poelstra" = @{ "ig" = "https://www.instagram.com/celespoel?igsh=bGpqd2g5eGt6b3pm"; "x" = "https://x.com/celestePoelstr2" }
    "daniel mayorano" = @{ "ig" = "https://www.instagram.com/danielmayorano?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/DanielMayorano" }
    "julieta anahí carbonell" = @{ "ig" = "https://www.instagram.com/carbonell.julieta?igsh=ZDB6czcwYzJmMzNu"; "x" = "https://x.com/carbonell_julii" }
    "axel silecki" = @{ "ig" = "https://www.instagram.com/megatechdelegadxs?igsh=MTdjcHE0ZWN2amtleg=="; "x" = "https://x.com/MegaDelegados" }
    "romina solano" = @{ "ig" = "https://www.instagram.com/romina.solano_?igsh=dW81amlnb2pvbGtu"; "x" = "https://x.com/romina_diffupar" }
    "mariana soledad lezcano" = @{ "ig" = "https://www.instagram.com/mariana_lezcano12?igsh=MXYwZGJtbXV1dDZ2ag=="; "x" = "https://x.com/soleano" }
    "diego martín osores" = @{ "ig" = "https://www.instagram.com/diegodelegado.sec?igsh=MTUybGNrd2xyMXZ2bA=="; "x" = "https://x.com/diegoclasher" }
    "karol victoria churio" = @{ "ig" = "https://www.instagram.com/delegadasvnbsas?igsh=aDdmZDhwc3o1NmRz"; "x" = "https://x.com/delegadxssec" }
    "sergio ortiz" = @{ "ig" = "https://www.instagram.com/ortiz.sergio_ok_?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/Sergio_OrtizOk?s=20" }
    "sebastian gabriel ydrny" = @{ "ig" = "https://www.instagram.com/sebasydrny?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/SYdrny" }
    "silvio gramajo" = @{ "ig" = "https://www.instagram.com/silvio_gramajo_06?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/silvio_gramajo?s=20" }
    "laura nuñes" = @{ "ig" = "https://www.instagram.com/lauranunez9627?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/lauris_nunez?s=20" }
    "sergio leguizamon" = @{ "ig" = "https://www.instagram.com/sglegui?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/Sergiog55553274?s=20" }
    "diego rojas" = @{ "ig" = "https://www.instagram.com/diego.r.rojas.5?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/diegoteruben80?s=20" }
    "oscar carrozaz" = @{ "ig" = "https://www.instagram.com/carrozaz?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/oscarcarrozaz?s=20" }
    "jorge lopez" = @{ "ig" = "https://www.instagram.com/jorgelopezsec?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/jorgelopezsec?s=20" }
    "ailen basualdo" = @{ "ig" = "https://www.instagram.com/ailenbasualdo.sec?igsh=MWVsdXh0MjU4bjhuOA%3D%3D&utm_source=qr"; "x" = "#" }
    "estela lopez" = @{ "ig" = "https://www.instagram.com/estela_lopez89?igsh=MXA5bGpyZmN0ejlqMw=="; "x" = "https://x.com/LopezEste1989" }
}

$htmlPath = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
$html = Get-Content -Path $htmlPath -Raw -Encoding UTF8

# Regex that carefully bounds to the specific card.
$cards = [regex]::Matches($html, '(?s)<div class="candidato-card" data-name="([^"]+)".*?<div class="candidata-socials">\s*<a href="([^"]*)"[^>]*>.*?</a>\s*<a href="([^"]*)"[^>]*>.*?</a>\s*</div>')

$modifiedCount = 0

foreach ($card in $cards) {
    $name = $card.Groups[1].Value.Trim().ToLower()
    
    # Try exact match, or partial matches if there's minor differences like accents
    $matchedKey = $null
    foreach ($key in $data.Keys) {
        if ($name -match [regex]::Escape($key) -or $key -match [regex]::Escape($name)) {
            $matchedKey = $key
            break
        }
    }
    
    # Additional logic to handle names with accents that might not match perfectly
    if (-not $matchedKey) {
        if ($name -match "nu.*es") { $matchedKey = "laura nuñes" }
        if ($name -match "carbonell") { $matchedKey = "julieta anahí carbonell" }
        if ($name -match "lezcano") { $matchedKey = "mariana soledad lezcano" }
        if ($name -match "osores") { $matchedKey = "diego martín osores" }
        if ($name -match "ydrny") { $matchedKey = "sebastian gabriel ydrny" }
    }

    if ($matchedKey) {
        $links = $data[$matchedKey]
        
        # Original full match text of the socials div
        $socialBlockMatch = [regex]::Match($card.Value, '(?s)<div class="candidata-socials">(.*?)</div>')
        $socialBlock = $socialBlockMatch.Groups[1].Value
        
        # Re-build the a tags correctly. We know there are exactly 2 anchors: first is X, second is IG.
        $newX = '<a href="' + $links["x"] + '" target="_blank" rel="noopener noreferrer" class="social-icon x-icon" aria-label="X (Twitter)">X</a>'
        if ($links["x"] -eq "#") {
            $newX = '<a href="#" class="social-icon x-icon" aria-label="X (Twitter)" style="pointer-events: none; opacity: 0.5;">X</a>'
        }
        $newIg = '<a href="' + $links["ig"] + '" target="_blank" rel="noopener noreferrer" class="social-icon ig-icon" aria-label="Instagram">IG</a>'
        
        $newSocialBlock = "`n                    " + $newX + "`n                    " + $newIg + "`n                "
        
        $html = $html.Replace($socialBlockMatch.Value, '<div class="candidata-socials">' + $newSocialBlock + '</div>')
        Write-Host "Updated $($matchedKey)"
        $modifiedCount++
    }
}

Set-Content -Path $htmlPath -Value $html -Encoding UTF8
Write-Host "Total modifications: $modifiedCount"
