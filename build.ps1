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
$LibGit2Symbols = "git2-${Sha}.pdb"

$Configuration = "RelWithDebInfo"

cmake "${LibGit2Directory}" `
      -DBUILD_CLAR=OFF `
      -DUSE_SSH=OFF `
      -DUSE_BUNDLED_ZLIB=ON `
      -DLIBGIT2_FILENAME="${LibGit2Basename}" `
      ${Env:CMAKE_OPTIONS}
cmake --build . --config ${Configuration}

$OutputPath = Join-Path -Path ${BuildDirectory} -ChildPath ${Configuration}

Write-Host "##vso[task.setvariable variable=libgit2.outputdir]${OutputPath}"
Write-Host "##vso[task.setvariable variable=libgit2.libraryname]${LibGit2Filename}"
Write-Host "##vso[task.setvariable variable=libgit2.symbols]${LibGit2Symbols}"
