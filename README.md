# CardistryIO

[![Build Status](https://codeship.com/projects/1bbf7200-da14-0132-6fa6-0e3b213d5a03/status?branch=master)](https://codeship.com/projects/1bbf7200-da14-0132-6fa6-0e3b213d5a03/status?branch=master)
[![Code Climate](https://codeclimate.com/github/davidpdrsn/CardistryIO/badges/gpa.svg)](https://codeclimate.com/github/davidpdrsn/CardistryIO)

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [foreman]:

    foreman start

If you don't have `foreman`, see [Foreman's install instructions][foreman]. It
is [purposefully excluded from the project's `Gemfile`][exclude].

[foreman]: https://github.com/ddollar/foreman
[exclude]: https://github.com/ddollar/foreman/pull/437#issuecomment-41110407

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

- [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
- [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
- [Style](http://github.com/thoughtbot/guides/blob/master/style)

## TODOS

### Most important

- [ ] Add types to videos: Performance, tutorial, move showcase, idea
- [ ] Convert rest of the forms to use simple form
- [ ] Fail gracefully for unsupported video host
- [ ] Notifications when someone comments on one of your videos
- [ ] Notifications when someone shares a video with you
- [ ] Notifications when your video is approved
- [ ] Rate moves
- [ ] Rate videos
- [ ] Refactor policies to be composed of sub policies, makes things more modular and reduces duplication
- [ ] Update email, username, password
- [ ] Show link to users instagram profile on `users#show`, if they have an instagram username configured

- [x] Approving of videos
- [x] Comments on moves
- [x] Comments on videos
- [x] Convert all views to haml
- [x] Delete moves
- [x] Delete videos
- [x] Description of moves
- [x] Don't show instagram videos that are already on the site
- [x] Edit moves
- [x] Edit videos
- [x] Google analytics
- [x] Instagram integration
- [x] Link to the videos a move appears in
- [x] Make footer
- [x] Move appearances
- [x] Private videos
- [x] Share private videos with other users
- [x] Uniqueness validation of move names
- [x] Uniqueness validation of video names
- [x] Videos of moves (embedding from YouTube)
- [x] Write tests for all model associations
- [x] user#update sad path seems to be missing

### Later

- [ ] Specifying that a move appears in a video
- [ ] Ideas
- [ ] @mention people in comments/descriptions (might require adding usernames)
