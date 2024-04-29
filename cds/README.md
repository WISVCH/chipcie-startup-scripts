# Contest Data Server

This directory contains the files to start the Contest Data Server. The CDS needs DOMjudge to run and have the contests imported, as it reads the contests from the API.

## Getting started

Let's go over how to set up the CDS

1. In DOMjudge, create a CDS user with `API reader` and `Source code reader` roles
2. Remove the existing `cds` folder if it exists. It contains a lot of data from the previous contest that is not needed anymore
3. Copy `cds.example` to `cds` to have a fresh start
4. In `cds/config`, edit the `cdsConfig.xml` file to contain the correct contests, with the respective DOMjudge API endpoints and credentials
5. Run `generate_passwords.sh`. This script will change the passwords in `cds/config/accounts.yaml` to random passwords
6. Run `download_affiliations_with_background.sh`. This script will download the university and company logo's and put them in `cds/contest_*/organizations`
7. You're ready to start the CDS with `docker compose up -d`

## Additional configuration

Some additional configuration is possible depending on the circumstances:

- A contest logo and banner can be added by creating `logo.png` and `banner.png` in `cds/contest_{CONTEST}/contest`
- Team pictures can be added by creating `photo.jpg|png|...` in `cds/contest_{CONTEST}/teams/{TEAMID}`
- Photos or promo material can be added in the `cds/config/present/photos` and `cds/config/present/promo` directories