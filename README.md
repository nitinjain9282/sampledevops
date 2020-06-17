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
**create sample repo in GIT**
Here is sample repo in GIT created https://github.com/nitinjain9282/sampledevops with start_docker.sh script. 
Configure a new job in jenkins with this git url  and it will now run Dockerfile as instructed. 

Note: For jenkins to trigger docker command we need to authorize "jenkins" user to "docker" group
      ` sudo usermod -aG docker $USER`
      Restart VM for changes to take effect. 

Done: tag:1.1.2
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
 
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------





