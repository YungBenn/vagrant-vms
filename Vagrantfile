Vagrant.configure("2") do |config|
  # BOX default
  config.vm.box = "ubuntu/jammy64"

  # ========== LOAD BALANCER ==========
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "192.168.56.10"
    lb.vm.provider "vmware_fusion" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
    lb.vm.provision "shell", path: "provision/lb.sh"
  end

  # ========== APP SERVER ==========
  config.vm.define "app" do |app|
    app.vm.hostname = "app"
    app.vm.network "private_network", ip: "192.168.56.11"
    app.vm.provider "vmware_fusion" do |vb|
      vb.memory = 1024
      vb.cpus = 2
    end
    app.vm.provision "shell", path: "provision/app.sh"
  end

  # ========== DATABASE SERVER ==========
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.12"
    db.vm.provider "vmware_fusion" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
    db.vm.provision "shell", path: "provision/db.sh"
  end

  # ========== JENKINS SERVER ==========
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.hostname = "jenkins"
    jenkins.vm.network "private_network", ip: "192.168.56.13"
    jenkins.vm.provider "vmware_fusion" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    jenkins.vm.provision "shell", path: "provision/jenkins.sh"
  end
  
  # ========== MONITOR SERVER (Prometheus + Grafana) ==========
  config.vm.define "monitor" do |m|
    m.vm.hostname = "monitor"
    m.vm.network "private_network", ip: "192.168.56.14"
    m.vm.network "forwarded_port", guest: 3000, host: 3000   # Grafana -> localhost:3000
    m.vm.provider "vmware_fusion" do |v|
      v.name = "monitor-sg"
      v.memory = 1024
      v.cpus = 1
    end
    m.vm.provision "shell", path: "provision/monitor.sh"
  end
end
