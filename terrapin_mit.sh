

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
update-crypto-policies --set DEFAULT:TERRAPIN

if [[ $? == "0" ]]; then

        while :
        do
                read -p "La mise à jour requiert un redémarrage du service sshd. Voulez-vous redémarrez ? [y/n]" REBOOT
                if [[ "$REBOOT" == "y" ]]; then
                        systemctl restart sshd
                        exit 0
                elif [[ "$REBOOT" == "n" ]]; then
                        echo "Redémarrage ultérieur."
                        exit 0
                else
                        echo "Veuillez répondre par 'y' pour oui et 'n' pour non"
                fi
        done
else
        echo "La mise à jour n'a pas été effectuée."
        exit 2
fi






