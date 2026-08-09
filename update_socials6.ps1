$data = @{
    "sergio ortiz" = @{ "ig" = "https://www.instagram.com/ortiz.sergio_ok_?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/Sergio_OrtizOk?s=20" }
    "jorge lÃ³pez" = @{ "ig" = "https://www.instagram.com/jorgelopezsec?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/jorgelopezsec?s=20" }
    "sebastiÃ¡n ydrny" = @{ "ig" = "https://www.instagram.com/sebasydrny?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/SYdrny" }
    "oscar carrozas" = @{ "ig" = "https://www.instagram.com/carrozaz?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/oscarcarrozaz?s=20" }
    "laura nÃºÃ±ez" = @{ "ig" = "https://www.instagram.com/lauranunez9627?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/lauris_nunez?s=20" }
    "silvio gramajo" = @{ "ig" = "https://www.instagram.com/silvio_gramajo_06?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/silvio_gramajo?s=20" }
    "diego rojas" = @{ "ig" = "https://www.instagram.com/diego.r.rojas.5?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/diegoteruben80?s=20" }
    "sergio leguizamÃ³n" = @{ "ig" = "https://www.instagram.com/sglegui?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/Sergiog55553274?s=20" }
    "romina solano" = @{ "ig" = "https://www.instagram.com/romina.solano_?igsh=dW81amlnb2pvbGtu"; "x" = "https://x.com/romina_diffupar" }
    "karol victoria churio" = @{ "ig" = "https://www.instagram.com/delegadasvnbsas?igsh=aDdmZDhwc3o1NmRz"; "x" = "https://x.com/delegadxssec" }
    "daniel mayorano" = @{ "ig" = "https://www.instagram.com/danielmayorano?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="; "x" = "https://x.com/DanielMayorano" }
    "celeste poelstra" = @{ "ig" = "https://www.instagram.com/celespoel?igsh=bGpqd2g5eGt6b3pm"; "x" = "https://x.com/celestePoelstr2" }
    "mariana lezcano" = @{ "ig" = "https://www.instagram.com/mariana_lezcano12?igsh=MXYwZGJtbXV1dDZ2ag=="; "x" = "https://x.com/soleano" }
    "diego osores" = @{ "ig" = "https://www.instagram.com/diegodelegado.sec?igsh=MTUybGNrd2xyMXZ2bA=="; "x" = "https://x.com/diegoclasher" }
    "julieta carbonell" = @{ "ig" = "https://www.instagram.com/carbonell.julieta?igsh=ZDB6czcwYzJmMzNu"; "x" = "https://x.com/carbonell_julii" }
    "ailen basualdo" = @{ "ig" = "https://www.instagram.com/ailenbasualdo.sec?igsh=MWVsdXh0MjU4bjhuOA%3D%3D&utm_source=qr"; "x" = "#" }
    "estela lopez" = @{ "ig" = "https://www.instagram.com/estela_lopez89?igsh=MXA5bGpyZmN0ejlqMw=="; "x" = "https://x.com/LopezEste1989" }
}

$htmlPath = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
$lines = Get-Content -Path $htmlPath -Encoding UTF8

$output = @()
$inSocials = $false
$currentName = ""

foreach ($line in $lines) {
    if ($line -match '<div class="candidato-card" data-name="([^"]+)"') {
        $currentName = $matches[1]
        $output += $line
    } elseif ($line -match '<div class="candidata-socials">') {
        $inSocials = $true
        $output += $line
        
        if ($data.ContainsKey($currentName)) {
            $links = $data[$currentName]
            $newX = '                            <a href="' + $links["x"] + '" target="_blank" rel="noopener noreferrer" class="social-icon x-icon" aria-label="X (Twitter)">X</a>'
            if ($links["x"] -eq "#") {
                $newX = '                            <a href="#" class="social-icon x-icon" aria-label="X (Twitter)" style="pointer-events: none; opacity: 0.5;">X</a>'
            }
            $newIg = '                            <a href="' + $links["ig"] + '" target="_blank" rel="noopener noreferrer" class="social-icon ig-icon" aria-label="Instagram">IG</a>'
            
            $output += $newX
            $output += $newIg
            Write-Host "Updated $currentName"
        } else {
            # Need to output the original lines since we don't have new data
            # but wait, the next lines will be the original ones which we skip!
            # So I must store them if I'm not replacing.
            $inSocials = "skip"
        }
    } elseif ($inSocials -eq $true) {
        if ($line -match '</div>') {
            $inSocials = $false
            $output += $line
        }
        # skip lines inside if replacing
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
