# CHipCie Startup scripts

This repository contains docker compose files, shell scripts, and example environments to start systems used during the programming contests.

## domserver

- Rename the env file to remove the `.example` extension:
```bash
cp domserver.env.example domserver.env
```
- Open `domserver.env` and update the `MYSQL_PASSWORD` to a strong password.
- Optionally, Add a printer:
  - Get a printer URL via [linuxprint.tudelft.nl](https://linuxprint.tudelft.nl)
    - Login using the CH account, Go to **Driver Print** > **Linux**.
    - Select **Advanced**, click **Continue** and select **Follow Me Employee** > **Follow Me**.
    - Scroll down to the url that looks similar to `ipps://linuxprint.tudelft.nl:443/ipp/r/abc/def`.
  - Copy this and update `PRINTER_URL`
- Start domserver
```bash
docker compose up -d
```

DOMjudge is now running on port 8080.
The default password for the `admin` user is in the logs.
These can be accessed using:
```bash
docker compose logs
```
Add the `-f` flag to follow the logs live.

The database can also be accessed through phpMyAdmin on port 8081.

## judgehost

To run a Judgehost, use the `start-judgehost.sh` script.

- Run the script with a number as the argument. The container will be limited to that cpu core, starting from 0. Example:
```bash
./start-judgehost.sh 0
```
- See the help:
  ```
  Start a judgehost container on a certain core
  Usage: ./start-judgehost.sh [-h|--help] [-u|--domserver-baseurl <arg>] [-p|--password <arg>] [-c|--container <arg>] [-v|--version <arg>] <cpu-core>
  	<cpu-core>: Which cpu core to run the judgehost container on
  	-h, --help: Prints help
  	-u, --domserver-baseurl: Baseurl of the DOMserver (default: 'https://dj.chipcie.ch.tudelft.nl/')
  	-p, --password: Password of the judgehosts in the domserver (leave empty for prompt) (no default)
  	-c, --container: Docker container to use as judgehost (default: 'ghcr.io/wisvch/domjudge-packaging/judgehost')
  	-v, --version: Version of the container (default: '8.2.1')
  ```

You can run multiple judgehosts on one machine if desired.
Make sure to leave enough resources for the machine itself.

### judgehost on ubuntu

Use `start-judgehosts-gui.sh` to start multiple judgehosts on ubuntu.
It will ask for the necessary information in a GUI and lock each judgehost to a different core.

### judgehost in the google cloud

To run the judgehosts in the cloud, start them using the following command:
```bash
gcloud compute instances create judgehost-1 --project=chipcie --zone=europe-west4-a --machine-type=e2-medium --metadata=judgehost_password=CHANGEME,startup-script=wget\ https://raw.github.com/WISVCH/chipcie-startup-scripts/main/start-judgehost-gcp.sh\ -v\ -O\ start-judgehost-gcp.sh\ \&\&\ chmod\ \+x\ start-judgehost-gcp.sh\ \&\&\ ./start-judgehost-gcp.sh\;\ rm\ -rf\ start-judgehost-gcp.sh --create-disk=auto-delete=yes,boot=yes,image=projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20220712,size=10
```

You should change the `CHANGEME` to the judgehost password.
This will use the `start-judgehost-gcp.sh` script to start a judgehost on a VM.
It will install all the dependencies, and then reboot and start the judgehost.
This takes a few minutes.

Start multiple at the same time using:
```bash
gcloud compute instances create judgehost-1 judgehost-2 judgehost-3 judgehost-4 --project=chipcie --zone=europe-west4-a --machine-type=e2-medium --metadata=judgehost_password=CHANGEME,startup-script=wget\ https://raw.github.com/WISVCH/chipcie-startup-scripts/main/start-judgehost-gcp.sh\ -v\ -O\ start-judgehost-gcp.sh\ \&\&\ chmod\ \+x\ start-judgehost-gcp.sh\ \&\&\ ./start-judgehost-gcp.sh\;\ rm\ -rf\ start-judgehost-gcp.sh --create-disk=auto-delete=yes,boot=yes,image=projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20220712,size=10
```

## ICPC tools CDS

- Rename the cds directory to remove the `.example` extension:
```bash
cp -r cds.example cds
```
- Create a user in DOMjudge with the role `API reader` and `Source code reader`.
- Update these credentials in `cds/config/cdsConfig.xml`
- Optionally, add another contest in this file for the test session.
- **Update the credentials in `cds/config/accounts.yaml`**
- Start the CDS using:
```bash
docker compose up -d
```

- Photos or promo material can be added in the `cds/config/present/photos` and `cds/config/present/promo` directories.
- Affiliantion logos can be put in the `cds/contest*/organizations` directories, which you can automatically do with the `download_affiliations_with_background.sh` script in `cds`.
- A logo and a banner can be put in `cds/contest*/contest/logo.png` and  `cds/contest*/contest/banner.png`.

## Port bindings

The folowing ports are used by the containers:

| Service | Port |
|---|---|
| domserver  | 8080 |
| mariadb | 13306 |
| phpmyadmin | 8081 |
| domserver spectator | 8082 |
| mariadb spectator | 13307 |
| phpmyadmin spectator | 8083 |
| csd http | 8084 |
| csd https | 8443 |
| icinga http | 8085 |
