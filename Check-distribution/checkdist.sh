#!/bin/bash -e
#Maj du 13/06/2018 Edité par lassechere:Davy

clear

if [[ $EUID -ne 0 ]]; then
    echo "Merci de démarrer en Root."
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
AIRTIMEROOT=${SCRIPT_DIR}

# Validate la distribution et release ; set boolean flags.
echo "Détection la distribution et la release ..."
is_debian_dist=false
is_debian_jessie=false
is_debian_wheezy=false
is_ubuntu_dist=false
is_ubuntu_xenial=false
is_ubuntu_trusty=false
is_centos_dist=false
is_centos_7=false
if [ -e /etc/os-release ]; then
  # Access $ID, $VERSION_CODENAME, $VERSION_ID and $PRETTY_NAME
  source /etc/os-release
  dist=$ID
  code="${VERSION_CODENAME-$VERSION_ID}"
  case "${dist}-${code}" in
    ubuntu-xenial)
      is_ubuntu_dist=true
      is_ubuntu_xenial=true
      ;;
    ubuntu-14.04)
      code="trusty"
      is_ubuntu_dist=true
      is_ubuntu_trusty=true
      ;;
    debian-9)
      code="stretch"
      is_debian_dist=true
      is_debian_stretch=true
      ;;
    debian-8)
      code="jessie"
      is_debian_dist=true
      is_debian_jessie=true
      ;;
    debian-7)
      code="wheezy"
      is_debian_dist=true
      is_debian_wheezy=true
      ;;
    centos-7)
      is_centos_dist=true
      is_centos_7=true
      ;;
    *)
      echo "ERREUR: Distribution \"$PRETTY_NAME\" n'est pas supporté" >&2
      exit 1
      ;;
  esac
else
  echo "ERREUR: La distribution n'est pas supporté" >&2
  exit 1
fi

echo "Distribution Détecter: $PRETTY_NAME"
echo "Distribution id (dist): $dist"
echo "Distribution version (code): $code"

echo
$is_ubuntu_dist && echo "Dist: Ubuntu"
$is_debian_dist && echo "Dist: Debian"
$is_centos_dist && echo "Dist: CentOS"

echo "Distribution et release code-name:"
$is_ubuntu_xenial && echo "Ubuntu Xenial"
$is_ubuntu_trusty && echo "Ubuntu Trusty"
$is_debian_jessie && echo "Debian Jessie"
$is_debian_wheezy && echo "Debian Wheezy"
$is_centos_7 && echo "CentOS 7"
