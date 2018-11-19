## Sparta ELK Stack Project

###Introduction
Our project was to create an ELK stack which would allow us to monitor the health of AWS instances which were created as part of another group project.The ELK stack is comprised of three parts: Elasticsearch is a JSON based search engine which can be used alongside Kibana to search through data on a given instance. In order to collect this data, a Logstash agent is installed on every instance we wish to monitor. This agent will feed data into Kibana, which can then be searched with Elasticsearch.

The following steps were taken in order to set up the stack.

###Step 1: Elasticsearch Setup
We decided to begin our setup with the first part of the ELK stack, Elasticsearch. As each part of the ELK stack was new to the team, we first decided to use vagrant in order to test the various components. Elasticsearch required Java as a prerequisite in order to run, so we ran that as the first part of our vagrant file.

``` Vagrant
echo "====== Installing java ======"
sudo apt-get update
sudo apt-get install default-jre
```

Once all of the dependancies had been installed, the next step was to install Elasticsearch. We required a key from Elastic.co in order to use their services, which include all aspects of the ELK stack. We also needed to create a local repository for the Elasticsearch package. Once these steps were complete, we were able to install and run Elasticsearch.

``` Vagrant
echo "====== Installing elasticsearch ======"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
sudo apt-get install elasticsearch -y
```
###Step 2: Elasticsearch Configuration
Now that Elasticsearch had been installed, we needed to find a way to configure Elasticsearch to allow a hostname and in order to configure port details. To edit these files, we created copies and added in anuy additions we wanted to make. Then, we renamed the original folders and copied our version into the same directory as the original. This way, Elasticstash would use our template by default

```
# ====== Elasticstash.yml edits ======
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: "localhost"
#
# Set a custom port for HTTP:
#
http.port: 9200
```

We also realised that Elasticsearch uses a large amount of RAM. As the AWS instance we would be running our application on only has 1GB of RAM, we needed to find a way to limit the amout of RAM that Elasticsearch would use. We found that we could limit the amount used by navigating to the jvm.options file and setting the maximum and minimum heap size to around 512mb. This would ensure that Elasticsearch could run comfortably, whilst also making sure that the AWS instance did not crash.

``` Vagrant
echo "====== Configuring elasticsearch ======"
sudo chmod 777 /etc/elasticsearch
sudo mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.old
sudo cp /home/vagrant/elasticsearch_templates/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
sudo mv /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options.old
sudo cp /home/vagrant/elasticsearch_templates/jvm.options /etc/elasticsearch/jvm.options
```
