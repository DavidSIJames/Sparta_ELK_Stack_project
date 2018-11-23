#!/bin/bash
echo "==============================================================================="
echo "============              TEAM CANADIA: elasticsearch             ============="
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
echo "================= Installing java ================="
echo " "
sudo apt-get install default-jre -y
echo " "
echo "================= Installing elasticsearch ================="
echo " "
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
sudo apt-get install elasticsearch -y
echo " "
echo "================= Configuring elasticsearch ================="
echo " "
sudo chmod 777 /etc/elasticsearch
sudo mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.old
sudo cp /home/vagrant/elasticsearch_templates/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
sudo mv /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options.old
sudo cp /home/vagrant/elasticsearch_templates/jvm.options /etc/elasticsearch/jvm.options
echo "Done!"
echo " "
echo "================= Starting elasticsearch ================="
echo " "
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
echo "elasticsearch started!"
echo " "
echo "================= Provision Complete ================="
echo " "
