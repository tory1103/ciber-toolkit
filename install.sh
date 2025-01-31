source config.sh

# Installation directory
workdir="/usr/bin/cibertk"

# Check root
if [[ "$(id -u)" != "0" ]]; then
  echo "$red""[$cross] This script needs root access. Try running 'sudo $SHELL install.sh'"
  exit
fi

# Banner
clear
echo -e "$yellow _________ ._____.                        _______________  __.    "
echo -e "$yellow \_   ___ \|__\_ |__   ___________        \__    ___/    |/ _|    "
echo -e "$yellow /    \  \/|  || __ \_/ __ \_  __ \  ______ |    |  |      <      "
echo -e "$yellow \     \___|  || \_\ \  ___/|  | \/ /_____/ |    |  |    |  \     "
echo -e "$yellow  \______  /__||___  /\___  >__|            |____|  |____|__ \    "
echo -e "$yellow         \/        \/     \/                                \/    "
echo -e "$yellow .___                 __         .__  .__                         "
echo -e "$yellow |   | ____   _______/  |______  |  | |  |   ___________          "
echo -e "$yellow |   |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \         "
echo -e "$yellow |   |   |  \\___ \  |  |  / __ \|  |_|  |_\  ___/|  | \/         "
echo -e "$yellow |___|___|  /____  > |__| (____  /____/____/\___  >__| /\  /\  /\ "
echo -e "$yellow          \/     \/            \/               \/     \/  \/  \/ "
echo -e "$orange                         Ciber-ToolKit Installer                  "
echo -e "$orange                                                                  "
echo -e "$orange                          Author : Adrian Toral                   "
echo -e "$default"

# Main folder installation
if [[ ! -d $workdir ]]; then
  mkdir $workdir
fi

# Programs needed
apt update
apt install git curl wget gpg -y
apt install python3 python2 python3-pip python3-dev -y

curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list && apt update &&  apt install ngrok
ngrok authtoken 253DwCMYHqdHlzNapM0sxF04XGB_2NG9YQtFWNhof1d1t8Wth

# Requirements
python3 -m pip install -r "$(pwd)/requirements.txt"

# Making json copy
cp "$(pwd)/src/ciber-toolkit/data/tools.json" "$(pwd)/src/ciber-toolkit/data/backup.json"
echo -e "$green""[$mark] Created backup $(pwd)/src/ciber-toolkit/data/backup.json"

# Sub folders installation
for tag in spoofing phishing wifi passwords web informationgathering others; do
  if [[ -d $workdir/tools/$tag ]]; then
    echo -e "$green""[$mark]" "$orange $workdir/tools/$tag already exists. Skipping..."
  else
    mkdir -p $workdir/tools/$tag
    echo -e "$green""[$mark] $workdir/tools/$tag created. Done"
  fi
done

cp -r $(pwd)/src/ciber-toolkit/builtins $workdir

# Shortcut for toolkit
case $(echo "$1" | tr '[:upper:]' '[:lower:]') in
y | yes | -y | -yes)
  option=yes
  ;;
n | no | -n | -no)
  option=no
  ;;
*)
  echo -e "$green""[!] Do you want to run ciber-toolkit anywhere your terminal? (y/n): ""$default"
  read -r option
  ;;
esac

case $(echo "$option" | tr '[:upper:]' '[:lower:]') in
y | yes)
  touch /bin/toolkit
  echo "#!$SHELL" > /bin/toolkit
  echo "cd $(pwd)/src/ciber-toolkit && python3 toolkit.py" >> /bin/toolkit

  touch /bin/toolkit-freshinstall
  echo "#!$SHELL" > /bin/toolkit-freshinstall
  echo "cd $(pwd) && bash fresh-install.sh" >> /bin/toolkit-freshinstall

  touch /bin/toolkit-uninstall
  echo "#!$SHELL" > /bin/toolkit-uninstall
  echo "cd $(pwd) && bash uninstall.sh" >> /bin/toolkit-uninstall

  touch /bin/toolkit-update
  echo "#!$SHELL" > /bin/toolkit-update
  echo "cd $(pwd) && bash update.sh" >> /bin/toolkit-update

  chmod +x /bin/toolkit*

  echo -e "$green"
  echo -e "╔──────────────────────────────────────────────────────────╗"
  echo -e "|[$mark] Installation complete. Type 'toolkit' to run the tool.|"
  echo -e "┖──────────────────────────────────────────────────────────┙"
  ;;
n | no)
  echo -e "$green"
  echo -e "╔──────────────────────────╗"
  echo -e "|[$mark] Installation complete.|"
  echo -e "┖──────────────────────────┙"
  ;;
esac
