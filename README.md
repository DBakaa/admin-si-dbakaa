# 🖥️ Industrialisation du système d'information d'une PME

## 📌 Présentation du projet

Ce projet est réalisé dans le cadre du Bachelor 3 Cybersécurité, spécialité Administration Systèmes Linux/Windows.

Il consiste à industrialiser le système d'information d'une PME en automatisant l'administration de ses serveurs Linux et Windows.

L'objectif est de transformer les configurations réalisées manuellement lors des travaux pratiques en configurations automatisées, reproductibles et centralisées dans un dépôt GitHub.

Le projet s'appuie notamment sur Ansible pour l'administration Linux, PowerShell pour l'administration Windows et des outils de supervision afin d'améliorer la disponibilité et la sécurité de l'infrastructure.

## 🎯 Objectifs du projet

Les principaux objectifs sont :

- Automatiser la configuration des serveurs Linux avec Ansible.
- Centraliser les scripts d'administration Windows avec PowerShell.
- Mettre en place une infrastructure reproductible grâce à l'Infrastructure as Code (IaC).
- Contrôler automatiquement les configurations avec GitHub Actions.
- Superviser les serveurs avec Prometheus et Grafana.
- Renforcer la sécurité des systèmes.
- Documenter les procédures d'installation, d'exploitation et de maintenance.

## 🏗️ Architecture de l'infrastructure

L'infrastructure cible est composée de trois serveurs :

| Serveur | Adresse IP | Système | Fonction |
|---|---|---|---|
| SRV-DC01 | 10.10.0.10 | Windows Server | Active Directory, DNS, DHCP et partage de fichiers |
| SRV-WEB01 | 10.10.0.20 | Debian | Serveur Web Nginx et services Linux |
| SRV-ADM01 | 10.10.0.30 | Debian | Administration Ansible et supervision |

## 🛠️ Technologies utilisées

| Technologie | Utilisation |
|---|---|
| Ansible | Automatisation de la configuration Linux |
| PowerShell | Administration Windows |
| Git / GitHub | Gestion du code et collaboration |
| GitHub Actions | Intégration continue |
| Ansible Lint | Contrôle de qualité des playbooks |
| Prometheus | Collecte des métriques |
| Grafana | Visualisation et supervision |
| Lynis | Audit de sécurité Linux |
| UFW | Gestion du pare-feu |
| Fail2ban | Protection contre les tentatives de connexion |

## 📂 Organisation du dépôt

Le dépôt est organisé de manière à séparer les fichiers d'automatisation, les inventaires et la documentation.

### Structure actuelle

```text
admin-si-db ak aa/
│
├── ansible/
│   ├── ansible.cfg
│   ├── maj.yml
│   ├── proxy-apt.yml
│   │
│   └── inventaire/
│       └── hosts.ini
│
└── docs/
    ├── installation.md
    ├── inventaire.md
    └── exploitation.md
```

Cette structure sera progressivement complétée au fur et à mesure de l'avancement du projet.

### Structure cible

```text
admin-si-db ak aa/
│
├── README.md
├── ETAT.md
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── ansible/
│   ├── ansible.cfg
│   ├── site.yml
│   ├── maj.yml
│   ├── proxy-apt.yml
│   │
│   ├── inventaire/
│   │   └── hosts.ini
│   │
│   ├── group_vars/
│   │   └── all/
│   │       └── vars.yml
│   │
│   └── roles/
│       ├── commun/
│       ├── ssh/
│       └── durcissement/
│
├── windows/
│   └── scripts PowerShell
│
└── docs/
    ├── installation.md
    ├── inventaire.md
    ├── exploitation.md
    ├── supervision.md
    ├── procedures/
    │   └── restauration.md
    └── securite/
        ├── lynis-avant.txt
        └── lynis-apres.txt
```

## ⚙️ Automatisation Linux avec Ansible

L'administration des serveurs Linux repose sur Ansible, installé sur le serveur d'administration SRV-ADM01.

Les fichiers de configuration sont regroupés dans le répertoire `ansible/`.

Les principaux fichiers actuellement présents sont :

- `ansible.cfg` : fichier de configuration générale d'Ansible.
- `inventaire/hosts.ini` : inventaire des machines administrées.
- `maj.yml` : playbook de gestion des mises à jour.
- `proxy-apt.yml` : playbook relatif à la configuration du proxy APT.

### Vérification de la connectivité

Depuis SRV-ADM01, la connexion aux machines Linux peut être vérifiée avec :

```bash
ansible linux -m ping
```

### Exécution des playbooks

Depuis le répertoire `ansible/` :

```bash
ansible-playbook -i inventaire/hosts.ini maj.yml
```

Pour vérifier la syntaxe :

```bash
ansible-playbook -i inventaire/hosts.ini maj.yml --syntax-check
```

Les commandes seront adaptées au fur et à mesure de l'ajout des nouveaux playbooks et rôles.

## 📚 Documentation

Le répertoire `docs/` centralise les informations nécessaires à l'installation et à l'exploitation de l'infrastructure.

| Fichier | Description |
|---|---|
| `installation.md` | Documentation relative à l'installation des serveurs |
| `inventaire.md` | Informations sur l'inventaire de l'infrastructure |
| `exploitation.md` | Documentation relative à l'exploitation du système |

Cette documentation a vocation à être enrichie tout au long du projet.

## 🚧 Évolutions prévues

Les prochaines étapes du projet sont :

- [ ] Organiser les rôles Ansible : commun, ssh et durcissement.
- [ ] Créer le playbook principal `site.yml`.
- [ ] Mettre en place la gestion des variables et des secrets avec Ansible Vault.
- [ ] Ajouter les scripts PowerShell dans le répertoire `windows/`.
- [ ] Configurer le pipeline CI avec GitHub Actions.
- [ ] Mettre en place la supervision Prometheus et Grafana.
- [ ] Réaliser les audits de sécurité avec Lynis.
- [ ] Documenter les procédures de sauvegarde et de restauration.
- [ ] Compléter le fichier `ETAT.md` avec l'état réel de l'infrastructure.

## 👥 Équipe projet

Projet réalisé en binôme dans le cadre du Bachelor 3 Cybersécurité.

- Membre 1 : COTTAR ROMAIN
- Membre 2 : RAES YANIS

---

*Projet de synthèse – Administration Systèmes Linux/Windows – B3 Cybersécurité.*
