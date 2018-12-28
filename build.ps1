Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

if ($Env:SOURCE_DIR) { $SourceDirectory = $Env:SOURCE_DIR } else { $SourceDirectory = Split-Path $MyInvocation.MyCommand.Path -Parent }
$LibGit2Directory = Join-Path -Path "${SourceDirectory}" -ChildPath libgit2
$BuildDirectory = $(Get-Location).Path
if ($Env:SHA) { $Sha = $Env:SHA } else { $Sha = & git --git-dir="${LibGit2Directory}/.git" rev-parse --short=7 HEAD }

Write-Host $SourceDirectory
Write-Host $LibGit2Directory

$LibGit2Basename = "git2-${Sha}"
$LibGit2Filename = "git2-${Sha}.dll"

cmake "${LibGit2Directory}" `
      -DBUILD_CLAR=OFF `
      -DUSE_SSH=OFF `
      -DUSE_BUNDLED_ZLIB=ON `
      -DLIBGIT2_FILENAME="${LibGit2Basename}"
cmake --build . --config RelWithDebInfo
