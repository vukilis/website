---
title: "How to install and setup EJBCA 8.2 with galera and HSM module"
url: /How-to-install-and-setup-EJBCA-with-galera-and-HSM-module
date: 2024-05-03T17:10:17+02:00
lastmod: 2024-05-07T17:10:17+02:00
draft: false
license: ""

tags: [debian, crtificates, security]
categories: [Linux]
description: "In this tutorial I will show how to install and setup EJBCA 8.2 with Hardware security module (HSM)...."

featuredImagePreview: "images/2024/How_to_install_EJBCA_with_Apache_proxy_and_galera_with_HSM_module/How_to_install_EJBCA_8.2_with_and_galera_with_HSM_module.png"


hiddenFromHomePage: true
hiddenFromSearch: true
twemoji: false
lightgallery: true
ruby: true
fraction: true
fontawesome: true
linkToMarkdown: true
rssFullText: false

toc:
    enable: true
    auto: true
comment:
    enable: true
code:
    copy: true
    maxShownLines: 50
math:
    enable: false
share:
    enable: true
    HackerNews: true
    Reddit: true
    VK: true
    Line: false
    Weibo: false
---
<!--more-->

---

In this tutorial I will show how to install and setup EJBCA 8.2 with galera cluster using mysql database and  Hardware security module (HSM). 

---

## `Important`

* HSM is hardware device so you must having one to follow this tutorial fully. If you don't have one you can just ignore HSM configuration steps and you won't be able to generate pkcs#11 keys.

## `Steps`

 1) For this purpose Debian 12 is installed.
 2) Follow the procedure for EJBCA and HSM installation.
 3) When EJBCA installation is done stop mariadb service.
 4) Follow the procedure for Galera installation.
 5) Open EJBCA Administration page

## `1. Debian 12 Installation`

For more details check official documentation https://www.debian.org/releases/bookworm/amd64/

## `2. Follow the procedure for EJBCA installation and HSM installation`

### Preface

The purpose of this part is to describe all necessary steps for CA installation and configuration.

### Software Stack

The following software stack is used during the training:

* **Debian:** A Linux based Operating system.
* **OpenJDK:** Contains the Java Virtual Machine.
* **WildFly:** A Java Enterprise Edition (JEE) application server providing middleware services for security, persistance and management of resources.
* **Apache Ant:** A build system for compiiling EJBCA.
* **MariaDB:** An SQL database supported by EJBCA.
* **MariaDB Java Connector:** A Java application acting as a bridge between EJBCA and MariaDB.
* **Utimaco HSM Simmulator:** A Hardware Security Module emulator.

### System Set-up

Log in as a user `vukilis` using the password `linux!2345` using `ssh`.

Install the latest update for the Debian 12 GNU/Linux OS.

```bash
sudo apt update && sudo apt upgrade
```

> Note
>
> Confirm that IP address is correct using the command 'ip a'

Install necessary tools:

```bash
sudo apt install bash-completion tcpdump net-tools bind9-utils bind9-dnsutils bind9utils ncat wget unzip zip lsof vim lshw telnet tmux rsync nano apt-utils chrony 
```

Apart from the `root` user which was created during the installation of the operating system, we are going to create two additional users called **vukilis** and **wildfly.**

> Note
>  
> vukilis user is created during installation proccess.  
> Wildfly user will be created later during wildfly installation proccess.

| User     | Purpose                                 |
| :------- | :-------------------------------------- |
| vukilis | Used during system administration, e.g. to install software, edit configuration files and perform other administrative tasks. Has full access to the system. |
| wildfly  | Used by the application server. Has access to all applications under **/opt/** directory.|

### Installation Prerequisites

* JAVA -> OpenJDK 11 - Supported and recommended.
* Database -> MariaDB is recommended.
* Application Server -> Wildfly 26 - is currently recommended.
* MariaDB Database Driver -> 2.7.11
* Build Tool -> Apache Ant 1.10.14 or later.
* EJBCA -> 8_2_0_1

### Installing Java

OpenJDK 11 is the open-source edition of the Oracle standard Java Platform that is available to install on almost all Linux systems using their default system repository. It is released under the GNU license and is extremely important if you are planning to install some application that requires JAVA

Although there is already a newer version of OpenJDK available we can install version 11 on Debian 12 Linux with:

```bash
echo "deb http://deb.debian.org/debian unstable main non-free contrib" >> /etc/apt/sources.list
```

Set preferences for the packages:  
**/etc/apt/preferences**

```bash
Package: *
Pin: release a=stable
Pin-Priority: 900

Package: *
Pin: release a=unstable
Pin-Priority: 50
```

Run system update to refresh the APT repository cache:

```bash
apt update
```

Install Java OpenJDK 11 and confirm version:

```bash
apt install openjdk-11-jdk-headless

java -version

update-alternatives --config java
```

### Installing Database

Install and configure MariaDB:

```bash
apt install mariadb-server mariadb-client
```

Start MariaDB server:

```bash
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

See wheather Mariadb is started and listening:

```bash
ss -tnlp
systemctl status mariadb
```

Run MariaDB hardening shell script `mariadb-secure-installation` in order to:

* set a password for `root` account (vukilis)
* disallow root login remotely
* remove anonymous-user accounts and test databases
* reload privileges

```bash
mariadb-secure-installation


NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] n
 ... skipping.

You already have your root account protected, so you can safely answer 'n'.

Change the root password? [Y/n] 
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] 
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] 
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] 
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] 
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

For MariaDB, use the following commands to create the database, matching the `DataSource` in the next step, and add privileges to connect to the database:

```bash
mysql -u root -p

mysql> CREATE DATABASE ejbcadb CHARACTER SET utf8 COLLATE utf8_general_ci;
mysql> GRANT ALL PRIVILEGES ON ejbcadb.* TO 'ejbca'@'localhost' IDENTIFIED BY 'vukilis';
mysql> GRANT ALL PRIVILEGES ON ejbcadb.* TO 'ejbca'@'127.0.0.1' IDENTIFIED BY 'vukilis';
mysql> GRANT ALL PRIVILEGES ON ejbcadb.* TO 'ejbca'@'::1' IDENTIFIED BY 'vukilis';
QUIT
```

Test connection to the new database with:

```bash
mysql -u ejbca -D ejbcadb -p
```

### Installing Application Server

EJBCA can run on a supported AS. Due to differences between application servers, your AS should be configured according to the AS specific instructions referenced below.

To download, refer to [WildFly download](http://wildfly.org/downloads/).

Download the Wildfly and extract tar.gz file to /opt folder

```bash
sudo mkdir -p /opt/packages

cd /opt/
sudo wget https://github.com/wildfly/wildfly/releases/download/26.0.0.Final/wildfly-26.0.0.Final.zip -O /opt/packages/wildfly-26.0.0.Final.zip

sudo unzip -q /opt/packages/wildfly-26.0.0.Final.zip -d /opt/
```

Set the **APPSRV_HOME** environment variable to **/opt/wildfly:**

```bash
echo 'export APPSRV_HOME="/opt/wildfly"' | sudo tee --append /etc/profile.d/vukilis-ejbca.sh
source /etc/profile.d/vukilis-ejbca.sh
```

Add wildfly user:

```bash
useradd -r -U -M -d /opt/wildfly -s /bin/bash -c "Wildfly" wildfly
```

> Note
>
> Change default shell of wildfly to /sbin/nologin after the installation.

Create a symbolic link to point to the WildFly installation directory, and give access to the WildFly group and user:

```bash
sudo ln -snf /opt/wildfly-26.0.0.Final /opt/wildfly

sudo rm -f /opt/wildfly/bin/*.{bat,ps1}
sudo find /opt/wildfly/ -type d -exec chmod 0750 {} \;
sudo find /opt/wildfly/ -type f -exec chmod 0640 {} \;
sudo chown -R root:wildfly /opt/wildfly/
sudo chown -R wildfly /opt/wildfly/standalone/
```

### Configuring JBOSS/WildFly

Backup default/original `standalone.conf` configuration file:

```bash
cp -rp /opt/wildfly/bin/standalone.conf /opt/wildfly/bin/standalone.conf.bak
```

Replace `standalone.conf` with the following:  
**/opt/wildfly/bin/standalone.conf**

```ini
if [ "x$JBOSS_MODULES_SYSTEM_PKGS" = "x" ]; then
     JBOSS_MODULES_SYSTEM_PKGS="org.jboss.byteman"
fi

if [ "x$JAVA_OPTS" = "x" ]; then
     JAVA_OPTS="-Xms{{ HEAP_SIZE }}m -Xmx{{ HEAP_SIZE }}m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m"
     JAVA_OPTS="$JAVA_OPTS -Dhttps.protocols=TLSv1.2,TLSv1.3"
     JAVA_OPTS="$JAVA_OPTS -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
     JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true"
     JAVA_OPTS="$JAVA_OPTS -Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS"
     JAVA_OPTS="$JAVA_OPTS -Djava.awt.headless=true"
     JAVA_OPTS="$JAVA_OPTS -Djboss.tx.node.id={{ TX_NODE_ID }}"
     JAVA_OPTS="$JAVA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
     JAVA_OPTS="$JAVA_OPTS -Djdk.tls.ephemeralDHKeySize=2048"
else
     echo "JAVA_OPTS already set in environment; overriding default settings with values: $JAVA_OPTS"
fi
```

### Set allowed memory usage

By default, 512 MB of heap (RAM) is allowed to be used by the AS. This is not sufficient to run EJBCA. We recommended to allocate at least 2048 MB of RAM. To increase the default value, run the following command:

```bash
sed -i -e 's/{{ HEAP_SIZE }}/2048/g' /opt/wildfly/bin/standalone.conf
```

Set the Transaction Node ID

Set the transaction node ID to a unique number. The node ID is used by the transactions subsystem and ensures that the transaction manager only recovers branches which match the specified identifier. It is imperative that this identifier is unique between WildFly instances sharing either an object store or access common resource managers (i.e. when EJBCA is operating in a cluster).

```bash
sed -i -e "s/{{ TX_NODE_ID }}/$(od -A n -t d -N 1 /dev/urandom | tr -d ' ')/g" /opt/wildfly/bin/standalone.conf
```

Configure WildFly as a Service

```bash
cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin
cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system

mkdir /etc/wildfly/
cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/

systemctl daemon-reload
chown -R wildfly:wildfly /opt/wildfly-26.0.0.Final/
sudo chmod 0750 /opt/wildfly/bin/*.sh

echo 'export APPSRV_HOME="/opt/wildfly"' > /etc/profile.d/wildfly.sh
source /etc/profile.d/wildfly.sh
```

Start and enable wildfly service

```bash
systemctl start wildfly
systemctl enable wildfly
systemctl status wildfly
```

### Create an Elytron Credential Store

You can protect passwords by storing them in a credential store. The credential is encrypted with a master password which is fetched by WildFly on startup.

Create a master password, by creating a script which outputs the master password to stdout and ensure the script can only be executed by the wildfly user:

```bash
echo '#!/bin/sh' > /usr/bin/wildfly_pass
echo "echo '$(openssl rand -base64 24)'" >> /usr/bin/wildfly_pass
chown wildfly:wildfly /usr/bin/wildfly_pass
chmod 700 /usr/bin/wildfly_pass
```

Create a credential store in /opt/wildfly/standalone/configuration encrypted with the password echoed by the wildfly_pass script.

```bash
mkdir /opt/wildfly/standalone/configuration/keystore
chown wildfly:wildfly /opt/wildfly/standalone/configuration/keystore

/opt/wildfly/bin/jboss-cli.sh --connect '/subsystem=elytron/credential-store=defaultCS:add(path=keystore/credentials, relative-to=jboss.server.config.dir, credential-reference={clear-text="{EXT}/usr/bin/wildfly_pass", type="COMMAND"}, create=true)'
```

### MariaDB Database Driver Setup

Download MariaDB Java Connector and copy this file manually to the wildfly deployment directory:

```bash
wget https://dlm.mariadb.com/3478926/Connectors/java/connector-java-2.7.11/mariadb-java-client-2.7.11.jar -O /opt/packages/mariadb-java-client-2.7.11.jar
```

Copy existing `mariadb-java-client.jar` to deployment directory in order to hot-deploy JDBC driver. This will be picked up by WildFly and deployed so we can create a data source straigh away.

```bash
cp /opt/packages/mariadb-java-client-2.7.11.jar /opt/wildfly/standalone/deployments/mariadb-java-client.jar
```

Fix permissions:

```bash
chown -v wildfly: /opt/wildfly/standalone/deployments/mariadb-java-client.jar
chmod -v 0640 /opt/wildfly/standalone/deployments/mariadb-java-client.jar
```

### Datasource Configuration

```bash
/opt/wildfly/bin/jboss-cli.sh --connect

/subsystem=elytron/credential-store=defaultCS:add-alias(alias=dbPassword, secret-value="linux!2345")

data-source add --name=ejbcads --connection-url="jdbc:mysql://127.0.0.1:3306/ejbcadb" --jndi-name="java:/EjbcaDS" --use-ccm=true --driver-name="mariadb-java-client.jar" --driver-class="org.mariadb.jdbc.Driver" --user-name="ejbca" --credential-reference={store=defaultCS, alias=dbPassword} --validate-on-match=true --background-validation=false --prepared-statements-cache-size=50 --share-prepared-statements=true --min-pool-size=5 --max-pool-size=150 --pool-prefill=true --transaction-isolation=TRANSACTION_READ_COMMITTED --check-valid-connection-sql="select 1;"
```

### Configure Remoting

EJBCA needs to use JBOSS Remoting for EJBCA CLI to work. Configure it to use a separate port 4447 and remove any other dependency on remoting except for what EJBCA needs.  

```bash
/subsystem=remoting/http-connector=http-remoting-connector:write-attribute(name=connector-ref,value=remoting)
/socket-binding-group=standard-sockets/socket-binding=remoting:add(port=4447,interface=management)
/subsystem=undertow/server=default-server/http-listener=remoting:add(socket-binding=remoting,enable-http2=true)
:reload
```

### Configure Logging

Configure logging in WildFly to be able to dynamically change logging while the application server is running.

Logging options:

1. INFO - Recommended Logging
2. QUIET - audit log messages, warnnings and errors

> Note
>
> INFO log level for org.ejbca and org.cesecore is recommended for production systems.

```bash
/subsystem=logging/logger=org.ejbca:add(level=INFO)
/subsystem=logging/logger=org.cesecore:add(level=INFO)
/subsystem=logging/logger=com.keyfactor:add(level=INFO)
```

### Audit logging to file

You can write the EJBCA audit log to a separate file (`/opt/wildfly/standalone/log/cesecore-audit.log`), rotate every 128 MB and keep one rotated file:

```bash
/subsystem=logging/size-rotating-file-handler=cesecore-audit-log:add(file={path=cesecore-audit.log, relative-to=jboss.server.log.dir}, max-backup-index=1, rotate-size=128m)
/subsystem=logging/logger=org.cesecore.audit.impl.log4j.Log4jDevice:add
/subsystem=logging/logger=org.cesecore.audit.impl.log4j.Log4jDevice:add-handler(name=cesecore-audit-log)
```

### HTTP(S) Configuration

The following section explains how to configure HTTP(S) using Undertow.

Run the following commands in JBoss CLI to remove existing TLS and HTTP configuration:

```bash
/subsystem=undertow/server=default-server/http-listener=default:remove()
/socket-binding-group=standard-sockets/socket-binding=http:remove()
/subsystem=undertow/server=default-server/https-listener=https:remove()
/socket-binding-group=standard-sockets/socket-binding=https:remove()
:reload
```

Wait for the reload to complete by checking the server log or the result of:

```bash
:read-attribute(name=server-state)
```

The following section explains how to set up Undertow with 3-port separation. Port 8080 is used for HTTP (unencrypted traffic), port 8442 for HTTPS (encrypted) traffic with only server authentication and port 8443 for HTTPS (encrypted) traffic with both server and client authentication.

To add new interfaces and sockets, use the following:

```bash
/interface=http:add(inet-address="0.0.0.0")
/interface=httpspub:add(inet-address="0.0.0.0")
/interface=httpspriv:add(inet-address="0.0.0.0")
/socket-binding-group=standard-sockets/socket-binding=http:add(port="8080",interface="http")
/socket-binding-group=standard-sockets/socket-binding=httpspub:add(port="8442",interface="httpspub")
/socket-binding-group=standard-sockets/socket-binding=httpspriv:add(port="8443",interface="httpspriv")
```

Configure TLS

```bash
/subsystem=elytron/credential-store=defaultCS:add-alias(alias=httpsKeystorePassword, secret-value="serverpwd")
/subsystem=elytron/credential-store=defaultCS:add-alias(alias=httpsTruststorePassword, secret-value="changeit")
/subsystem=elytron/key-store=httpsKS:add(path="keystore/keystore.p12",relative-to=jboss.server.config.dir,credential-reference={store=defaultCS, alias=httpsKeystorePassword},type=PKCS12)
/subsystem=elytron/key-store=httpsTS:add(path="keystore/truststore.p12",relative-to=jboss.server.config.dir,credential-reference={store=defaultCS, alias=httpsTruststorePassword},type=PKCS12)
/subsystem=elytron/key-manager=httpsKM:add(key-store=httpsKS,algorithm="SunX509",credential-reference={store=defaultCS, alias=httpsKeystorePassword})
/subsystem=elytron/trust-manager=httpsTM:add(key-store=httpsTS)
/subsystem=elytron/server-ssl-context=httpspub:add(key-manager=httpsKM,protocols=["TLSv1.3","TLSv1.2"],use-cipher-suites-order=false,cipher-suite-filter="TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",cipher-suite-names="TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256")
/subsystem=elytron/server-ssl-context=httpspriv:add(key-manager=httpsKM,protocols=["TLSv1.3","TLSv1.2"],use-cipher-suites-order=false,cipher-suite-filter="TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",cipher-suite-names="TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256",trust-manager=httpsTM,need-client-auth=true)
```

Add HTTP(S) Listeners

```bash
/subsystem=undertow/server=default-server/http-listener=http:add(socket-binding="http", redirect-socket="httpspriv")
/subsystem=undertow/server=default-server/https-listener=httpspub:add(socket-binding="httpspub", ssl-context="httpspub", max-parameters=2048)
/subsystem=undertow/server=default-server/https-listener=httpspriv:add(socket-binding="httpspriv", ssl-context="httpspriv", max-parameters=2048)
:reload
```

HTTP Protocol Behaivor Configuration

```bash
/system-property=org.apache.catalina.connector.URI_ENCODING:add(value="UTF-8")
/system-property=org.apache.catalina.connector.USE_BODY_ENCODING_FOR_QUERY_STRING:add(value=true)
/system-property=org.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH:add(value=true)
/system-property=org.apache.tomcat.util.http.Parameters.MAX_COUNT:add(value=2048)
/system-property=org.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH:add(value=true)
/subsystem=webservices:write-attribute(name=wsdl-host, value=jbossws.undefined.host)
/subsystem=webservices:write-attribute(name=modify-wsdl-address, value=true)
```

Redirect to Application for Unknown URLs

Known URLs for EJBCA starts with /ejbca, /crls, /certificates or /.well-known (EST and ACME) according to the following example:

```bash
/subsystem=undertow/configuration=filter/rewrite=redirect-to-app:add(redirect=true,target="/ejbca/")
/subsystem=undertow/server=default-server/host=default-host/filter-ref=redirect-to-app:add(priority=1,predicate="method(GET) and not path-prefix(/ejbca,/crls,/certificates,/.well-known) and not equals({\%{LOCAL_PORT}, 4447})")
```

URL Rewriting

```bash
/subsystem=undertow/configuration=filter/rewrite=crl-rewrite:add(target="/ejbca/publicweb/crls/$${1}")
quit
```

Execute following command:

```bash
/opt/wildfly/bin/jboss-cli.sh --connect "/subsystem=undertow/server=default-server/host=default-host/filter-ref=crl-rewrite:add(predicate=\"method(GET) and regex('/crls/(.*)')\")"
```

You can remove the ExampleDS datasource as it is not being used.  

```bash
/opt/wildfly/bin/jboss-cli.sh --connect

/subsystem=ee/service=default-bindings:remove()
data-source remove --name=ExampleDS
:reload
quit
```

### Install Apache Ant

```bash
cd /opt/packages/

wget https://dlcdn.apache.org//ant/binaries/apache-ant-1.10.14-bin.zip
wget https://downloads.apache.org/ant/binaries/apache-ant-1.10.14-bin.zip.sha512

unzip /opt/packages/apache-ant-1.10.14-bin.zip -d /opt/
sudo ln -s /opt/apache-ant-1.10.14 /opt/ant
```

> Note
>
> Edit **/etc/profile.d/ant.sh** with nano or vi.

```bash
# /etc/profile.d/ant.sh
export ANT_HOME=/opt/ant
export PATH=${PATH}:${ANT_HOME}/bin
```

```bash
source /etc/profile.d/ant.sh
```

### EJBCA Installation

Extract archive to `/opt` and create symbolic link

```bash
unzip ejbca_ee_8_2_0_3.zip -d /opt/

ln -snf /opt/ejbca_ee* /opt/ejbca
```

The folder `/opt/ejbca` contains the EJBCA source code. Create folder `/opt/ejbca-custom` contains following configuration files within `conf` directory:

```bash
mkdir -p /opt/ejbca-custom/conf

ejbca-custom/
└── conf
    ├── cesecore.properties
    ├── database.properties
    ├── ejbca.properties
    ├── install.properties
    └── web.properties
```

Edit next configuration files:  

* **/opt/ejbca-custom/conf/cesecore.properties**

```ini
allow.external-dynamic.configuration=true
certificate.validityoffset=-10m
database.crlgenfetchsize=500000
securityeventsaudit.implementation.0=org.cesecore.audit.impl.log4j.Log4jDevice
securityeventsaudit.implementation.1=org.cesecore.audit.impl.integrityprotected.IntegrityProtectedDevice
securityeventsaudit.exporter.1=org.cesecore.audit.impl.AuditExporterXml
```

* **/opt/ejbca-custom/conf/database.properties**

```ini
datasource.jndi-name=EjbcaDS
database.name=mysql
database.url=jdbc:mysql://127.0.0.1:3306/ejbcadb?characterEncoding=UTF-8
database.driver=org.mariadb.jdbc.Driver
database.username=ejbca
database.password=linux!2345
```

* **/opt/ejbca-custom/conf/ejbca.properties**

```ini
appserver.home=/opt/wildfly
appserver.type=jboss
ejbca.productionmode=true
allow.external-dynamic.configuration=true
ejbca.cli.defaultusername=ejbca
ejbca.cli.defaultpassword=ejbca
```

* **/opt/ejbca-custom/conf/install.properties**

```ini
ca.name=ManagementCA
ca.dn=CN=ManagementCA,O=Vukilis,C=RS
ca.tokentype=soft
ca.tokenpassword=null
ca.keyspec=2048
ca.keytype=RSA
ca.signaturealgorithm=SHA256WithRSA
ca.validity=3650
ca.policy=null
```

* **/opt/ejbca-custom/conf/web.properties**

```ini
java.trustpassword=changeit
superadmin.cn=SuperAdmin-Training
superadmin.dn=CN=${superadmin.cn},O=Vukilis,C=RS
superadmin.password=ejbca
superadmin.batch=true
httpsserver.password=serverpwd
httpsserver.hostname=localhost
httpsserver.dn=CN=${httpsserver.hostname},O=Vukilis,C=RS
httpsserver.tokentype=P12
```

Fix file and directory permissions:

```bash
chown -R wildfly:wildfly /opt/wildfly/*
chown -R wildfly:wildfly /opt/ejbca-custom/
chown -R wildfly:wildfly /opt/ejbca_*/
chown -R wildfly:wildfly /opt/wildfly-*/
chown -R wildfly:wildfly /etc/utimaco/
chown -R wildfly:wildfly /opt/utimaco/
```

### HSM configuration

Before you start configuring ejbca for HSM be sure you configured correctly HSM.

* **/opt/ejbca-custom/conf/catoken.properties**

```ini
sharedLibrary /opt/utimaco/p11/libcs_pkcs11_R3.so
slotLabelType=SLOT_NUMBER
slotLabelValue=3

# CA key configuration
defaultKey sign
certSignKey sign
crlSignKey sign
testKey test
```

Add following lines in **/opt/ejbca-custom/conf/web.properties**

```bash
echo "cryptotoken.p11.lib.110.name=Utimaco R3" >> /opt/ejbca-custom/conf/web.properties
echo "cryptotoken.p11.lib.110.file=/opt/utimaco/p11/libcs_pkcs11_R3.so" >> /opt/ejbca-custom/conf/web.properties
```

Copy following files and directories from the client PC to the remote server:

* p11tool2
* libcs_pkcs11_R3.so

```bash
scp -r <file> vukilis@172.10.0.10:/tmp/
```

Create utimaco configuration directory:

```bash
mkdir -p /opt/utimaco/p11/
```

Move files from **/tmp** to **/opt/packages/utimaco/**

```bash
mv /tmp/p11tool2 /opt/utimaco/p11/
mv /tmp/libcs* /opt/utimaco/p11/
```

* Create file **/opt/utimaco/p11/libcs_pkcs11_R3.ini**

```ini
[Global]
Timeout = 5000
Logging = 0
Logpath = /tmp

[CryptoServer]
Device     = 172.10.0.34
Timeout    = 600000
AppTimeout = 172800
SlotCount  = 2
```

Set permissions:

```bash
chmod -v 0750 /opt/utimaco/p11/p11tool2
chmod -v 0644 /opt/utimaco/p11/libcs_pkcs11_R3.so
chmod u+w /opt/utimaco/p11/libcs_pkcs11_R3.ini
```

### Build EJBCA

Log in as `wildfly` user and change working directory to `/opt/ejbca`:

```bash
su - wildfly

cd /opt/ejbca

ant -q clean deployear
```

Build `clientToolBox`

```bash
ant -q clientToolBox
```

Install The EJBCA:

```bash
ant runinstall
```

Deploy keystore:

```bash
ant deploy-keystore
```

Restart EJBCA

> Note
>
> First try to access EJBCA Public page without wildfly service restart. If there is problem with TLS handshake, please do restart wildlfly service.

Access the EJBCA Public Web using web browser using first node on the following link:

```ini
@ http://172.10.0.10:8080/ejbca
```

Download `superadmin.p12`. It is located under:

```bash
/opt/ejbca/p12/
```

Import `superadmin.p12` into browser and restart web browser in order to reload its cert store.

Open EJBCA Administration page:

```ini
@ https://172.10.0.10:8443/ejbca/adminweb
```

## `3. When EJBCA installation is done stop mariadb service`

On each nodes stop mariadb service with following command:

```bash
sudo systemctl stop mariadb.service
```

## `4. Follow the procedure for Galera installation`

### Prerequisites

1) 3 servers with preinstalled Debian 12 Linux distribution
2) For each server, 2 network adapters configured  
  a) 1 adapter for Internet access  
  b) 1 adapter for communication/replication among the nodes  
    * (172.30.0.165, 172.30.0.166, 172.30.0.167)
3) Root password set to '**linux!2345**'
4) Optional: Default configuration of Debian installation doesn't have an
active firewall. For other Linux distribution it is needed to open and
configure ports **3306 (TCP)**, **4444 (TCP)**, **4567 (TCP and UDP)**, **4568 (TCP)**
and configure **SELinux** policies if needed.

### Installation

On each node create galera configuration file:

```bash
sudo nano /etc/mysql/conf.d/galera.cnf
```

On the first node, add the following configuration to (`/etc/mysql/conf.d/galera.cnf`) file.  
*(IP address of the first node is **172.30.0.165**)*:

```ini
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0

# Galera Provider Configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so

# Galera Cluster Configuration
wsrep_cluster_name="alg_cluster"
wsrep_cluster_address="gcomm://172.10.0.166,172.10.0.167"

# Galera Synchronization Configuration
wsrep_sst_method=rsync

# Galera Node Configuration
wsrep_node_address="172.10.0.165"
wsrep_node_name="galera1"
```

On the second node, add the following configuration to (`/etc/mysql/conf.d/galera.cnf`) file  
*(IP address of the second node is **172.10.0.166**)*:

```ini
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0

# Galera Provider Configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so

# Galera Cluster Configuration
wsrep_cluster_name="alg_cluster"
wsrep_cluster_address="gcomm://172.10.0.165,172.10.0.167"

# Galera Synchronization Configuration
wsrep_sst_method=rsync

# Galera Node Configuration
wsrep_node_address="172.10.0.166"
wsrep_node_name="galera2"
```

On the third node, add the following configuration to (`/etc/mysql/conf.d/galera.cnf`) file  
*(IP address of the third node is **172.10.0.167**)*:

```ini
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0

# Galera Provider Configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so

# Galera Cluster Configuration
wsrep_cluster_name="alg_cluster"
wsrep_cluster_address="gcomm://172.10.0.165,172.10.0.166"

# Galera Synchronization Configuration
wsrep_sst_method=rsync

# Galera Node Configuration
wsrep_node_address="172.10.0.167"
wsrep_node_name="galera3"
```

On the first node start galera cluster:

```bash
sudo galera_new_cluster
```

On the first node execute the following command to check the cluster size  
*(DB root password "**linux!2345**")*:

```bash
mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"


Output
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 1     |
+--------------------+-------+
```

On the second node start mariadb service and add the node to the cluster:

```bash
sudo systemctl start mariadb
```

On the third node start mariadb service and add the node to the cluster:

```bash
sudo systemctl start mariadb
```

On the first node execute the following command to check the updated cluster size:

```bash
mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"

Output
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 3     |
+--------------------+-------+
```

### Testing Replication

On the first node create a database and insert test data:

```bash
mysql -u root -p -e 'CREATE DATABASE playground;'
mysql> CREATE TABLE playground.equipment ( id INT NOT NULL AUTO_INCREMENT, type VARCHAR(50), quant INT, color VARCHAR(25), PRIMARY KEY(id));
mysql> INSERT INTO playground.equipment (type, quant, color) VALUES ("slide", 2, "blue");
```

Look at the second node to verify that replication is working:

```bash
mysql -u root -p -e 'SELECT * FROM playground.equipment;'

Output
+----+-------+-------+-------+
| id | type  | quant | color |
+----+-------+-------+-------+
|  1 | slide |     2 | blue  |
+----+-------+-------+-------+
```

On the second node insert test data:

```bash
mysql -u root -p -e 'INSERT INTO playground.equipment (type, quant, color) VALUES ("swing", 10, "yellow");'
```

From the third node, you can read all of this data by querying the table again:

```bash
Output
+----+-------+-------+--------+
| id | type  | quant | color  |
+----+-------+-------+--------+
|  1 | slide |     2 | blue   |
|  2 | swing |    10 | yellow |
+----+-------+-------+--------+
```

Again, you can add another value from this node:

```bash
mysql -u root -p -e 'INSERT INTO playground.equipment (type, quant, color) VALUES ("seesaw", 3, "green");'
```

Back on the first node, you can verify that your data is available everywhere:

```bash
mysql -u root -p -e 'SELECT * FROM playground.equipment;'

Output
+----+--------+-------+--------+
| id | type   | quant | color  |
+----+--------+-------+--------+
|  1 | slide  |     2 | blue   |
|  2 | swing  |    10 | yellow |
|  3 | seesaw |     3 | green  |
+----+--------+-------+--------+
```

> Note
>  
> Always start Galera Cluster on the node where mariadb service was the last stopped.  
If the last time you stopped mariadb service in the following order galera3 --> galera2 --> galera1, you should initiate Galera Cluster
on galera1 node.

### MariaDB Backup and Restore

On each node install MariaDB backup package:

```bash
sudo apt-get install mariadb-backup
```

On the third node create backup directory:

```bash
mkdir -p /var/mariadb/backup/
```

On the third node make a backup of MariaDB database:

```bash
sudo mariabackup --backup --target-dir=/var/mariadb/backup/ --user=root --password=linux!2345
```

On the third node check the backed up content:

```bash
sudo ls -l /var/mariadb/backup/
```

On the third node stop mariadb service:

```bash
sudo systemctl stop mariadb
```

On the third node first prepare backup in order to restore it:

```bash
sudo mariabackup --prepare --target-dir=/var/mariadb/backup/
```

On the third node remove the content from the MariaDB data directory (`/var/lib/mysql/`):

```bash
sudo rm -rf /var/lib/mysql/*
```

On the third node start MariaDB restore:

```bash
sudo mariabackup --copy-back --target-dir=/var/mariadb/backup/
```

On the third node fix the file permissions for the restored data:

```bash
sudo chown -R mysql:mysql /var/lib/mysql/
```

On the third node start mariadb service, join the existing Galera Cluster and sync the restored data:

```bash
sudo systemctl start mariadb
```

On the third node check the restored and synced data.

## `5. Open EJBCA Administration page`

Download each `superadmin.p12` file.

On node1:

```bash
cd /opt/ejbca/p12/
cp superadmin.p12 /tmp
scp vukilis@172.10.0.65:/tmp/superadmin.p12 /tmp/superadminca1.p12
```

On node2:

```bash
cd /opt/ejbca/p12/
cp superadmin.p12 /tmp
scp vukilis@172.10.0.66:/tmp/superadmin.p12 /tmp/superadminca2.p12
```

On node3:

```bash
cd /opt/ejbca/p12/
cp superadmin.p12 /tmp
scp vukilis@172.10.0.67:/tmp/superadmin.p12 /tmp/superadminca3.p12
```

Import each `superadmin.p12` into browser and restart web browser in order to reload its cert store.  
You need to open private browser window for each cert store of specific node.
When you are asked to identify yourself, you need to choose the certificate of said node.

{{< image src="certificate" src_s="/images/2024/How_to_install_EJBCA_with_Apache_proxy_and_galera_with_HSM_module/certificate_identify.PNG" src_l="/images/2024/How_to_install_EJBCA_with_Apache_proxy_and_galera_with_HSM_module/certificate_identify.PNG" width="100%">}}

## References

https://doc.primekey.com/ejbca/tutorials-and-guides



