NAME: ONOJA STEVEN

PERIOD: SET25

PROJECT: AUTO-DISCOVERY PET ADOPTION PROJECT

DATE: 31st October 2025

**Overview**

This project aims to build a **highly available**, **highly scalable**,
and **secure cloud environment** for deploying the Pet Adoption
application. It also incorporates an **auto-discovery mechanism**
designed to help **Ansible**, the configuration management tool,
automatically record and update all server IP addresses in its
inventory.

The **auto-discovery script** enables Ansible, configured with the AWS
Command Line Interface (CLI), to query the AWS account for all servers
tagged with a specific identifier. Using this tag, the script retrieves
the private IP addresses of all instances within the private subnets
that host the Pet Adoption application. This ensures that updates,
patches, or configuration changes can be applied **simultaneously** and
**consistently** across all servers.

To guarantee **high availability**, the application's infrastructure is
distributed across **two Availability Zones (AZs)** within the same AWS
region. This design ensures that the application remains accessible with
an uptime of **99.99%**, providing uninterrupted service to end users
even in the event of an AZ failure.

Scalability is achieved through the implementation of **Auto Scaling
Groups (ASGs)**, which automatically adjust the number of instances in
response to demand. This dynamic scaling is what necessitates the
auto-discovery feature---allowing Ansible to stay synchronized with all
newly launched or terminated servers. Ansible is configured to run a
**cron job** every minute, ensuring its registry always matches the
current state of servers within AWS.

Security is enforced at multiple levels throughout the project. The
environment is **isolated** within an AWS **Virtual Private Cloud
(VPC)**, and **security groups** are configured to open only essential
ports for communication between components. A **NAT Gateway** protects
private subnets by restricting direct internet access while still
allowing outbound traffic for updates.

On the application and DevOps side, security best practices are
followed:

-   **Private Git repositories** are protected using **token-based
    authentication**.

-   **OWASP dependency checks** secure third-party libraries and
    dependencies.

-   **Trivy** performs vulnerability scanning on Docker images to ensure
    they are stable and secure.

-   **Checkov** enforces compliance and ensures that Terraform-based
    infrastructure provisioning follows industry security standards.

Together, these measures create a robust, self-healing, and secure cloud
environment optimized for continuous deployment and long-term
reliability of the Pet Adoption application.

**AIMS & OBJECTIVES**

Aims:

I.  The first aim of this project is to design a highly available,
    highly scalable, and secure environment.

II. The second aim is to develop an auto-discover script that will
    enable Ansible as the configuration tool manager to have a record of
    all the servers provisioned that run the pet adoption application.

Objectives:

I.  Create all the Terraform code used to provision the cloud
    infrastructure.

II. Set up the Jenkins and Vault server

III. Use Jenkins to provision the cloud infrastructure pipeline

IV. Configure and download all the plugins needed by Jenkins to manage
    all servers

V.  Set up the individual servers needed to run the pipeline script.

VI. Create the application pipeline to deploy the application to the
    cloud environment.

VII. Monitor the servers using the New Relic monitoring agent,

**Architectural Diagram**

![Screenshot](images/image1.png)

**PROJECT WORK-FLOW**

**HIGHLIGHTS**

From the image above, the application is being hosted in the cloud with
AWS as our cloud provider.

-   There are two availability zones for high availability, all
    contained within our virtual private cloud.

-   Public subnets that host the public phasing application and
    components.

-   NAT gateway that blocks direct public access to our private subnet.

-   Private subnets that host our pet-adoption application and its
    dependent components, like the Amazon Relational Database IRDS)
    while shielding it from public internet access.

-   Bastion host in the public subnet that helps us to connect securely
    to our private subnets.

-   The Jenkins server, which helps us to continuously integrate and
    deliver both our application and cloud infrastructure pipeline.

-   The Vault server is being used to keep our Amazon RDS credentials
    secure.

-   Auto-scaling group to scale up and down our application and bastion
    host to make sure this application is highly available.

-   Application Load balancers that route users\' requests(traffic) to
    access our application from the internet to the private subnet where
    the application is deployed

-   Ansible server, which is the configuration manager tool to configure
    our Docker servers to deploy the pet-adoption application

**FLOW**

To set up this project, the first step is to provision Jenkins and the
Vault server locally. These two components form the foundation for
automation and secure secret management.

Once Jenkins is up and running, it is connected to the Infrastructure as
Code (IaC) repository created by the DevOps team. When triggered,
Jenkins executes the Terraform scripts within that repository to
automatically build and configure all the necessary cloud infrastructure
--- including the VPC, subnets, load balancers, security groups,
databases, and application environments.

After the infrastructure is successfully deployed, Jenkins is then
integrated with the Pet Adoption application repository. From there, the
application is processed through a well-defined CI/CD pipeline that
includes automated testing, security scanning, and deployment stages.
This pipeline ensures the application maintains high code quality,
strong security compliance, lightweight deployments, and overall
operational efficiency within the cloud environment.

**STAGE 1: INFRASTRUCTURE PROVISIONING**

A Link to all the Terraform codes that were used for this project which
are stored in a private repo:
<https://github.com/Level-p/Devops-auto-discovery.git>

1.  The auto-discovery script used for this project, as previously
    explained in the overview![Screenshot](images/image2.png)

2.  The cron job was created to ensure that at every minute, Ansible has
    all the private IP addresses of all servers running the pet-adoption
    application. ![A screenshot of a computer AI-generated content may
    be incorrect.](images/image3.png)

3.  Provisioning of the Jenkins server and the vault server. During this
    provisioning, an S3 bucket was created to store the Terraform state
    file, which is a history of all resources that have been provisioned
    on the AWS account. To start the provisioning, the
    "./create-s3-bucket sh" command was executed on the local machine.

N.B\
The local machine has the Terraform CLI and the AWS CLI configured and
linked to the AWS account used in this project. ![A screenshot of a
computer AI-generated content may be
incorrect.](images/image4.png)

4.  After the command was executed, Terraform provisioned the Jenkins
    and Vault server as seen in the image below. Now that this has been
    done, a Jenkins pipeline will be created to provision the
    infrastructure for this project. This is because in overall, Jenkins
    is designed to continuously integrate and deliver both the
    infrastructure pipeline and the application pipeline. ![A screenshot
    of a computer AI-generated content may be
    incorrect.](images/image5.png)

![Screenshot](images/image6.png)

5.  The vault server was created as an external means of managing the
    login credentials for the pet-adoption Amazon RDS database. This
    means was introduced as part of a cost-saving scheme to reduce
    reliance on some Amazon services ![A screenshot of a computer
    AI-generated content may be
    incorrect.](images/image7.png)

6.  The pic below shows the key token used to access the vault server.
    This token gives authorization to see the secrets stored in vaults.
    ![A computer screen with a black screen AI-generated content may be
    incorrect.](images/image8.png)

Once the secret is obtained, it is added as part of the provider block
so that Terraform can read from and write to Hashicorp Vault. ![A
screenshot of a computer program AI-generated content may be
incorrect.](images/image9.png)

7.  Now the Jenkins server needs to be set up, and by default, the only
    way of setting it up is by first accessing the token generated by
    Jenkins and inputting it when required, before the configuration can
    be completed. The steps below show how we can access the Jenkins
    server through the session manager by assuming the already generated
    IAM role that gives EC2 access permission to the user.

N.B

The next 4 images below show this process.

![A computer screen shot of a computer screen AI-generated content may
be incorrect.](images/image10.png)![A
screenshot of a computer AI-generated content may be
incorrect.](images/image11.png)![A
computer screen shot of a black screen AI-generated content may be
incorrect.](images/image12.png)![](images/image13.png)![A screenshot of a computer AI-generated content may
be incorrect.](images/image14.png)

![](images/image15.png)

8.  Now, a master user is being created and automatically logged in to
    the Jenkins server, and at this step, server configurations for
    setting up the CI/CD pipelines begin

![Screenshot](images/image16.png)![A
screenshot of a computer AI-generated content may be
incorrect.](images/image17.png)

9.  A Jenkins token was created to hook(connect) both our application
    repository and infrastructure repository to our Jenkins server. ![A
    screenshot of a computer AI-generated content may be
    incorrect.](images/image18.png)

10. Then, a GitHub webhook is created linking the infrastructure
    repository to the Jenkins server. Now, provisioning of the cloud
    infrastructure environment can begin using a pipeline script. ![A
    screenshot of a computer AI-generated content may be
    incorrect.](images/image19.png)

![Screenshot](images/image20.png)

11. A successful green tick showing that the connection has now been
    established. ![A screenshot of a computer AI-generated content may
    be incorrect.](images/image21.png)

12. The image below shows the necessary credentials used while
    implementing cloud infrastructure provisioning after all the
    required plugins have been successfully installed on the Jenkins
    server.

![Screenshot](images/image22.png)

13. Creation of the cloud infrastructure pipeline by selecting the
    GitHub hook trigger option![Screenshot](images/image23.png)

14. Then, the link to the repository for the infrastructure was copied
    and filled in the specified field URLs.

![Screenshot](images/image24.png)![A
screenshot of a computer AI-generated content may be
incorrect.](images/image25.png)

15. Also, the file path to the Jenkins pipeline script, which defines
    the stages and actions that should be taken by Jenkins while
    provisioning our cloud infrastructure environment for the
    pet-adoption application. Then we start the pipeline by making a
    simple commit to the infrastructure repository.

![Screenshot](images/image26.png)![A
screenshot of a computer program AI-generated content may be
incorrect.](images/image27.png)

16. A brief stage view of the infrastructure pipeline showing that the
    script was executed successfully. These implications mean that our
    cloud environment has been created, and the application can now be
    deployed to that environment.

![Screenshot](images/image28.png)

**STAGE 2: APPLICATION PROVISIONING**

At this stage, the cloud infrastructure environment has been created,
and I have progressed to deploying the application within it.

First, the SonarQube server was configured for our application, which
ensures that the pet-adoption application code passes all quality
checks. We can then review the results of those checks on the server.

Second, the Nexus server was configured. This server acts as a warehouse
for the production build of the pet-adoption application. In this server
or artifact storage repository, a custom port 8085 was opened so that
Ansible and the servers running the pet-adoption application can access
(pull) the latest Docker image of the application.

Third, configure the Jenkins server with credentials to effectively run
the pet adoption application pipeline. Then the pipeline is initialized
and the application is deployed to both the stage and production
environments.

Finally, we monitor our servers and Docker containers externally by
using the New Relic monitoring tool that has been configured on all
servers.

17. Logging into the SonarQube application to set up the environment![A
    screenshot of a computer AI-generated content may be
    incorrect.](images/image29.png)![A screenshot of a computer
    AI-generated content may be
    incorrect.](images/image30.png)

18. Generating a token that will be stored on the Jenkins application so
    that Jenkins can securely communicate with the SonarQube
    application. Then, a webhook was created for this same purpose. This
    process can be seen in the next four images![A screenshot of a
    computer AI-generated content may be
    incorrect.](images/image31.png)![A screenshot of a computer
    AI-generated content may be
    incorrect.](images/image32.png)

![Screenshot](images/image33.png)![A
screenshot of a computer AI-generated content may be
incorrect.](images/image34.png)

19. To make use of the Nexus application, we first have to go through
    the command line interface on the Nexus server and retrieve the
    token used to access this server before a Master admin credential
    can be created. This process is shown in the next 3 images

![Screenshot](images/image35.png)![A
screenshot of a computer AI-generated content may be
incorrect.](images/image36.png)![](images/image37.png)

20. Now I have created two repositories, the first is the Maven-hosted
    repository since the pet-adoption application was built using Maven
    as its framework. Second is the Docker repository used to store
    Docker images after the application artifact has been built into a
    Docker image. The next 6 images highlight this process.

![Screenshot](images/image38.png)![](images/image39.png)![A screenshot of a computer AI-generated content may
be incorrect.](images/image40.png)![](images/image41.png)![A screenshot of a computer AI-generated content may
be incorrect.](images/image42.png)![A
screenshot of a computer AI-generated content may be
incorrect.](images/image43.png)

21. A picture of all the credentials configured to deploy the
    pet-adoption application pipeline![A screenshot of a computer
    AI-generated content may be
    incorrect.](images/image44.png)

22. Configuring Jenkins to use SonarQube to scan the pet-adoption
    application code![A screenshot of a computer AI-generated content
    may be incorrect.](images/image45.png)

23. Configuring Slack notification alert system on the Jenkins server to
    notify the team through the Slack channel when the application has
    been deployed. ![A screenshot of a computer AI-generated content may
    be incorrect.](images/image46.png)

24. Now, we create the application pipeline, like the process done while
    provisioning the infrastructure pipeline. ![A screenshot of a
    computer AI-generated content may be
    incorrect.](images/image47.png)

25. Fetching the link to the pet-adoption application repository to
    begin the deployment process of the application to the newly created
    cloud infrastructure environment. ![A screenshot of a computer
    AI-generated content may be
    incorrect.](images/image48.png)

26. Application deployed successfully. The image below shows the
    application pipeline stage view, highlighting each process in the
    deployment of the pet-adoption application. ![A screenshot of a
    computer AI-generated content may be
    incorrect.](images/image49.png)

27. A brief look at both CI/CD pipelines provisioned and regulated by
    Jenkins. ![Screenshot](images/image50.png)

**STAGE 3: OBSERVING AND MONITORING**

28. A preview of the SonarQube scan results that will be reported back
    to the application developers for resolution.

![Screenshot](images/image51.png)

29. The next 2 images show the stored artifacts and Docker images on the
    Nexus server.

![Screenshot](images/image52.png)

![Screenshot](images/image53.png)

30. The next two images show the pet-adoption application deployed to
    both the stage and production environments.

![Screenshot](images/image54.png)

![Screenshot](images/image55.png)

31. The image below shows the Slack notification bot notifying the
    team\'s channel on Slack media that the application has been
    successfully deployed.

![](images/image56.png)

32. The next 3 images show the external monitoring tool implemented to
    successfully monitor all the servers deployed in this project, the
    application health, and finally the containers running on those
    servers. ![Screenshot](images/image57.png)

![](images/image58.png)![](images/image59.png)
