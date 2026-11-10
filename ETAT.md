# État d'avancement du projet

## 1. Présentation

Ce document présente l'état d'avancement du projet d'industrialisation du système d'information de la PME.

Il permet de suivre les éléments déjà opérationnels, les configurations réalisées, les fonctionnalités restant à automatiser ainsi que les éventuelles améliorations à apporter.

L'infrastructure repose sur trois serveurs : SRV-DC01, SRV-WEB01 et SRV-ADM01.

## 2. Éléments fonctionnels et opérationnels

### Infrastructure Windows

- [x] Serveur SRV-DC01 opérationnel.
- [x] Active Directory fonctionnel.
- [x] Gestion des utilisateurs fonctionnelle.
- [x] Gestion des groupes fonctionnelle.

### Infrastructure Linux

- [x] Serveur SRV-WEB01 opérationnel.
- [x] Serveur SRV-ADM01 opérationnel.
- [x] Connexion SSH fonctionnelle.
- [x] Ansible installé et fonctionnel.
- [x] Communication entre les machines via Ansible.

### Supervision

- [x] Prometheus opérationnel.
- [x] Grafana opérationnel.

### Sauvegardes

- [x] Système de sauvegarde fonctionnel.

## 3. Éléments présents dans le dépôt GitHub

### Ansible

- [x] Fichier `ansible.cfg`.
- [x] Inventaire `inventaire/hosts.ini`.
- [x] Playbook `maj.yml`.
- [x] Playbook `proxy-apt.yml`.

### Documentation

- [x] `docs/installation.md`.
- [x] `docs/inventaire.md`.
- [x] `docs/exploitation.md`.

## 4. Éléments restant à réaliser ou à vérifier

### Infrastructure as Code

- [ ] Créer et intégrer le rôle Ansible `commun`.
- [ ] Créer et intégrer le rôle Ansible `ssh`.
- [ ] Créer et intégrer le rôle Ansible `durcissement`.
- [ ] Créer le playbook principal `site.yml`.
- [ ] Vérifier l'idempotence des playbooks (`changed=0` au deuxième passage).
- [ ] Vérifier la gestion des secrets avec Ansible Vault.

### Administration Windows

- [ ] Centraliser les scripts PowerShell dans `windows/`.
- [ ] Documenter les configurations Active Directory, utilisateurs et groupes.
- [ ] Vérifier les éléments DNS, DHCP et partage Commun avec quota.

### Intégration continue

- [ ] Créer le workflow GitHub Actions.
- [ ] Intégrer `ansible-lint`.
- [ ] Ajouter le contrôle syntaxique des playbooks.
- [ ] Obtenir un pipeline vert sur GitHub.

### Supervision

- [ ] Documenter la configuration de Prometheus et Grafana.
- [ ] Vérifier la présence des trois serveurs dans les cibles Prometheus.
- [ ] Compléter le tableau de bord Grafana (disponibilité, processeur, mémoire et disques).
- [ ] Configurer et tester une règle d'alerte.
- [ ] Ajouter les preuves dans `docs/supervision.md`.

### Sécurité et sauvegardes

- [ ] Réaliser un audit Lynis avant durcissement.
- [ ] Appliquer les mesures de durcissement.
- [ ] Réaliser un audit Lynis après durcissement.
- [ ] Ajouter les deux rapports dans `docs/securite/`.
- [ ] Rédiger la procédure de restauration dans `docs/procedures/restauration.md`.
- [ ] Tester la restauration d'un fichier supprimé et conserver les preuves.

## 5. Problèmes et limitations connus

À ce stade, les principaux services de l'infrastructure sont opérationnels.

Le travail restant concerne principalement l'industrialisation des configurations, leur validation automatique, le renforcement de la sécurité et la finalisation de la documentation.

Les fonctionnalités déjà opérationnelles devront progressivement être intégrées dans une configuration automatisée et reproductible.

## 6. Bilan

L'infrastructure de base est fonctionnelle : les serveurs Linux et Windows sont opérationnels, les accès SSH et Ansible fonctionnent, la supervision est disponible et les sauvegardes sont en place.

La prochaine étape consiste à centraliser ces configurations dans le dépôt GitHub afin de rendre leur déploiement reproductible, contrôlable et documenté.

Ce document sera actualisé à chaque étape importante du projet afin de refléter fidèlement l'état réel de l'infrastructure.
