Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

if ($Env:SOURCE_DIR) {
  $SourceDirectory = $Env:SOURCE_DIR
} else {
  $SourceDirectory = Split-Path $MyInvocation.MyCommand.Path -Parent
}

if ($Env:SHA) {
  $Sha = $Env:SHA
} else {
  $Sha = & git --git-dir="${SourceDirectory}/.git" rev-parse HEAD:libgit2
}

function Recurse-Directory($path) {
  foreach ($item in Get-ChildItem $path) {
    $itemPath = $item.FullName

    if ($item -is [System.IO.DirectoryInfo]) {
      Recurse-Directory($itemPath)
    } else {
      $itemPath
    }
  }
}

$ShaAbbreviation = $Sha.Substring(0,7)
$LibraryFilename = "git2-${ShaAbbreviation}"

$PropsFile = "Dogged.Native.Binaries.props"
Set-Content -Encoding UTF8 ${PropsFile} @"
<Project>
  <PropertyGroup>
    <MSBuildAllProjects>`$(MSBuildAllProjects);`$(MSBuildThisFileFullPath)</MSBuildAllProjects>
    <libgit2_propsfile>`$(MSBuildThisFileFullPath)</libgit2_propsfile>
    <libgit2_hash>$Sha</libgit2_hash>
    <libgit2_filename>$LibraryFilename</libgit2_filename>
  </PropertyGroup>
</Project>
"@

$TargetsFile = "Dogged.Native.Binaries.targets"
Set-Content -Encoding UTF8 ${TargetsFile} @'
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <ItemGroup>
'@

Recurse-Directory runtimes | % {
  Add-Content -Encoding UTF8 ${TargetsFile} @"
    <None Include=`"`$(MSBuildThisFileDirectory)\..\$_`">
      <Visible>false</Visible>
      <Link>$_</Link>
      <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    </None>
"@
}

Add-Content -Encoding UTF8 ${TargetsFile} @'
  </ItemGroup>
</Project>
'@
