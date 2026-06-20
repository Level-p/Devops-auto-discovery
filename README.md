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

For more, download the .docx file on how to proceed
