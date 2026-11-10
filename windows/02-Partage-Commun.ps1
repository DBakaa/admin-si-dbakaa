# 02-Partage-Commun.ps1 : groupe DL, dossier, droits NTFS, partage SMB, quota FSRM
# Prerequis : volume E: en miroir (cree a la main au TP 2, etape 10).
# Idempotent : ce qui existe deja n'est pas recree.
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory
$chemin = 'E:\Partages\Commun'
$groupe = 'DL_Commun_Modification'

if (-not (Get-ADGroup -Filter "Name -eq '$groupe'")) {
    New-ADGroup -Name $groupe -GroupScope DomainLocal -GroupCategory Security -Path 'OU=Groupes,OU=PME,DC=pme,DC=lan'
}
if (-not (Get-ADGroupMember -Identity $groupe | Where-Object Name -eq 'GG_Utilisateurs')) {
    Add-ADGroupMember -Identity $groupe -Members GG_Utilisateurs
}
if (-not (Test-Path $chemin)) { New-Item -ItemType Directory -Path $chemin | Out-Null }
icacls $chemin /inheritance:r /grant:r '*S-1-5-32-544:(OI)(CI)F' '*S-1-5-18:(OI)(CI)F' "PME\${groupe}:(OI)(CI)M" | Out-Null

$admins = ([Security.Principal.SecurityIdentifier]'S-1-5-32-544').Translate([Security.Principal.NTAccount]).Value
if (-not (Get-SmbShare -Name Commun -ErrorAction SilentlyContinue)) {
    New-SmbShare -Name Commun -Path $chemin -FullAccess $admins -ChangeAccess "PME\$groupe" -FolderEnumerationMode AccessBased | Out-Null
}
if (-not (Get-WindowsFeature FS-Resource-Manager).Installed) {
    Install-WindowsFeature FS-Resource-Manager -IncludeManagementTools | Out-Null
}
if (-not (Get-FsrmQuota -Path $chemin -ErrorAction SilentlyContinue)) {
    $action = New-FsrmAction -Type Event -EventType Warning -Body 'Le partage Commun a atteint 85 % de son quota.'
    $seuil  = New-FsrmQuotaThreshold -Percentage 85 -Action $action
    New-FsrmQuota -Path $chemin -Size 500MB -Threshold $seuil -Description 'Partage Commun de la PME' | Out-Null
}
Get-SmbShareAccess -Name Commun
Get-FsrmQuota -Path $chemin | Select-Object Path, Size, Usage
