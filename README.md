# Nextcloud + Only Office with SSL Docker installation

This repo contains everything you need to deploy a self hosted Nextcloud with Only Office and SSL certificate.


## Requirements

* The latest version of Docker (can be downloaded here: [https://docs.docker.com/engine/installation/](https://docs.docker.com/engine/installation/))
* Docker compose (can be downloaded here: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/))
* Registerd domain name (can be purchased from a domain registrar like [this one](https://porkbun.com/))


## Installation

1. Deploy Docker

    This guide is for Ubuntu 22.04. Guides for other platforms can be found from the official docker documentation linked above.
    ```bash
    # Update system 
    sudo apt update && sudo apt upgrade -y

    # Install packages to allow apt to use a repository over HTTPS
    sudo apt-get install ca-certificates curl gnupg

    # Add Docker’s official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Set up the repository
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install docker
    sudo apt update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Allow current user to run docker (optional)
    sudo groupadd docker
    sudo usermod -aG docker $USER
    ```

2. Clone this repository running the command:

    ```
    git clone https://github.com/ONLYOFFICE/docker-onlyoffice-nextcloud
    cd docker-onlyoffice-nextcloud
    ```

3. Create secrets:

    Make a folder called .secrets to store the secrets files
    
    Create 2 text files and put a strong unique password in each
    - db_root_pwd.txt
    - mysql_pwd.txt

    Currently Onlyoffice docs does not support Docker secrets so an env file is used instead

    Create a text file with the following name
    - onlyoffice_jwt_secret.env

    and in the file put the environment variable 

    `JWT_SECRET=<YOUR SECRET>`

    or run this script
    ```bash
    # generate secrets
    mkdir .secrets
    head /dev/random | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c 32 > .secrets/db_root_pwd.txt
    head /dev/random | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c 32 > .secrets/mysql_pwd.txt
    echo JWT_SECRET=$(head /dev/random | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c 32) > .secrets/onlyoffice_jwt_secret.env
    ```

4. Add domain name for Lets Encrypt certificate

    This example uses linuxserver.io swag as a reverse proxy and way to get an SSL certificate from Lets Encrypt

    Open the `docker-compose.yml` file in a text editor like nano or vim

    Change the folling 2 lines under `nginx-server:` `environment:`
    ```
    - TZ=<your/timezone>
    - URL=<your.domain.name>
    ```

    > Note: You can use the Linux command `timedatectl list-timezones` or go to this [wiki page](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to get a list of TZ identifiers.

5. Add domain name to Nginx config

    Use your favorite text editor to open the file `nextcloud.subdomain.conf` located in `nginx-config/nginx/proxy-confs`

    Find and replace the text `nextcloud.example.com` with your domain address.

6. Add domain name to configuration script

    Use your favorite text editor to open the file `set_configuration.sh`

    Find and replace the text `nextcloud.example.com` with your domain address.

7. Run Docker Compose:

    ```
    docker-compose up -d
    ```

    > Note: It might take a few minutes for everything to start

8. Now launch your favorite browser and enter the webserver address. The Nextcloud wizard webpage will be opened. Enter all the necessary data to complete the wizard.

9. Go to the project folder and run the `set_configuration.sh` script:

    ```
    bash set_configuration.sh
    ```

    This will install the Onlyoffice connector app and configure it.

Now you can enter Nextcloud and create a new document. It will be opened in ONLYOFFICE Document Server.

## Project Information

Made with much help from: [https://github.com/ONLYOFFICE/docker-onlyoffice-nextcloud](https://github.com/ONLYOFFICE/docker-onlyoffice-nextcloud "https://github.com/ONLYOFFICE/docker-onlyoffice-nextcloud")
