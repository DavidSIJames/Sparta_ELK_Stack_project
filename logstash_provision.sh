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
echo "================== Installing and Configuring Logstash =================="
echo " "
wget https://artifacts.elastic.co/downloads/logstash/logstash-6.5.1.tar.gz
tar -xvf logstash-6.5.1.tar.gz
cp /home/vagrant/logstash_templates/syslog.conf /home/vagrant/logstash-6.5.1/
export LS_HOME="/home/vagrant/logstash-6.5.1/"
sudo mv /home/vagrant/logstash-6.5.1/config/startup.options /home/vagrant/logstash-6.5.1/config/startup.options.old
sudo cp /home/vagrant/logstash_templates/startup.options /home/vagrant/logstash-6.5.1/config/startup.options
sudo mv /home/vagrant/logstash-6.5.1/config/jvm.options /home/vagrant/logstash-6.5.1/config/jvm.options.old
sudo cp /home/vagrant/logstash_templates/jvm.options /home/vagrant/logstash-6.5.1/config/jvm.options
sudo cp /home/vagrant/logstash_templates/syslog.conf /home/vagrant/logstash-6.5.1/syslog.conf
sudo $LS_HOME/bin/system-install $LS_HOME/config/startup.options systemd
echo "Done!"
echo " "
echo "================= Starting Logstash ================="
echo " "
sudo systemctl enable logstash
sudo systemctl start logstash
echo "Logstash started!"
echo " "
echo "================= Provision Complete ================="
echo " "
