# 03-GPO-MAJ.ps1 : GPO de mise a jour Windows (dimanche 3h), liee aux controleurs de domaine
# Idempotent : GPO et lien crees s'ils manquent, valeurs reecrites a l'identique.
$ErrorActionPreference = 'Stop'
Import-Module GroupPolicy, ActiveDirectory
$nom = 'GPO_MAJ_Windows'
$ou  = (Get-ADDomain).DomainControllersContainer

if (-not (Get-GPO -Name $nom -ErrorAction SilentlyContinue)) {
    New-GPO -Name $nom -Comment 'Installation planifiee des mises a jour : dimanche 3h' | Out-Null
}
if (-not ((Get-GPInheritance -Target $ou).GpoLinks | Where-Object DisplayName -eq $nom)) {
    New-GPLink -Name $nom -Target $ou | Out-Null
}
$cle = 'HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
$valeurs = [ordered]@{ NoAutoUpdate = 0; AUOptions = 4; ScheduledInstallDay = 1; ScheduledInstallTime = 3 }
foreach ($v in $valeurs.GetEnumerator()) {
    Set-GPRegistryValue -Name $nom -Key $cle -ValueName $v.Key -Type DWord -Value $v.Value | Out-Null
}
Get-GPRegistryValue -Name $nom -Key $cle | Select-Object ValueName, Value
