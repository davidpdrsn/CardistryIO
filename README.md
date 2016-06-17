# CardistryIO

[![Build Status](https://travis-ci.org/davidpdrsn/CardistryIO.svg?branch=master)](https://travis-ci.org/davidpdrsn/CardistryIO)
[![Code Climate](https://codeclimate.com/github/davidpdrsn/CardistryIO/badges/gpa.svg)](https://codeclimate.com/github/davidpdrsn/CardistryIO)

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    $ ./script/bootstrap

It requires that you have the [docker toolbox](https://www.docker.com/products/docker-toolbox) installed.

After setting up, you can run the application using [foreman]:

    $ script/server

## Services

- Digital Ocean: Hosting
- [Rollbar](https://rollbar.com/CardistryIO/CardistryIO/): Errors
- [Skylight](https://www.skylight.io/app/applications/dKldsKzvUVNv/recent/5m/endpoints): Metrics

## Expense report

We have a simple expense report written in Ruby (because who needs spreadsheets)

    $ ruby expense_report.rb

## Creating test notifications

In test and development environments you can create test notifications from the console like so:

Find your user id. You find that by visiting your profile in the browser and looking at the URL. If you profile is at `localhost:3000/users/1337-bob-robertsen` then your id is `1337`. Then run:

    $ bin/rails console
    => me = User.find(1337)
    => TestNotifications.new(me).comment_on_video

That would create you a notification that someone commented on a video. The video might not be one of yours, but should still work.

Note that for all the notifications to work there has to be at least two users in the database. You can just create a second one through the browser. Some notifications also require a move and a video to be present.

You can call the following methods on `TestNotifications`:

- `comment_on_video`
- `comment_on_move`
- `video_approved`
- `new_follower`
- `video_shared`
- `mentioned`
- `new_credit`

## Creating test activities

You can also create test activities for testing the feed.

The process is similar to creating test notifications:

    $ bin/rails console
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
