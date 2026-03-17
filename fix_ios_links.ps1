# fix_ios_links.ps1
# Corrige los enlaces de Google Sheets en todos los archivos RM*.html
# añadiendo /u/0/ a las URLs para evitar la intercepción de Universal Links en iOS.

$folder = Split-Path -Parent $MyInvocation.MyCommand.Path
$htmlFiles = Get-ChildItem -Path $folder -Filter "RM*.html"

$oldPattern = "https://docs.google.com/spreadsheets/d/"
$newPattern = "https://docs.google.com/spreadsheets/u/0/d/"

$totalFiles = 0
$totalReplacements = 0

foreach ($file in $htmlFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    $count = ([regex]::Matches($content, [regex]::Escape($oldPattern))).Count
    
    if ($count -gt 0) {
        $newContent = $content.Replace($oldPattern, $newPattern)
        [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.UTF8Encoding]::new($false))
        Write-Host "OK $($file.Name): $count URLs corregidas" -ForegroundColor Green
        $totalFiles++
        $totalReplacements += $count
    } else {
        Write-Host "-- $($file.Name): sin cambios (no se encontraron URLs a corregir)" -ForegroundColor Yellow
    }
}

# Corrección adicional para RM1ESO.html: la funcion adjustLinkForiOS
# reemplazaba /edit por /preview (incorrecto). Ahora que las URLs ya tienen /u/0/
# esa transformacion no es necesaria; la dejamos como identidad.
$rm1File = Join-Path $folder "RM1ESO.html"
if (Test-Path $rm1File) {
    $rm1Content = [System.IO.File]::ReadAllText($rm1File, [System.Text.Encoding]::UTF8)
    $badLine = "                return link.replace('/edit', '/preview');"
    $fixLine = "                return link; // Correccion iOS aplicada mediante /u/0/ en la URL"
    if ($rm1Content.Contains($badLine)) {
        $rm1NewContent = $rm1Content.Replace($badLine, $fixLine)
        [System.IO.File]::WriteAllText($rm1File, $rm1NewContent, [System.Text.UTF8Encoding]::new($false))
        Write-Host "OK RM1ESO.html: funcion adjustLinkForiOS corregida" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "Resumen: $totalFiles archivos modificados, $totalReplacements URLs corregidas en total"
