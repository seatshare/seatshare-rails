# SeatShare

## Objective

This project is a mock SaaS to allow a group of people to manage a pool of tickets to events. The most common use case is to share season tickets to a sports team.

## Installation

Please see the complete [installation instructions](https://github.com/stephenyeargin/seatshare-rails/wiki/Installation) in the wiki.

## Getting started with the application

When you first launch the application (`http://localhost:3000/`), you will be presented with the marketing site. Click `Create Account` in the upper right and follow the instructions. If you are using MailCatcher, you can retrieve any emailed details via `http://localhost:1080`.

Once you have installed the application, the next step is to create a group. You will be prompted to select a registered entity and provide a group name. You will be taken to your group page.

The group will not have any events yet. You need to use the `/admin` route to log into the backend to create events. The default credentials for the admin section (upon install) are:

* Email: `admin@example.com`
* Password: `password`

## Importing events from SODA

When using the `development` environment (set in `SODA_ENVIRONMENT`), you will only have access to a few date ranges for data in the "trial database". These are the two ranges that are acceptable:

### NHL, NBA, NFL

* Start Date: `2010-01-01 00:00:00 -0500`
* End Date: `2011-01-01 00:00:00 -0500`

### MLB

* Start Date: `2005-01-01 00:00:00 -0500`
* End Date: `2006-01-01 00:00:00 -0500`

## Database Migrations

Please see the [migration instructions](https://github.com/stephenyeargin/seatshare-rails/wiki/Database-Migrations) in the wiki.


## Rake Tasks

These tasks should be scheduled on the deployment to run at the specified intervals. You can also run them locally with MailCatcher to make sure they render properly.

* `rake send_reminders:daily` - Sends reminders to subscribed users for today.
* `rake send_reminders:weekly` - Sends reminders to subscribed users for current week (Monday - Sunday)

## Contributing and Testing

See [CONTRIBUTING.md](https://github.com/stephenyeargin/seatshare-rails/blob/master/CONTRIBUTING.md) in the repository for more information.

## Deploying

* Push master to the `seatshare-app` repository on Heroku. Open an issue to be added as a contributor for push access.
