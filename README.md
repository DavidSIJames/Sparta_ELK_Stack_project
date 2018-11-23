### Elasticsearch

#### Step 1: Elasticsearch Setup

We decided to begin our setup with the first part of the ELK stack, Elasticsearch. As each part of the ELK stack was new to the team, we first decided to use vagrant in order to test the various components. Elasticsearch required Java as a prerequisite in order to run, so we ran that as the first part of our vagrant file.



``` Vagrant

echo "====== Installing java ======"

sudo apt-get update

sudo apt-get install default-jre

```



Once all of the dependencies had been installed, the next step was to install Elasticsearch. We required a key from Elastic.co in order to use their services, which include all aspects of the ELK stack. We also needed to create a local repository for the Elasticsearch package. Once these steps were complete, we were able to install and run Elasticsearch.



``` Vagrant

echo "====== Installing elasticsearch ======"

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

sudo apt-get update

sudo apt-get install elasticsearch -y

```

#### Step 2: Elasticsearch Configuration

Now that Elasticsearch had been installed, we needed to find a way to configure Elasticsearch to allow a hostname and in order to configure port details. To edit these files, we created copies and added in any additions we wanted to make. Then, we renamed the original folders and copied our version into the same directory as the original. This way, Elasticsearch would use our template by default



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



We also realised that Elasticsearch uses a large amount of RAM. As the AWS instance we would be running our application on only has 1GB of RAM, we needed to find a way to limit the amount of RAM that Elasticsearch would use. We found that we could limit the amount used by navigating to the jvm.options file and setting the maximum and minimum heap size to around 512mb. This would ensure that Elasticsearch could run comfortably, whilst also making sure that the AWS instance did not crash.



``` Vagrant

echo "====== Configuring elasticsearch ======"

sudo chmod 777 /etc/elasticsearch

sudo mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.old

sudo cp /home/vagrant/elasticsearch_templates/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

sudo mv /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options.old

sudo cp /home/vagrant/elasticsearch_templates/jvm.options /etc/elasticsearch/jvm.options

```

### Step 3: Make Elasticsearch Cookbook

Once completing the initial setup and configuration for Elasticsearch on Vagrant, and ensured everything was working properly, we decided to start making the cookbook we would later use to provision the AMIs. Making the cookbook for Elasticsearch was more or less the same process as what we did in the previous steps.



We started by generating a cookbook. Open up your terminal and enter the following command :

```

 chef generate cookbooks elasticsearch

```

In your terminal, move to the new folder we just created with the previous command and open it with your editor of choice.



We started by writing the unit tests. The file (default_spec.rb) can be found by going into spec/unit/recipes.

Afterwards, we moved on to writing the recipe to insure we included all the dependencies we had tried out in the previous steps.  

```

apt_update 'update_sources' do

  action :update

end



package 'default-jre'



execute "install elasticsearch" do

  command "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -"

end



execute "install apt-transport" do

  command "sudo apt-get install apt-transport-https"

end



execute "get key" do

  command "echo 'deb https://artifacts.elastic.co/packages/6.x/apt stable main' | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list"

end



execute "update all" do

  command "sudo apt-get update"

end



package 'elasticsearch'



service 'elasticsearch' do

  supports status: true, restart: true, reload: true

  action [:enable, :start]

end



template '/etc/elasticsearch/elasticsearch.yml' do

  source 'elasticsearch.yml.erb'

  notifies :restart, 'service[elasticsearch]'

end



template '/etc/elasticsearch/jvm.options' do

  source 'jvm.options.erb'

  notifies :restart, 'service[elasticsearch]'

end



execute "start elasticsearch" do

  command "sudo service elasticsearch start"

end

```

For this to work, we had to generate template files to replace certain files in etc/elasticsearch/.

```

Chef generate template elasticsearch.yml

Chef generate template jvm.options

```

These commands will generate a folder called template in which we are able to access and edit the files ( elasticsearch.yml.erb and jvm.options.erb ) we will be using to replace the original copies. After this we ran the following commands to check the recipes :

```

Kitchen create

Kitchen converge

```



Subsequently we moved onto running unit tests to check the recipes with the following command :

```

Chef exec rspec spec

```

Once we were satisfied with the outcome of the tests, we moved on to the integration tests and ran these :

```

Kitchen verify

```

 Finally, we ran kitchen test as a final check to ensure everything was working correctly.



### Kibana

#### Step 1: Kibana Setup

Kibana's installation process runs very similarly to the install for Elasticsearch. As Kibana is running on a different instance to the Elasticsearch server, we required a new key.



```

echo "================= Installing Kibana ================="

echo " "

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

sudo apt-get update

sudo apt-get install kibana -y

echo " "

echo "================= Starting Kibana ================="

echo " "

sudo systemctl enable kibana

sudo systemctl start kibana

echo " "

```



In order for kibana to run, we also required Nginx.  



```

echo "================= Installing nginx ================="

echo " "

sudo apt-get install nginx -y

echo " "



```







#### Step 2: Kibana Configuration

In order to connect Kibana to our other services, we needed to configure the kibana.yml. We changed the server port and ip address, as well as connecting Kibana to Elasticsearch using the Elasticsearch instance ip address.

```

echo "================= Configuring Kibana ================="

echo " "

sudo mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml.old

sudo cp /home/vagrant/kibana_templates/kibana.yml /etc/kibana/kibana.yml

echo " "

```

Nginx would also allow us to set up a reverse proxy, which would redirect traffic away from system port 80, which could be a security risk, and towards a user port at 5601. These changes were made in the configure section below. The service was then started to allow kibana to run properly.



```

echo "================= Configuring nginx ================="

echo " "

sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.old

sudo cp /home/vagrant/kibana_templates/proxy.conf /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf

sudo service nginx restart

echo "================= Starting nginx ================="

echo " "

sudo systemctl enable nginx

sudo systemctl start nginx

echo " "

```



### Step 3: Make Kibana Cookbook

Once completing the initial setup and configuration for Kibana and Nginx on Vagrant, and ensured everything was working properly, we decided to start making the cookbook we would later use to provision the AMIs. Since Kibana needs Nginx , we decided to make a cookbook that had a combination of both. Making the cookbook for Kibana and Nginx was more or less the same process as what we did in the previous steps.



We started by generating a cookbook. Open up your terminal and enter the following command :

```

 chef generate cookbooks kibana_nginx

```

In your terminal, move to the new folder we just created with the previous command and open it with your editor of choice.



We started by writing the unit tests. The file (default_spec.rb) can be found by going into spec/unit/recipes.

Afterwards, we moved on to writing the recipe to insure we included all the dependencies we had tried out in the previous steps.  

```

#====== Update ========



apt_update 'update_sources' do

  action :update

end



#=======NGINX=========



package "nginx"



service "nginx" do

  supports status: true, restart: true, reload: true

  action [:enable, :start]

end



template '/etc/nginx/sites-available/proxy.conf' do

  source 'proxy.conf.erb'

  variables proxy_port: node['nginx']['proxy_port']

  notifies :restart, 'service[nginx]'

end



link '/etc/nginx/sites-enabled/proxy.conf' do

  to '/etc/nginx/sites-available/proxy.conf'

  notifies :restart, 'service[nginx]', :delayed

end



link '/etc/nginx/sites-enabled/default' do

  action :delete

  notifies :restart, 'service[nginx]', :delayed

end



#=======KIBANA=========



execute "elasticsearch key" do

  command 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'

end



execute "install kibana" do

  command 'echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list'

end



execute "update all" do

  command "sudo apt-get update"

end



execute "install kibana" do

  command 'apt-get install kibana -y'

end



service 'kibana' do

  supports status: true, restart: true, reload: true

  action [:enable, :start]

end



template '/etc/kibana/kibana.yml' do

  source 'kibana.yml.erb'

  notifies :restart, 'service[kibana]'

end



execute "start kibana" do

  command "sudo service kibana start"

end



```

For this to work, we had to generate template files to replace certain files in etc/kibana/ and in etc/nginx/sites-enabled/.

```

Chef generate template kibana.yml

Chef generate template proxy.conf

```

These commands will generate a folder called template in which we are able to access and edit the files ( kibana.yml.erb and proxy.conf.erb ) we will be using to replace the original copies. After this we ran the following commands to check the recipes :

```

Kitchen create

Kitchen converge

```

Subsequently we moved onto running unit tests to check the recipes with the following command :



```

Chef exec rspec spec

```



Once we were satisfied with the outcome of the tests, we moved on to the integration tests and ran these :



```

Kitchen verify

```

 Finally, we ran kitchen test as a final check to ensure everything was working correctly.



### Logstash



#### Step 1: Logstash Setup  



Logstash was needed to filter the responces being collected from the Filebeat agents and send the filtered data back to Elasticsearch. Due to the memory requirements of Logstash, it required its own machine. As such, we needed to install Java as a dependency before we began running logstash.



```

echo "================== Installing Java =================="

echo " "

sudo apt-get install default-jre -y

echo " "

```

Once logstash was installed, we then needed to install Logstash. This required us to get our key from elastic.co and download the package from their site.



```

echo "================== Installing Logstash =================="

echo " "

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

sudo apt-get update

sudo apt-get install logstash -y

```



#### Step 2: Logstash Configuration

Configuring Logstash proved to be a major blocker to the team, as it seemed to be reluctant to send files to elasticsearch. In order to fix this error, we needed to edit several configuration files. In the jvm.options file, we needed to edit the heap size in order to reduce the amount of RAM that logstash used upon startup. We also needed to configure the syslog.conf. This was where our major blocker was solved, as we had failed to set up the options which would define the pipeline between filebeat and elasticsearch. Once we edited this, we simply needed to reinstall and start logstash



```

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

echo "Logstash started!"

echo " "

```





### Step 3: Make Logstash Cookbook

Once completing the initial setup and configuration for Logstash on Vagrant, and ensured everything was working properly, we decided to start making the cookbook we would later use to provision the AMIs. Making the cookbook for Logstash was more or less the same process as what we did in the previous steps.



We started by generating a cookbook. Open up your terminal and enter the following command :

```

 chef generate cookbooks logstash

```

In your terminal, move to the new folder we just created with the previous command and open it with your editor of choice.



We started by writing the unit tests. The file (default_spec.rb) can be found by going into spec/unit/recipes.

Afterwards, we moved on to writing the recipe to insure we included all the dependencies we had tried out in the previous steps.  

```



apt_update 'update_sources' do

  action :update

end



package 'default-jre'



execute 'elasticsearch key' do

  command 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'

end



execute 'place url in sources list' do

  command 'echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list'

end



execute "update" do

  command 'sudo apt-get update'

end



execute "install logstash" do

  command 'apt-get install logstash -y'

end





service "logstash" do

  supports status: true, restart: true, reload: true

  action [:enable, :start]

end



template '/etc/logstash/jvm.options' do

  source 'jvm.options.erb'

  notifies :restart, 'service[logstash]'

end



template '/etc/logstash/conf.d/syslog.conf' do

  source 'syslog.conf.erb'

  notifies :restart, 'service[logstash]'

end



```

For this to work, we had to generate template files to replace certain files in /etc/logstash/  and /etc/logstash/conf.d/.

```

Chef generate template jvm.options

Chef generate template syslog.conf

```

These commands will generate a folder called template in which we are able to access and edit the files (  jvm.options.erb and syslog.conf.erb ) we will be using to replace the original copies. After this we ran the following commands to check the recipes :

```

Kitchen create

Kitchen converge

```

Subsequently we moved onto running unit tests to check the recipes with the following command :



```

Chef exec rspec spec

```



Once we were satisfied with the outcome of the tests, we moved on to the integration tests and ran these :



```

Kitchen verify

```

 Finally, we ran kitchen test as a final check to ensure everything was working correctly.



### Filebeat



#### Step 1: Filebeat Setup  

The Filebeat agent was used to allow us to gather logs generated from our AWS instances. This would allow us to view system data, which could be used to identify issues such as high memory usage or traffic. The installation for beats follows a similar pattern to the steps taken to install the rest of the elastic stack. Unlike other machines however, there were no prerequisites we needed to install before getting started.  



```

echo "=========== Inital update and upgrade ==========="

echo " "

sudo apt-get update

sudo apt-get upgrade -y

echo " "

```

Filbeat also installed in a similar way, as can be seen below.



```

echo "=========== Installing FileBeat ==========="

echo " "

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

sudo apt-get update

sudo apt-get install filebeat -y

echo " "

```



### Step 2: FileBeat Configuration  

This cookbook was made using the following steps:



## beats/recipes/default.rb

The default.rb file is where the main configuration for the Filebeat will go. Taking the provision script from the test before, we break it up into individual commands and apply them with the correct syntax.



* This will get the security key from the URL. This command will run as a script inside the virtual machine so the key will be stored in there.



```

execute "elasticsearch key" do

    command 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |sudo apt-key add -'

end

```



* This is another shell script that will run inside the vm and add it to the sources list.



```

execute "install filebeat" do

  command 'echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list'

end

```



* Now filebeat is added to the sources list, the following command will update the sources list (check for updates).



```

execute "update all" do

  command "sudo apt-get update"

end



```



* The following script will install filebeat on the virtual mahine. The "-y" flag is required a it will confirm the request to install the software when it asks, otherwise the installation will time out.



```

execute "install filebeat" do

  command 'apt-get install filebeat -y'

end

```



* Template adds a configuration file in the templates folder. This will then be included in the configuration of the machine.



```

template '/etc/filebeat/filebeat.yml' do

  source 'filebeat.yml.erb'

  notifies :restart, 'service[filebeat]'

end

```



* This will (re)start the filebeat service to ensure it is running.  



```

execute "start filebeat" do

  command "sudo service filebeat start"

end

```



## beats/templates/filebeat.yml.erb



This template file is what we are going to use replace the existing config file.



* In the Elasticsearch output part of the template file is where we age going to specify what IP Address and Port we want to run the software on.



```

#-------------------------- Elasticsearch output ------------------------------

output.elasticsearch:

  # Array of hosts to connect to.

  hosts: ["192.168.10.35:9200"]

```

## Challenges
Through out this project, our team faced a large number of challenges which presented us with unique problems to
overcome. The most consequential of these are shown below:
* Instance RAM shortage
* Logstash pipeline
* Researching ELK stack
