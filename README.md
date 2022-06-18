# CHipCie Startup scripts

This repository contains docker compose files, shell scripts, and example environments to start systems used during the programming contests.

## domserver

- Rename the env file to remove the `.example` extension:
```bash
cp domserver.env.example domserver.env
```
- Open `domserver.env` and update the `MYSQL_PASSWORD` to a strong password.
- Optionally, Add a printer:
  - Get a printer url via [linuxprint.tudelft.nl](https://linuxprint.tudelft.nl)
    - Login using the CH account, Go to **Driver Print** > **Linux**.
    - Select **Advanced**, click **Continue** and select **Follow Me Employee** > **Follow Me**.
    - Scroll down to the url that looks similar to `ipps://linuxprint.tudelft.nl:443/ipp/r/abc/def`.
  - Copy this and update `PRINTER_URL`
- Start domserver
```bash
docker compose -f docker-compose-domserver.yml up -d
```

DOMjudge is now running on port 8080.
The default password for the `admin` user is in the logs.
These can be accessed using:
```bash
docker compose -f docker-compose-domserver.yml logs
```
Add the `-f` flag to follow the logs live.

The database can also be accessed through phpMyAdmin on port 8081.

## judgehost

To run a Judgehost, use the `start-judgehost.sh` script.

- Update the `start-judgehost.sh` script to set the Judgehost password. This password can be found in the DOMjudge logs.
- Run the script with a number as the argument. The container will be limited to that cpu core, starting from 0. Example:
```bash
./start-judgehost.sh 0
```

You can run multiple judgehosts on one machine, if desired.
Make sure to leave enough resources for the machine itself.

### ICPC tools CDS

- Rename the cds directory to remove the `.example` extension:
```bash
cp cds.example cds
```
- Create an user in DOMjudge with the role `API reader` and `Source code reader`.
- Update these credentials in `cds/config/cdsConfig.xml`
- Optionally, add another contest in this file for the test session.
- **Update the credentials in `cds/confg/accounts.yaml`**
- Start the CDS using:
```bash
docker compose -f docker-compose-cds.yml up -d
```

Photos or promo material can be added in the `cds/config/present/photos` and `cds/config/present/promo` directories.
