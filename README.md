# SeatShare

## Objective

This project is a mock SaaS to allow a group of people to manage a pool of tickets to events. The most common use case is to share season tickets to a sports team.

## Instalation

### Pre-requisites

* [Bundler](http://bundler.io/) (`gem install bundler`)
* [Bower](http://bower.io/) (`npm install bower -g`)
* [PosgtresSQL](http://www.postgresql.org/) (`brew install postgresql`)
* [Mailcatcher](http://mailcatcher.me) (`gem install mailcatcher`)
* [Heroku Toolbelt](https://toolbelt.heroku.com/) (for deployment to server, reading configs)
* An Amazon S3 bucket for ticket files (see `heroku config` for credentials)
 
### Install Steps

1. Clone the repository into your projects directory
2. Execute `bundle install` (for required gems)
3. Execute `bower install` (for required JS assets)
3. Execute `rake db:setup` (creates the development and test database and seeds the initial data)
4. Run `rake test` to verify that existing tests pass
5. Run `mailcatcher` to bring up the local email transport (registration fails without it)
6. Execute `rails server` to bring up a local instance
7. Register for an account through the normal process

### Environment Variables

The following are used within the application:

* `SEATSHARE_S3_KEY` - S3 credentials to use for storing ticket files.
* `SEATSHARE_S3_SECRET` - S3 credentials to use for storing ticket files.
* `SEATSHARE_S3_BUCKET` - Bucket name to use for storing ticket files.
* `SEATSHARE_S3_PUBLIC` - Public address for S3 downloads.
* `MANDRILL_SMTP_USER` - User identifier for Mandrill (production only)
* `MANDRILL_SMTP_PASS` - API key for Mandrill (production only)
* `MANDRILL_SMTP_HOST` - Hostname to use with Mandrill (production only)
* `GOOGLE_ANALYTICS_ID` - Google Analytics profile identifier (production only)
* `MIXPANEL_API_KEY` - API key for Mixpanel (production only)

The easiest way to do this is to create a file called `config/local_env.yml` (see the example file in that directory). When configuring on Heroku, you will simply add these as configuration settings.

## Getting started with the application

When you first launch the application (`http://localhost:3000/`), you will be presented with the marketing site. Click `Create Account` in the upper right and follow the instructions. If you are using MailCatcher, you can retrieve any emailed details via `http://localhost:1080`.

Once you have installed the application, the next step is to create a group. You will be prompted to select a registered entity and provide a group name. You will be taken to your group page.

The group will not have any events yet. You need to use the `/admin` route to log into the backend to create events. The default credentials for the admin section (upon install) are:

* Email: `admin@example.com`
* Password: `password`

## Database Migrations

Migrations are found in `db/migrate/` and can be processed using the standard `rake db:migrate` command. Use the `rails generate migration AddColumnToSomeTable` to generate a new migration. [See the Rails documentation](http://guides.rubyonrails.org/migrations.html) for more details.

If you completely hose your local database, run `rake db:reset && rake db:seed` to clean it up and start over. You may have to manually add your admin user back through the `rails console`.

## Rake Tasks

These tasks should be scheduled on the deployment to run at the specified intervals. You can also run them locally with MailCatcher to make sure they render properly.

* `rake send_reminders:daily` - Sends reminders to subscribed users for today.
* `rake send_reminders:weekly` - Sends reminders to subscribed users for current week (Monday - Sunday)

## Contributing and Testing

See [CONTRIBUTING.md](https://github.com/stephenyeargin/seatshare-rails/blob/master/CONTRIBUTING.md) in the repository for more information.

## Deploying

* Push master to the `seatshare-app` repository on Heroku. Open an issue to be added as a contributor for push access.
