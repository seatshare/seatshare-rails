# SeatShare [![Circle CI](https://circleci.com/gh/stephenyeargin/seatshare-rails.svg?style=svg&circle-token=b15e16199f58286483c6319a05cb11452131ab70)](https://circleci.com/gh/stephenyeargin/seatshare-rails)

This project allows a group of people to manage a pool of tickets to events. The most common use case is to share season tickets to a sports team.

## Installation

Please see the complete [installation instructions](https://github.com/stephenyeargin/seatshare-rails/wiki/Installation) in the wiki.

## Getting started with the application

When you first launch the application (`http://localhost:3000/`), you will be presented with the marketing site. Click `Create Account` in the upper right and follow the instructions. If you are using MailCatcher, you can retrieve any emailed details via `http://localhost:1080`.

Once you have installed the application, the next step is to create a group. You will be prompted to select a registered entity and provide a group name. You will be taken to your group page.

The group will not have any events yet. You need to use the `/admin` route to log into the backend to create events. The default credentials for the admin section (upon install) are:

* Email: `stephen@seatsha.re`
* Password: `password`

## Using the automated test runner and livereload

This project uses [Guard](https://github.com/guard/guard) to automatically run the test suite as you develop. It also watches views and assets and will trigger livereload in your browser as you develop the app's front-end. All you need to do to use these features is run `guard` from the project root once you have completed the installation instructions linked above.
