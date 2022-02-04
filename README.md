# Group 2 Networking Project
<b>Sparta Week 11 Networking Project</b>

A multi-user framework that would allow the users to create their own profiles and to add their apps/packages/components as items.
The user can:
* Create to their profiles
* Login to their profiles
* Add/Delete/List the apps/packages/components

The tools we used to construct the framework and app were:
* Spring
* Java
* AWS Cloud Services
* Terraform
* Docker

## Structure

The Infrastructure was modulated into 4 different modules. With each module being created for each server.

The resources created outside of the specific modules:
* VPC
* Route53 Zone
* Internet Gateway
* Route Association

![Structure](images/ModuleStructure.png)

## AWS Infrastructure
Apps, Database, Bastion and Proxies are isolated in their own subnets with zero trust model. This is done through individually configuring each NACL and security group for each of the servers.
### App Webserver
Resources Included:
* Subnet
* Route Table Association,
* NACL
* Security Group
* Instance
* Record for the Route53 zone


3 app servers will be created when terraform is applied with the same specifications as the others using the count functionality. All their public IP addresses are stored in records. These servers can connect to the internet as they are associated to a route table that allows access to the internet gateway.

The terraform code that creates the App instance:
![Structure](images/AppInstance.png)

### Database
The database contains the hashed passwords of the user’s profiles. Connected through the 3306 port defined in the application.properties file as well as the given port in the security group. This port allows only MySQL commands to pass through to the database and make the changes. The database is only accessible by the app webserver through bastion webserver.

Resources Included:
* Subnet
* Route Table Association,
* NACL
* Security Group
* Instance
* Record for the Route53 zone

The terraform code that creates the Database instance:
![Instance](images/DbInstance.png)

An example of how the hashed passwords are displayed in the database:
![HashedPasswords](images/HashedPasswords.png)


### Bastion
The Bastion's purpose is to allow the app access to the database through a subnet.


Resources Included:
* Subnet
* Route Table Association,
* NACL
* Security Group
* Instance
* Record for the Route53 zone

The terraform code that creates the Bastion instance:
![Instance](images/BastionInstance.png)

### Proxy
Implemented to mask the IP of the app servers, allowing for extra security.

Resources Included:
* Subnet
* Route Table Association,
* NACL
* Security Group
* Instance
* Record for the Route53 zone

The terraform code that creates the Proxy instance:
![Instance](images/ProxyInstance.png)


### Ansible

To Run the docker container on the app, docker was required to be installed onto the app server. To do this, we used an ansible playbook.

Ansible code that installs docker:
![Ansible](images/AnsibleCode.png)

## App Functionality

### Running the Docker Container

To run the docker container which creates the API:

```bash
  docker run -d -p 8080:8080 --mount type=bind,source=$(pwd)/application.properties,target=/application.properties konrad2020/items_api
```

### Signup

For user to register use the following endpoint:

**POST** `https://[IP address]/auth/signup`

It will also require JSON body, Example to create account for Mike:

```json
{
    "firstname" : "Mike",
    "lastname" : "Smith",
    "username" : "Smith1232133",
    "password" : "bluecat123"
}
```


### Singin

For user to log in with registered account use follwoing endpoint:

**POST** `https://[IP address]/auth/signin`

It will also require JSON body containing login details, example for Mike:

```JSon
{
    "username" : "Smith1232133",
    "password" : "bluecat123"
}
```

This will return Token which will be used for every request, Example of token for Mike:

```
Session Token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJTbWl0aDEyMzIxMzMifQ.iR7-GTRaMnxbTtL0w4Hf6oIDStktSSkLPyL_k6bBw5o
```

### Test connection

To test if account is valid, use the following endpoint with **token**:

Example with Mike's token:

**GET** `https://[IP address]/auth/test?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJTbWl0aDEyMzIxMzMifQ.iR7-GTRaMnxbTtL0w4Hf6oIDStktSSkLPyL_k6bBw5o`

Response:

```
Authorized
```
### Add Item

To add an item to list use the following endpoint:

Example for Mike account:

**POST** `https://[IP address]/items/add?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJTbWl0aDEyMzIxMzMifQ.iR7-GTRaMnxbTtL0w4Hf6oIDStktSSkLPyL_k6bBw5o`

This request will take JSON body, Example:

```json
{
    "item":"tree"
}
```

Response:

```
Item added for Mike
```

### Get list of items

To see list for given account use the following endpoint:

Example for Mike's list:

GET `https://[IP address]/items/all?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJTbWl0aDEyMzIxMzMifQ.iR7-GTRaMnxbTtL0w4Hf6oIDStktSSkLPyL_k6bBw5o`

Response

```json
[
    {
        "id": 1,
        "item": "nginx"
    },
    {
        "id": 2,
        "item": "tree"
    },
    {
        "id": 3,
        "item": "nano"
    }
]
```

### Delete item
To delete item from list use the following end point:

Takes two parameters:

1. ID of item
2. Token

Example to delete item from Mike's list:

DELETE `https://[IP address]/items/delete?id=1&token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJTbWl0aDEyMzIxMzMifQ.iR7-GTRaMnxbTtL0w4Hf6oIDStktSSkLPyL_k6bBw5o`

Response

```json
{
    "Deleted": true
}
```
