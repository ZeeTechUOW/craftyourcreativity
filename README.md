# Craft Your Creativity
Craft Your Creativity is a web based e-learning project that incorporate gamification. This project created to fullfill the requirement of CSIT321 for Zeetech group.

## Getting started
### Prerequisites
* Java SE Development Kit 8
* Java IDE
* Tomcat 8
* MySQL 5.6 or MariaDB 10.1

### Run the project
#### Using Netbeans IDE 8.2
1. Team > Git > Clone
2. Insert the repository URL
```
https://github.com/ZeeTechUOW/craftyourcreativity.git
```
3. Open the project
4. Import the .sql in /db/ folder to your database
5. Edit ProjectProperties.java in package Model to match the database url, user, and pass
6. Run the project

#### Using other Java IDE
1. Clone the project
```
https://github.com/ZeeTechUOW/craftyourcreativity.git
```
2. Open the project
3. Add all library from /lib/ folder
4. Set the project configuration to use Tomcat 8
5. Import the .sql in /db/ folder to your database
6. Edit ProjectProperties.java in package Model to match the database url, user, and pass
7. Run the project

## Deploying to web server
When compiling and running the project in you machine, the project is already deployed in your local machine.
In case you want to deploy the project in server, the server should meet this requirements:
* Tomcat 8
* MySQL 5.6 or MariaDB 10.1

### Deploying the project to web server
1. Clean and build the project
2. Copy .war file from /dist/ folder in project root folder
3. Stop the Tomcat service in web server
4. Locate and navigate to the tomcat directory in web server
5. Paste the .war file into /webapps/ folder
6. Start the Tomcat service
The project could be accessed from local machine from
```
http://localhost:8084/your-webapps-name/
```
or
```
http://server-ip-address/your-webapps-name/
```
Change the server-ip-address to your web server ip address and your-webapps-name to .war file name from before.

### (Optional) Edit the webapps into ROOT webapps
To change and access your webapps url from
```
http://server-ip-address/your-webapps-name/
```
to
```
http://server-ip-address/
```
You could rename .war to ROOT.war before deploying to web server. If this method doesn't work then most likely your Tomcat is configured to use auto-deploy. For this situation, you need to edit the configuration with step as follow:
1. Stop the Tomcat service in web server
2. Locate and navigate to Tomcat directory in web server
3. Go to /conf/ folder
4. Edit server.xml to add this code in Host node (right before ```</Host>``` tag)
```
<Context path="" docBase="yourAppContextName">

  <!-- Default set of monitored resources -->
  <WatchedResource>WEB-INF/web.xml</WatchedResource>

</Context>
```
5. Start the Tomcat service in web server, the webapps now accessible from root url

## License
This project is licensed under [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Author
* Muhammad Harits Abiyyudo
* Ananda Rasyid Soedarmo
* Deni Barasena
* Andree Yosua
* Huy Tuan Anh Nguyen
