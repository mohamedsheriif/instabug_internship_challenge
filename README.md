# Wow Such Program

This program is very simple, it connects to a MySQL database based on the following env vars:
* MYSQL_HOST
* MYSQL_USER
* MYSQL_PASS
* MYSQL_PORT

And exposes itself on port 9090:
* On `/healthcheck` it returns an OK message,
* On GET it returns all recorded rows.
* On POST it creates a new row.
* On PATCH it updates the creation date of the row with the same ID as the one specified in query parameter `id`

**1-Docker file**

The Dockerfile first builds the Go application in a separate build stage and then creates a runtime container based on Alpine Linux. It sets a non-root user, copies the compiled application, and exposes the necessary port. Finally, it specifies the command to run the application within the container.
**test** : you can make simple test after building the image by running the app container and mysql container by the following commands  
`docker network create mynetwork`  
`docker run -d --network mynetwork --network-alias mysql --name=mysql -e MYSQL_ROOT_PASSWORD=1234 mysql`  
`docker run -d -p 9090:9090 --network mynetwork -e MYSQL_HOST=mysql -e MYSQL_USER='root' -e MYSQL_PASS=1234 -e MYSQL_PORT=3306 instabug`  
then open the browser on `localhost:9090/healthcheck`


**2-Jenkins pipeline**  

The pipeline is divided into two stages. The first stage builds the app Docker image. If any errors occur during the build process, the pipeline will terminate, and the errors will be displayed in the logs. Only if the build is successful, the pipeline proceeds to the second stage and pushes the image to docker hub  

![image](https://github.com/mohamedsheriif/instabug_internship_challenge/assets/53241112/c2895ae8-b152-4e08-8420-5153ad8797c6)



**3-Docker-compose**  

in the docker-compose file it runs mysql container and sets rootpassword and the application will run based on the image pushed in the previous step and it depends on mysql container and it restarts always because mysql container takes sometime to setup
app running localy:  

![image](https://github.com/mohamedsheriif/instabug_internship_challenge/assets/53241112/361e56a8-8f9e-4046-872c-c4d90dfdc867)

**4-Helm manifests for kubernetes and auto-scaling replicas**  

the templates include two deployments: one for the application and another for MySQL,a service is created for the application to provide clients with a network endpoint for accessing the pods and a **Horizontal pod Autoscaler** to autoscale the number of the replicas of the application depending on the cpu utilization

`helm install myapp ./chart`  
`helm get all` to check that everything is ok  
pods , services , HPA:
![image](https://github.com/mohamedsheriif/instabug_internship_challenge/assets/53241112/f4f3d619-ccde-4d53-a673-d14366df7110)
to open from browser : `kubectl port-forward service/instabug 9090:9090`  

**5-argocd to apply gitops and CD**  
![image](https://github.com/mohamedsheriif/instabug_internship_challenge/assets/53241112/4c33c8d9-d873-42ed-a8e9-e5d16bf71b84)

**6-securing docker container**  
 * used official and trusted base images
 * run the container in user mode not in root with the least privileges
 * limited ports exposed
 * we can make docker uses https instead of tcp

**7-the bug in the code**
I found the bug while testing the api on **post** it doesn't create new row and the problem is the row struct passed to json.marshal
the fields in the struct must begin with upper case letter, and it began with lower case letter  
solution:  
![image](https://github.com/mohamedsheriif/instabug_internship_challenge/assets/53241112/98953cf8-da82-4a5d-8281-aaff9f2cb26a)


