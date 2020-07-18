# Sample devOps project from scratch

**create azure VM**
-------------------------------------------------------------------------------------------------------------------------------
- Please ensure you have active azure subscription 
- go to portal.azure.com and order New VM
I have used Ubuntu 18.04 Standard D2s v3 (2 vcpus, 8 GiB memory).  
You will need to alter your network settings to access it from your Windows Machine. I have used ssh key to login to VM directly through Putty.
-------------------------------------------------------------------------------------------------------------------------------
**install tools on VM** :
-------------------------------------------------------------------------------------------------------------------------------
Docker:  
https://docs.docker.com/engine/install/ 
To enable docker to start with system boot: `sudo systemctl enable docker`

njain50@nitinvm:/var/run$ `ls -lrt | grep -i docker`
srw-rw----  1 root docker    0 Jun 17 09:33 docker.sock
-rw-r--r--  1 root root      5 Jun 17 09:33 docker.pid
drwx------  8 root root    180 Jun 17 09:34 docker

s at starts of line tells its a socket owned by root
group owner is docker

Add user to docker group so that it can run docker commands. 
`usermod -aG docker njain50`

`cat /etc/group | grep -i docker`
`docker:x:999:njain50`

Restart session and now we shall be able to execute "docker version" command
-------------------------------------------------------------------------------------------------------------------------------
Jenkins:  
Refer this guide for installation: https://www.jenkins.io/doc/book/installing/#debianubuntu
`sudo systemctl start jenkins`
`sudo systemctl status jenkins`

`sudo usermod -aG jenkins njain50`  # add njain50 to jenkins group

`cat /etc/group | grep -i jenkins`
jenkins:x:116:njain50


`http://<azure-vm-public-ip>:8080/ ` # access jenkins here

-------------------------------------------------------------------------------------------------------------------------------
**create sample repo in GIT and run code in Jenkins**
Here is sample repo in GIT created https://github.com/nitinjain9282/sampledevops with start_docker.sh script. 
Configure a new job in jenkins with this git url  and it will now run Dockerfile as instructed. 

Note: For jenkins to trigger docker command we need to authorize "jenkins" user to "docker" group
      ` sudo usermod -aG docker $USER`
      Restart VM for changes to take effect. 

Done: tag:1.1.2
-------------------------------------------------------------------------------------------------------------------------------
**Install Sonarqube**
For Sonarqube we need to install mysql first:
Reference: https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-18-04
`sudo apt update`
`sudo apt install mysql-server`
`sudo mysql_secure_installation` # answer series of questions and set some password. 

testing mysql: 
`systemctl status mysql.service`

if mysql not running: `sudo systemctl start mysql`
check mysql db version: `sudo mysqladmin -p -u root version`
to connect to db: sudo mysql -u root -p
to check status: mysql> status
to check port: mysql>SHOW VARIABLES WHERE Variable_name = 'port';
to check hostname: mysql> SHOW VARIABLES WHERE Variable_name = 'hostname';
to know user: mysql> select user();
to show all variables: mysql>show variables;

#conenct mysql using dbeaver
1- https://dbeaver.io/download/
2- 
comment following lines and restart: 
cat /etc/mysql/mysql.conf.d/mysqld.cnf | grep -i bind
#bind-address            = 127.0.0.1
systemctl restart mysql.service
3- give njain50 complete access to mysql:
sudo mysql -u root -p
CREATE USER 'njain50'@'localhost' IDENTIFIED BY '********';
GRANT ALL PRIVILEGES ON *.* TO 'njain50'@'localhost';
4- go to Dbeaver, new connnection ==> SSH
host External IP,njain50, password, remote host: 127.0.0.1, 3306
Test tunnel configuration is successful
5- Go to Main Tab and enter following:
Host IP, Database name; database user, password, default port 3306
6- right click conneciton ==> connect ==> this will connect to database. 

-----------------------------------------------------------------------------
sonarqube installation:
Reference: https://www.digitalocean.com/community/tutorials/how-to-ensure-code-quality-with-sonarqube-on-ubuntu-18-04

sudo adduser --system --no-create-home --group --disabled-login sonarqube
sudo mkdir /opt/sonarqube
sudo apt-get install unzip
sudo mysql -u root -p
mysql> CREATE DATABASE sonarqube;
CREATE USER sonarqube@'localhost' IDENTIFIED BY 'some_secure_password';
GRANT ALL ON sonarqube.* to sonarqube@'localhost';
FLUSH PRIVILEGES;
EXIT;

cd /opt/sonarqube
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.5.zip
sudo unzip sonarqube-7.5.zip
sudo rm sonarqube-7.5.zip
sudo chown -R sonarqube:sonarqube /opt/sonarqube
sudo vi sonarqube-7.5/conf/sonar.properties

to run sonarqube as service: 
vi /etc/systemd/system/sonarqube.service  #add snippet as given in link 

sudo service sonarqube start
sudo service sonarqube status
sudo systemctl enable sonarqube

access sonarqube here: curl http://127.0.0.1:9000 

Note: 
curl http://127.0.0.1:9000/ was working but curl http://<host-external-ip>:9000 not working, its because in sonar.properties file we had used sonar.web.host=127.0.0.1
This line indicates which IP address the Web Server will bind to. If you set it to 127.0.0.1, then Server will only respond if you reach to it through the IP 127.0.0.1, that is, you'll only be able to access it from localhost
So we commented out this line - sonar.web.host=127.0.0.1 and restarted sonarqube and now it works. 

Done: tag:1.1.3
-------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------
 
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------





