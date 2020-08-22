#!/bin/bash

YB=$(tput setaf 3)$(tput bold)
PB=$(tput setaf 4)$(tput bold)
N=$(tput sgr0)

#CREATED=`date '+%y%m%d%-h%m'`
CREATED=$(date +%y%m%d-%H%M)
TAG=${1:-"data-science"}
MACHINE_TYPE=${1:-"n1-standard-4"}
SUBNET=${1:-"default"}
NETWORK_TIER=${1:-"PREMIUM"}
MAINTENANCE=${1:-"TERMINATE"}
SCOPES=${1:-"https://www.googleapis.com/auth/cloud-platform"}
GPU=${1:-"nvidia-tesla-k80"}
COUNT=${1:-1}
TAGS=${1:-"http-server,https-server,$TAG"}
IMAGE_PROJECT=${1:-"ubuntu-os-cloud"}
IMAGE=${1:-"ubuntu-1804-bionic-v20190918"}
BOOT_DISK_SIZE=${1:-"200GB"}
BOOT_DISK_TYPE=${1:-"pd-standard"}
#RESERVATION=${1:-"any"}

printf "\\n%s... Project Selection ... %s \\n" "${PB}" "${N}"
echo "${PB}Enter PROJECT_ID: ${N}"
read -r PROJECT_ID
MACHINE_NAME=${1:-"$PROJECT_ID-$TAG-$CREATED"}
gcloud config set project "$PROJECT_ID"
printf "%s... Done ... %s \\n" "${PB}" "${N}"

printf "\\n%s... Available Zones ... %s \\n" "${PB}" "${N}"
printf "%sSelect a Zone from the next list !!  %s \\n" "${PB}" "${N}"
gcloud compute zones list
printf "%s... Done ... %s \\n" "${PB}" "${N}"

printf "\\n%s... Zone Selection ... %s \\n" "${PB}" "${N}"
printf "%sINFO: For a GPU high availibility zone choose {%s us-central1-a %s} for example %s \\n" "${PB}" "${YB}" "${PB}" "${N}"
echo "${PB}Enter a valid ZONE: ${N}" ; read -r ZONE
printf "%s... Done ... %s \\n" "${PB}" "${N}"

cat >~/ssh-"$MACHINE_NAME".sh <<EOF
#!/bin/bash
FILE=~/.ssh/config
if [ -f "\$FILE" ]; then
  sudo rm "\$FILE" 
fi
gcloud compute config-ssh
ssh $MACHINE_NAME.$ZONE.$PROJECT_ID
EOF

printf "\\n%s... VM Creation ... %s \\n" "${PB}" "${N}"
gcloud compute --project="$PROJECT_ID" \
               instances create "$MACHINE_NAME" \
               --zone="$ZONE" \
               --machine-type="$MACHINE_TYPE" \
               --subnet="$SUBNET" \
               --network-tier="$NETWORK_TIER" \
               --no-restart-on-failure \
               --maintenance-policy="$MAINTENANCE" \
               --preemptible \
               --scopes="$SCOPES" \
               --accelerator=type="$GPU",count="$COUNT" \
               --tags="$TAGS" \
               --image="$IMAGE" \
               --image-project="$IMAGE_PROJECT" \
               --boot-disk-size="$BOOT_DISK_SIZE" \
               --boot-disk-type="$BOOT_DISK_TYPE" \
               --boot-disk-device-name="$MACHINE_NAME" \
               --quiet && \

sleep 60 && echo.
echo "${PB}Waiting for instance creation, see the next link... ${N}"
echo "${PB}https://console.cloud.google.com/compute${N}"
echo.
echo.
echo "${PB} ███████╗███████╗██╗  ██╗    ███╗   ███╗███████╗    ██╗██╗";
echo "${PB} ██╔════╝██╔════╝██║  ██║    ████╗ ████║██╔════╝    ██║██║";
echo "${PB} ███████╗███████╗███████║    ██╔████╔██║█████╗      ██║██║";
echo "${PB} ╚════██║╚════██║██╔══██║    ██║╚██╔╝██║██╔══╝      ╚═╝╚═╝";
echo "${PB} ███████║███████║██║  ██║    ██║ ╚═╝ ██║███████╗    ██╗██╗";
echo "${PB} ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚══════╝    ╚═╝╚═╝";
echo "${YB}        \$ ssh ${MACHINE_NAME}.${ZONE}.${PROJECT_ID} ${N} ";
echo.
echo.

export SSH="$HOME/ssh-$MACHINE_NAME.sh" && bash $SSH

rm -- "$0"

# Quick Install
# wget "https://raw.githubusercontent.com/makramjandar/AwesomeScripts/master/handyDandy/cloud/gcp/gcs/vmInstantiation&SSH.sh" && bash vmInstantiation&SSH.sh
