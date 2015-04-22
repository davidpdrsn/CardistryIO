# CardistryIO

[![Build Status](https://travis-ci.org/davidpdrsn/CardistryIO.svg)](https://travis-ci.org/davidpdrsn/CardistryIO)
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

### MVP

- [ ] Link to the videos a move appears in
- [ ] Edit moves
- [ ] Edit videos
- [ ] Comments on moves
- [ ] Comments on performance videos
- [ ] Some sort of design

- [x] Delete videos
- [x] Delete moves
- [x] Approving of videos
- [x] Uniqueness validation of move names
- [x] Uniqueness validation of video names
- [x] Move appearances
- [x] Description of moves
- [x] Videos of moves (embedding from YouTube)
- [x] Google analytics

### Later

- [ ] Specifying that a move appears in a video
- [ ] Rate videos
- [ ] Rate moves
- [ ] Ideas
