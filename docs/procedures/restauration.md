# Restaurer un fichier depuis la sauvegarde de SRV-WEB01

## Ce qui est sauvegardé
| Élément | Valeur |
| --- | --- |
| Dossiers | `/srv/partage`, `/home`, `/etc` |
| Destination | `/var/backups/sauvegarde/AAAA-MM-JJ/` sur SRV-WEB01 (LVM, disques distincts du RAID) |
| Quand | tous les jours à 2h, timer systemd `sauvegarde.timer` |
| Script | `/usr/local/sbin/sauvegarde.sh` (copie dans `sauvegarde/` du dépôt) |
| Conservation | 7 jours |

## Avant de commencer
- Se connecter : `ssh sysadmin@10.10.0.20` (compte avec sudo).
- Connaître le chemin exact du fichier perdu, par exemple `/srv/partage/rapport.odt`.

## Étapes
1. Vérifier que la dernière sauvegarde a réussi :
   `systemctl list-timers sauvegarde.timer` puis `sudo journalctl -u sauvegarde.service -n 5`
   (attendu : `Sauvegarde AAAA-MM-JJ terminee`).
2. Lister les sauvegardes disponibles : `sudo ls /var/backups/sauvegarde/`
3. Retrouver le fichier : `sudo find /var/backups/sauvegarde -name 'rapport.odt' -ls`
4. Choisir la date voulue, puis restaurer :
   `sudo rsync -a /var/backups/sauvegarde/AAAA-MM-JJ/srv/partage/rapport.odt /srv/partage/`
   (`-a` conserve les droits, le propriétaire et les dates).
5. Vérifier : `ls -l /srv/partage/rapport.odt`
6. Prévenir l'utilisateur.

Si le fichier existe encore mais qu'on veut une version ancienne, le restaurer d'abord dans `/tmp`, comparer, puis seulement l'écraser.

## Lancer une sauvegarde à la main
`sudo systemctl start sauvegarde.service`

## Preuve (test du 10/11/2026, 11h26)
Même empreinte avant suppression et après restauration : le fichier restauré est identique à l'original.

## Limite connue
La sauvegarde est sur le même serveur. Elle protège d'une suppression ou d'une panne du RAID, pas de la perte de SRV-WEB01 entier. Évolution prévue : copie vers une autre machine.
