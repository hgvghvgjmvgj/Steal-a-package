# Produces the source bundle for direct Studio MCP installation. No Rojo/sync server.
param([string]$Output = 'tools/studio/source-bundle.json')
$ErrorActionPreference = 'Stop'
$taskRoot = Resolve-Path (Join-Path $PSScriptRoot '../..')
$taskManifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'manifest.json') -Raw | ConvertFrom-Json
$taskEntries = @($taskManifest | ForEach-Object {
    @{ file = $_.file; path = $_.path; class = $_.class; source = (Get-Content -LiteralPath (Join-Path $taskRoot $_.file) -Raw) }
})
$taskJson = ConvertTo-Json -InputObject $taskEntries -Depth 5 -Compress
[System.IO.File]::WriteAllText((Join-Path $taskRoot $Output), $taskJson, [System.Text.UTF8Encoding]::new($false))
Write-Output "Prepared $($taskEntries.Count) scripts. Install each with Roblox Studio MCP multi_edit using manifest paths."
