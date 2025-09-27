# Vagrant Multi-Node DevOps Environment

This project is designed to learn DevOps by building a multi-node environment using Vagrant. It creates a complete infrastructure setup with load balancing, application services, database, CI/CD, and monitoring capabilities.

## 🏗️ Architecture Overview

This environment consists of 5 virtual machines that work together to simulate a production-like infrastructure:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Load Balancer  │    │  Jenkins Server │    │ Monitor Server  │
│ (192.168.56.10) │    │ (192.168.56.13) │    │ (192.168.56.14) │
│      nginx      │    │  Jenkins CI/CD  │    │ Prometheus +    │
│                 │    │                 │    │ Grafana         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                                              │
         │                                              │
         ▼                                              ▼
┌─────────────────┐                        ┌─────────────────┐
│  App Server     │◄──────────────────────►│ Database Server │
│ (192.168.56.11) │                        │ (192.168.56.12) │
│  Application    │                        │   PostgreSQL    │
│  Service        │                        │                 │
└─────────────────┘                        └─────────────────┘
```

## 🚀 Virtual Machines

| VM Name     | IP Address    | Purpose            | Resources        | Services                           |
| ----------- | ------------- | ------------------ | ---------------- | ---------------------------------- |
| **lb**      | 192.168.56.10 | Load Balancer      | 512MB RAM, 1 CPU | nginx, node_exporter               |
| **app**     | 192.168.56.11 | Application Server | 1GB RAM, 2 CPUs  | Application service, node_exporter |
| **db**      | 192.168.56.12 | Database Server    | 512MB RAM, 1 CPU | PostgreSQL, node_exporter          |
| **jenkins** | 192.168.56.13 | CI/CD Server       | 2GB RAM, 2 CPUs  | Jenkins                            |
| **monitor** | 192.168.56.14 | Monitoring Stack   | 1GB RAM, 1 CPU   | Prometheus, Grafana                |

## 📋 Prerequisites

Before running this project, ensure you have the following installed:

- **Vagrant** (2.0+)
- **VMware Fusion** (macOS) or **VMware Workstation** (Windows/Linux)
- **VMware Vagrant Plugin**: `vagrant plugin install vagrant-vmware-desktop`
- At least **5GB of available RAM** and **20GB of disk space**

## 🔧 Quick Start

1. **Clone this repository:**

   ```bash
   git clone <repository-url>
   cd vagrant-vms
   ```

2. **Start all VMs:**

   ```bash
   vagrant up
   ```

3. **Start individual VMs (optional):**
   ```bash
   vagrant up lb app db jenkins monitor
   ```

## 🎯 What You'll Learn

This project helps you understand and practice:

- **Infrastructure as Code (IaC)** with Vagrant
- **Load Balancing** with nginx
- **Database Management** with PostgreSQL
- **CI/CD Pipelines** with Jenkins
- **Monitoring & Observability** with Prometheus and Grafana
- **Network Configuration** and service communication
- **System Administration** and provisioning scripts
- **DevOps Best Practices** and multi-tier architecture

## 🛠️ Services & Access Points

### Load Balancer (nginx)

- **Access:** http://192.168.56.10
- **Purpose:** Routes traffic to application servers
- **Config:** `/etc/nginx/sites-available/sportgather`

### Application Server

- **Access:** http://192.168.56.11:8080 (direct)
- **Purpose:** Hosts the main application
- **Monitoring:** node_exporter on port 9100

### Database Server (PostgreSQL)

- **Access:** 192.168.56.12:5432
- **Database:** `sportgather_db`
- **User/Pass:** `vagrant/vagrant`
- **Monitoring:** node_exporter on port 9100

### Jenkins CI/CD

- **Access:** http://192.168.56.13:8080
- **Purpose:** Continuous Integration and Deployment
- **Initial Setup:** Follow Jenkins setup wizard

### Monitoring Stack

- **Prometheus:** http://192.168.56.14:9090
- **Grafana:** http://localhost:3000 (port forwarded)
- **Default Grafana Login:** admin/admin

## 📁 Project Structure

```
vagrant-vms/
├── Vagrantfile                 # Main Vagrant configuration
├── provision/                  # Provisioning scripts
│   ├── app.sh                 # Application server setup (empty - ready for your app)
│   ├── db.sh                  # PostgreSQL database setup
│   ├── jenkins.sh             # Jenkins CI/CD setup
│   ├── lb.sh                  # nginx load balancer setup
│   └── monitor.sh             # Prometheus + Grafana setup
└── README.md                  # This file
```

## 🔍 Monitoring & Metrics

The monitoring server automatically collects metrics from all nodes:

- **Node metrics:** CPU, memory, disk, network from all VMs
- **Application metrics:** Available on port 8080 (configure as needed)
- **Database metrics:** Can be extended with PostgreSQL exporter

Access Grafana at http://localhost:3000 to create dashboards and visualize your infrastructure.

## 🧪 Common Operations

### Check VM Status

```bash
vagrant status
```

### SSH into VMs

```bash
vagrant ssh lb
vagrant ssh app
vagrant ssh db
vagrant ssh jenkins
vagrant ssh monitor
```

### Restart a VM

```bash
vagrant reload <vm-name>
```

### Destroy and Recreate

```bash
vagrant destroy
vagrant up
```

### View Logs

```bash
vagrant ssh <vm-name>
sudo journalctl -u <service-name>
```

## 🎓 Learning Exercises

1. **Extend the Application Server**: Deploy a real application in `app.sh`
2. **Database Integration**: Connect your app to the PostgreSQL database
3. **Jenkins Pipeline**: Create a CI/CD pipeline for your application
4. **Custom Dashboards**: Build monitoring dashboards in Grafana
5. **Scale Out**: Add more application servers behind the load balancer
6. **Security**: Implement SSL/TLS and firewall rules
7. **Backup Strategy**: Implement database backup and recovery

## 🐛 Troubleshooting

### VM Won't Start

- Check available system resources (RAM/CPU)
- Verify VMware is properly installed
- Run `vagrant validate` to check Vagrantfile syntax

### Network Issues

- Ensure the 192.168.56.0/24 network isn't conflicting
- Check VMware network settings
- Verify firewall isn't blocking VM communication

### Service Issues

- SSH into the problematic VM: `vagrant ssh <vm-name>`
- Check service status: `sudo systemctl status <service>`
- View logs: `sudo journalctl -u <service> -f`

## 🤝 Contributing

This is a learning project! Feel free to:

- Add new services or VMs
- Improve provisioning scripts
- Create additional monitoring dashboards
- Share your learning experiences

## 📄 License

This project was created for educational purposes to learn DevOps practices and can be freely used for learning and experimentation.

## 📚 Additional Resources

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [nginx Documentation](https://nginx.org/en/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)

---

**Happy Learning!** 🚀

This environment provides a solid foundation for understanding modern DevOps practices. Start with the basics and gradually add complexity as you become more comfortable with each component.
