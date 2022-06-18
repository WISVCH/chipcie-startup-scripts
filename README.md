# CHipCie Startup scripts

This repository contains docker compose files, shell scripts, and example environments to start systems used during the programming contests.

## DOMjudge

### env file

To run DOMjudge, first setup the the env file.

Rename the env file to remove the `.example` extension:
```bash
cp domserver.env.example domserver.env
```

Open `domserver.env` and update the `MYSQL_PASSWORD` to a strong password.

### Printer

If you you want to use the printer, get a printer url.
This can be done via [linuxprint.tudelft.nl](https://linuxprint.tudelft.nl)
Login using the CH account, Go to **Driver Print** > **Linux**.
Select **Advanced**, click **Continue** and select **Follow Me Employee** > **Follow Me**.
Scroll down to the url that looks similar to `ipps://linuxprint.tudelft.nl:443/ipp/r/abc/def`.
Copy this and update `PRINTER_URL`

### Start

To start the compose file, run:

```bash
docker compose -f docker-compose-domserver.yml up -d
```

### Use

DOMjudge is now running on port 8080.
The default password for the `admin` user is in the logs.
These can be accessed using:
```bash
docker compose -f docker-compose-domserver.yml logs
```
Add the `-f` flag to follow the logs live.

The database can also be accessed through phpMyAdmin on port 8081.

## Judgehost

To run a Judgehost, use the `start-judgehost.sh` script.

First update the `start-judgehost.sh` script to set the Judgehost password.
This password can be found in the DOMjudge logs.

Run the script with a number as the argument. The container will be limited to that cpu core, starting from 0. Example:

```bash
start-judgehost.sh 0
```
