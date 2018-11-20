#!/bin/bash
echo "==============================================================================="
echo "================              TEAM CANADIA:  Beats            ================="
echo "==============================================================================="
echo "_______________________________________________________________________________"
echo "MMMMMMMMMMMMMMMMM                                             MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM                      .                      MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM                     .M.                     MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM              .     .MMM.     .              MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM              Mm,  .MMMMM.  ,mM              MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM              qMMm,MMMMMMM,mMMq              MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM         .    'MMMMMMMMMMMMMMM'    .         MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM        .Mm.   MMMMMMMMMMMMMMM   .mM.        MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM 'MMMMMMMMMMM. 'MMMMMMMMMMMMM' .MMMMMMMMMMM' MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM  'MMMMMMMMMMMM.MMMMMMMMMMMMM.MMMMMMMMMMMM'  MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM   'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM'   MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM .mMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm. MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM    ''MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM''    MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM        ''MMMMMMMMMMMMMMMMMMMMMMMMM''        MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM           ''MMMMMMMMMMMMMMMMMMM''           MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM           mMMMMMMMMMMMMMMMMMMMMMm           MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM                     MMM                     MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM                     MMM                     MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM                     MMM                     MMMMMMMMMMMMMMMMM"
echo "MMMMMMMMMMMMMMMMM_____________________________________________MMMMMMMMMMMMMMMMM"
echo " "
echo "=========== Inital update and upgrade ==========="
echo " "
sudo apt-get update
sudo apt-get upgrade -y
echo " "
echo "=========== Installing FileBeat ==========="
echo " "
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt-get update
sudo apt-get install filebeat -y
echo " "
echo "================= Configuring FileBeat ================="
echo " "
sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.old
sudo cp /home/vagrant/beats_templates/filebeat.yml /etc/filebeat/filebeat.yml
echo " "
echo "================= Starting FileBeat ================="
echo " "
sudo systemctl enable filebeat
sudo systemctl start filebeat
echo " "
echo "================= Provision Complete ================="
echo " "
