Param(
    [string]$InstallPath = "C:\ITM-Saxion",
    [string]$GitHubRepoURL = "https://github.com/Hintenhaus04/ITM-Saxion.git",
    [string]$FrontendFolder = "frontend/EasyDevOps"
)

Write-Host "=== Start: EasyDevOps installation script ==="
Write-Host "Installatiepad: $InstallPath"
Write-Host "GitHub Repo URL: $GitHubRepoURL"
Write-Host "----------------------------------------------"


# 1. Installeer .NET SDK 8 (via winget)

Write-Host "`n[Stap 1] Controleren of .NET SDK 8 is geïnstalleerd..."
$dotnet = Get-Command dotnet -ErrorAction SilentlyContinue
if (-not $dotnet) {
    Write-Host ".NET SDK 8 niet gevonden. Installeren via winget..."
    winget install --id Microsoft.DotNet.SDK.8 --silent
} else {
    Write-Host ".NET lijkt al geïnstalleerd te zijn."
}


# 2. Installeer Git (indien nodig)

Write-Host "`n[Stap 2] Controleren of Git is geïnstalleerd..."
$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) {
    Write-Host "Git niet gevonden. Installeren via winget..."
    winget install --id Git.Git --silent
} else {
    Write-Host "Git lijkt al geïnstalleerd te zijn."
}


# 3. Clone de repo

Write-Host "`n[Stap 3] Repo clonen..."
if (-not (Test-Path $InstallPath)) {
    Write-Host "Map $InstallPath bestaat niet, maak aan..."
    New-Item -ItemType Directory -Path $InstallPath | Out-Null
}
Set-Location $InstallPath

# Haal de mapnaam uit de URL als laatste deel
# OF zet een vaste foldernaam
$folderName = $GitHubRepoURL.Split('/')[-1].Replace(".git","")  # Laatste deel van URL, strip '.git'
if ((Test-Path $folderName) -and (Test-Path "$InstallPath\$folderName\.git")) {
    Write-Host "Repo lijkt al aanwezig. Sla clonen over."
} else {
    git clone $GitHubRepoURL
}



# 4. Run de .NET consoleapp (in /frontend)

Write-Host "`n[Stap 4] Run de .NET frontend-app..."
$projectPath = Join-Path $InstallPath $folderName
$frontendPath = Join-Path $projectPath $FrontendFolder

if (Test-Path $frontendPath) {
    Set-Location $frontendPath

    Write-Host "dotnet run in: $frontendPath"
    dotnet run
} else {
    Write-Host "Map '$frontendPath' niet gevonden. Check of je frontend-mapnaam correct is."
}

Write-Host "`n=== Klaar! ==="
Write-Host "De .NET-consoleapp is gestart (of gaf een fout als er iets niet klopt)."
