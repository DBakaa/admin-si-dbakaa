# admin-si-dbakaa — Industrialisation du SI de la PME

Projet de synthèse B3 Cybersécurité · binôme : NOM1 et NOM2

La configuration des serveurs Linux est écrite en Ansible, celle du contrôleur de domaine en PowerShell.
Chaque push est vérifié par GitHub Actions, et le parc est supervisé par Prometheus et Grafana.

## Le SI
                   réseau 10.10.0.0/24 · domaine pme.lan

## Contenu du dépôt

| Dossier | Rôle |
| --- | --- |
| `ansible/` | `site.yml` et les rôles `commun`, `ssh`, `durcissement` ; `maj.yml` ; `exporteurs.yml` |
| `windows/` | scripts PowerShell du DC, à lancer dans l'ordre 01, 02, 03 |
| `supervision/` | configuration Prometheus, règles d'alerte, tableau de bord Grafana |
| `sauvegarde/` | script et timer systemd de la sauvegarde de SRV-WEB01 |
| `docs/` | supervision, procédure de restauration, rapports Lynis, preuve d'idempotence |
| `.github/workflows/ci.yml` | ansible-lint + syntax-check à chaque push |

## Rejouer la configuration, dans l'ordre

1. Démarrer SRV-DC01, attendre l'écran de connexion, puis SRV-WEB01 et SRV-ADM01.
2. **Windows** — sur SRV-DC01, PowerShell administrateur, dans le dossier `windows\` :
   `powershell -ExecutionPolicy Bypass -File .\01-New-StructureAD.ps1`, puis `02-Partage-Commun.ps1`, puis `03-GPO-MAJ.ps1`.
   Relancer un script ne change rien à ce qui existe déjà.
3. **Linux** — sur SRV-ADM01, compte `sysadmin` :

cat > windows/03-GPO-MAJ.ps1 <<'EOF'
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
