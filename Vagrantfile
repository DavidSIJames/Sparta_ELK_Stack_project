required_plugins = ["vagrant-hostsupdater", "vagrant-berkshelf"]
required_plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    # User vagrant plugin manager to install plugin, which will automatically refresh plugin list afterwards
    puts "Installing vagrant plugin #{plugin}"
    Vagrant::Plugin::Manager.instance.install_plugin plugin
    puts "Installed vagrant plugin #{plugin}"
  end
end
Vagrant.configure("2") do |config|
  config.vm.define "elasticsearch" do |ela|
    ela.vm.box = "ubuntu/xenial64"
    ela.vm.hostname = "elasticsearch"
    ela.vm.network "private_network", ip: "192.168.10.35"
    ela.hostsupdater.aliases = ["elastic.local"]
    ela.vm.synced_folder "elasticsearch_templates" , "/home/vagrant/elasticsearch_templates"
    ela.vm.provision "shell", path: "elasticsearch_provision.sh", privileged: false
  end
  config.vm.define "logstash" do |log|
    log.vm.box = "ubuntu/xenial64"
    log.vm.network "private_network", ip: "192.168.10.55"
    log.hostsupdater.aliases = ["logstash.local"]
    log.vm.synced_folder "logstash_templates", "/home/vagrant/logstash_templates"
    log.vm.provision "shell", path: "logstash_provision.sh", privileged: false
  end
  config.vm.define "kibana" do |kib|
    kib.vm.box = "ubuntu/xenial64"
    kib.vm.hostname = "kibana"
    kib.vm.network "private_network", ip: "192.168.10.45"
    kib.hostsupdater.aliases = ["kibana.local"]
    kib.vm.synced_folder "kibana_templates", "/home/vagrant/kibana_templates"
    kib.vm.provision "shell", path: "kibana_provision.sh", privileged: false
  end
  config.vm.define "beats" do |beat|
    beat.vm.box = "ubuntu/xenial64"
    beat.vm.hostname = "beat-1"
    beat.vm.network "private_network", ip: "192.168.10.65"
    beat.hostsupdater.aliases = ["beats.local"]
    beat.vm.synced_folder "beats_templates", "/home/vagrant/beats_templates"
    beat.vm.provision "shell", path: "beats_provision.sh", privileged: false
  end
  config.vm.define "beats2" do |beat|
    beat.vm.box = "ubuntu/xenial64"
    beat.vm.hostname = "beat-2"
    beat.vm.network "private_network", ip: "192.168.10.66"
    beat.hostsupdater.aliases = ["beats.local"]
    beat.vm.synced_folder "beats_templates", "/home/vagrant/beats_templates"
    beat.vm.provision "shell", path: "beats_provision.sh", privileged: false
  end
end
