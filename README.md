# 🧩 user_audit.sh

Script Bash d’audit système permettant d’obtenir des informations essentielles sur les utilisateurs Linux.

## ⚙️ Fonctions principales

| Option | Description |
|--------|--------------|
| `--list` | Liste les utilisateurs humains |
| `--sudo` | Liste les utilisateurs avec droits sudo |
| `--check <user>` | Affiche la dernière connexion |
| `--inactive <N>` | Liste les comptes inactifs depuis N jours |
| `--count` | Compte le nombre d’utilisateurs humains |

## 🧠 Exemple d’utilisation

```bash
bash user_audit.sh --count
bash user_audit.sh --check romain
bash user_audit.sh --inactive 30
```
🧾 Licence

Projet open source sous licence MIT.
