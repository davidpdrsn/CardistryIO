# CardistryIO

[![Build Status](https://codeship.com/projects/1bbf7200-da14-0132-6fa6-0e3b213d5a03/status?branch=master)](https://codeship.com/projects/1bbf7200-da14-0132-6fa6-0e3b213d5a03/status?branch=master)
[![Code Climate](https://codeclimate.com/github/davidpdrsn/CardistryIO/badges/gpa.svg)](https://codeclimate.com/github/davidpdrsn/CardistryIO)

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    ./script/bootstrap

It requires that you have the [docker toolbox](https://www.docker.com/products/docker-toolbox) installed.

After setting up, you can run the application using [foreman]:

    script/server

## Services

- [Airbrake](https://cardistryio.airbrake.io/projects/124012/activity): Errors
- [Skylight](https://www.skylight.io/app/applications/dKldsKzvUVNv/recent/5m/endpoints): Metrics
