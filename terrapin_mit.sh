#!/bin/bash

#################################################################################################
#                                                                                               #
# Script de mitigation contre Terrapin                                                          #
#                                                                                               #
#       Aut. : NonneTrapue                                                                      #
#       Source : https://www.linuxglobal.com/thwarting-the-terrapin-ssh-attack/                 #
#                                                                                               #
#                                                                                               #
#################################################################################################



# VAR

POLICY_FILE=/etc/crypto-policies/policies/modules/TERRAPIN.pmod


# MAIN

##  Création du fichier TERRAPIN.pmod
if [[ ! -f $POLICY_FILE ]]; then
        echo "Création du fichier $POLICY_FILE"
        touch $POLICY_FILE
        if [[ $? == "0" ]]; then
                echo "cipher@ssh = -CHACHA20*" >> $POLICY_FILE
                echo "ssh_etm = 0" >> $POLICY_FILE
        else
                echo "Le fichier n'a pu être créé. Fin du programme."
                exit 1
        fi
else
        echo "Le fichier $POLICY_FILE existe déjà !"
fi



## Mise à jour du système
update-crypto-policies --set DEFAULT:TERRAPIN 1&2 > /dev/null
if [[ $? == "0"]]; then

        while :
        do
                REBOOT=read -p "La mise à jour requiert un redémarrage du système. Voulez-vous redémarrez ? [y/n]"
                if [[ $REBOOT == "y" ]]; then
                        reboot
                elif [[ $REBOOT == "n" ]]; then
                        echo "Redémarrage ultérieur."
                        exit 0
                else
                        echo "Veuillez répondre par 'y' pour oui et 'n' pour non"
        done
else
        echo "La mise à jour n'a pas été effectuée."
        exit 2


