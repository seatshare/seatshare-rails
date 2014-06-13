# SeatShare

## Objective

This project is a mock SaaS to allow a group of people to manage a pool of tickets to events. The most common use case is to share season tickets to a sports team.

## Instalation

### Pre-requisites

* [Bundler](http://bundler.io/).
* PosgtresSQL (e.g. `brew install postgresql`)
* An Amazon S3 bucket for ticket files
 
### Install Steps

1. Clone the repository into your projects directory
2. Execute `bundle install`
3. Execute `rake db:setup` (creates the development and test database and seeds the initial data)
4. Run `rake test` to verify that existing tests pass
5. Execute `rails server` to bring up a local instance

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

### Recommended Tools

There are a handful of tools that will make using the application easier.

* [MailCatcher](http://mailcatcher.me/) - Intercepts email sent through the tool to any address so it can be inspected/read.  Install this gem and have the `mailcatcher` binary running while developing. The `development.rb` file defines the port for this already.

## Getting started with the application

When you first launch the application (`http://localhost:3000/`), you will be presented with the marketing site. Click `Create Account` in the upper right and follow the instructions. If you are using MailCatcher, you can retrieve any emailed details via `http://localhost:1080`.

Once you have installed the application, the next step is to create a group. You will be prompted to select a registered entity and provide a group name. You will be taken to your group page.

NOTE: Intially, only one of the `entities` will have `events` (the Tennessee Titans). This is a `@TODO` task to have default set of events to use for development that can be seeded.

## Database Migrations

Migrations are found in `db/migrate/` and can be processed using the standard `rake db:migrate` command. Use the `rails generate migration AddColumnToSomeTable` to generate a new migration. [See the Rails documentation](http://guides.rubyonrails.org/migrations.html) for more details.

## Rake Tasks

* `rake send_reminders:daily` - Sends reminders to subscribed users for today.
* `rake send_reminders:weekly` - Sends reminders to subscribed users for current week (Monday - Sunday)

## Contributing

See [CONTRIBUTING.md](https://github.com/stephenyeargin/seatshare-rails/blob/master/CONTRIBUTING.md) in the repository for more information.

## Deploying

* Push master to the `seatshare-app` repository on Heroku.