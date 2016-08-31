# CardistryIO

[![Build Status](https://travis-ci.org/davidpdrsn/CardistryIO.svg?branch=master)](https://travis-ci.org/davidpdrsn/CardistryIO)
[![Code Climate](https://codeclimate.com/github/davidpdrsn/CardistryIO/badges/gpa.svg)](https://codeclimate.com/github/davidpdrsn/CardistryIO)

## What is this?

- CardistryIO is a place on the internet entirely devoted to cardistry. If you like shuffling cards and watching videos of other people shuffling cards, then you've come to the right place.
- CardistryIO is not a producer of instructional content.
- CardistryIO does not hate magic, we just think there are enough great magic communities already.
- CardistryIO is completely open source and built by the community. So whether you're into programming, design, or just have a good idea, we welcome you.

## I wanna contribute, where do I start?

Please read the [Contributing guidelines](https://github.com/davidpdrsn/CardistryIO/blob/master/CONTRIBUTING.md) as the first thing.

CardistryIO is made with Ruby on Rails so if you're unfamiliar with that, and you want to contribute code, we recommend you start [here](https://www.lynda.com/Ruby-Rails-tutorials/Ruby-Rails-4-Essential-Training/139989-2.html).

Issues labeled with ["Low hanging fruit"](https://github.com/davidpdrsn/CardistryIO/labels/Low%20hanging%20fruit) are a good starting point for new contributors.

If you want to report a bug, or suggest a new feature, you're welcome to [open a new issue](https://github.com/davidpdrsn/CardistryIO/issues/new).

If you want to contact one from the core team you can find them [here](https://github.com/davidpdrsn/CardistryIO/wiki/Core-Team).

## Development

### Getting Started

We use Docker to run the application locally in development so if you're totally unfamiliar with Docker we recommend you start [here](https://www.youtube.com/watch?v=Q5POuMHxW-0).

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    $ script/bootstrap

It requires that you have the [docker toolbox](https://www.docker.com/products/docker-toolbox) installed.

Remember to read the instructions shown when the script finishes.

After setting up, you can run the application using:

    $ script/server

### Helper scripts

- `script/console`: Open a rails console.
- `script/build`: Build the docker container.
- `script/migrate`: Migrate the database.
- `script/server`: Start a local web server.
- `script/test`: Run the tests.

### Creating test notifications

In test and development environments you can create test notifications from the console like so:

Find your user id. You find that by visiting your profile in the browser and looking at the URL. If you profile is at `localhost:3000/users/1337-bob-robertsen` then your id is `1337`. Then run:

    $ script/console
    => me = User.find(1337)
    => TestNotifications.new(me).comment_on_video

That would create you a notification that someone commented on a video. The video might not be one of yours, but should still work.

Note that for all the notifications to work there has to be at least two users in the database. You can just create a second one through the browser. Some notifications also require a move, a video, or a comment to be present.

You can call the following methods on `TestNotifications`:

- `comment_on_video`
- `comment_on_move`
- `video_approved`
- `new_follower`
- `video_shared`
- `mentioned_in_video`
- `mentioned_in_move`
- `mentioned_in_comment`
- `new_credit`

### Creating test activities

You can also create test activities for testing the feed.

The process is similar to creating test notifications:

    $ script/console
    => me = User.find(your_id)
    => TestActivities.new(me).video
    => TestActivities.new(me).move

Setting the date the activity was created can be done like so:

    $ bin/rails console
    => me = User.find(your_id)
    => activity = TestActivities.new(me).video
    => activity.update!(created_at: 1.day.ago)
    => activity.update!(created_at: 1.week.ago)
    => activity.update!(created_at: 1.month.ago) # etc...

## Setting an account as admin

In order to flag an account as admin, you have to set the `admin` column of the user account to `true`. Do it like so:

    $ script/console
    => User.find(your_user_id).update!(admin: true)

## Misc

### Expense report

We have a simple expense report written in Ruby (because who needs spreadsheets)

    $ ruby expense_report.rb

### Services we depend on

- [Rollbar](https://rollbar.com/CardistryIO/CardistryIO/): Errors
- [Skylight](https://www.skylight.io/app/applications/dKldsKzvUVNv/recent/5m/endpoints): Metrics
