#!/usr/bin/env bash
set -euo pipefail

# === Fonctions ===
usage() {
  echo "Usage: $0 [OPTION]"
  echo
  echo "Options disponibles :"
  echo "  --list            Liste les utilisateurs humains (UID >= 1000)"
  echo "  --sudo            Liste les utilisateurs avec droits sudo"
  echo "  --check <user>    Affiche la dernière connexion de l'utilisateur"
  echo "  --inactive <N>    Affiche les comptes inactifs depuis N jours"
  echo "  --count           Compte les utilisateurs humains"
  echo "  --help            Affiche cette aide"
  exit 0
}

# Si aucune option → aide
[[ $# -lt 1 ]] && usage

# === Analyse des options ===
case "$1" in

  --list)
    echo "[Liste des utilisateurs humains]"
    awk -F: '$3 >= 1000 && $6 ~ /^\/home/' /etc/passwd | cut -d: -f1
    ;;

  --sudo)
    echo "[Utilisateurs sudo]"
    getent group sudo wheel | awk -F: '{print $4}'
    ;;

  --check)
    [[ $# -lt 2 ]] && { echo "Erreur : précisez un nom d'utilisateur."; exit 1; }
    user="$2"
    echo "[Dernière connexion pour $user]"
    if id "$user" &>/dev/null; then
      lastlog -u "$user"
    else
      echo "Utilisateur introuvable."
    fi
    ;;

  --inactive)
    [[ $# -lt 2 ]] && { echo "Erreur : précisez un nombre de jours."; exit 1; }
    days="$2"
    echo "[Utilisateurs inactifs depuis plus de $days jours]"
    now=$(date +%s)
    lastlog | awk -v now="$now" -v days="$days" '
      NR>1 && $4 != "Never" {
        cmd = "date -d\"" $4 " " $5 " " $6 "\" +%s"
        cmd | getline t; close(cmd)
        if ((now - t) > (days * 86400)) print $1
      }'
    ;;

  --count)
    echo "[Nombre d'utilisateurs humains]"
    awk -F: '$3 >= 1000 && $6 ~ /^\/home/' /etc/passwd | wc -l
    ;;

  --help|-h)
    usage
    ;;

  *)
    echo "Option inconnue : $1"
    usage
    ;;
esac
