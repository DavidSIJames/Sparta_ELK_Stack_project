#!/bin/bash
echo "==============================================================================="
echo "==============              TEAM CANADIA:  Logstash             ==============="
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
echo "================== Installing Java =================="
echo " "
sudo apt-get install default-jre -y
echo " "
echo "================== Installing Logstash =================="
echo " "
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
sudo apt-get install logstash -y
echo "================= Configuring Logstash ================="
echo " "
sudo mv /etc/logstash/jvm.options /etc/logstash/jvm.options.old
sudo cp /home/vagrant/logstash_templates/jvm.options /etc/logstash/jvm.options
sudo cp /home/vagrant/logstash_templates/syslog.conf /etc/logstash/conf.d/syslog.conf
sudo apt-get install logstash -y
echo "Done!"
echo " "
echo "================= Starting Logstash ================="
echo " "
sudo systemctl enable logstash
sudo systemctl start logstash
cd /usr/share/logstash
sudo bin/logstash -f /etc/logstash/conf.d/syslog.conf
echo "Logstash started!"
echo " "
echo "================= Provision Complete ================="
echo " "
