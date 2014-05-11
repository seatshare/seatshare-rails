# SeatShare

## Objective

This project is a mock SaaS to allow a group of people to manage a pool of tickets to events. The most common use case is to share season tickets to a sports team.

## Instalation

NOTE: The application currently uses a local SQLite database while in development. The eventual target is Postgres.

1. Clone the repository into your projects directory.
2. Ensure you have [Bundler](http://bundler.io/) installed.
3. Execute `bundle install`.
4. Execute `rake db:migrate` (creates the `development.sqlite` database) and `rake db:seed` (loads the default fixtures).
4. Run `rake test` to verify that existing tests pass.
5. Execute `rails server` to bring up a local instance.

### Recommended Tools

There are a handful of tools that will make using the application easier.

* [MailCatcher](http://mailcatcher.me/) - Intercepts email sent through the tool to any address so it can be inspected/read.  Install this gem and have the `mailcatcher` binary running while developing. The `development.rb` file defines the port for this already.

## Getting started with the application

When you first launch the application (`http://localhost:3000/`), you will be presented with the marketing site. Click `Create Account` in the upper right and follow the instructions. If you are using MailCatcher, you can retrieve any emailed details via `http://localhost:1080`.

Once you have installed the application, the next step is to create a group. You will be prompted to select a registered entity and provide a group name. You will be taken to your group page.

NOTE: Intially, none of the `entities` will have `events`. This is a `@TODO` task to have default set of events to use for development that can be seeded. In the interim, connect to the `test.sqlite3` database and export the contents of the `events` table and import it into `development.sqlite3` for testing purposes.

## Database Migrations

Migrations are found in `db/migrate/` and can be processed using the standard `rake db:migrate` command. Use the `rails generate migration AddColumnToSomeTable` to generate a new migration. [See the Rails documentation](http://guides.rubyonrails.org/migrations.html) for more details.

## Rake Tasks

* `rake send_reminders:daily` - Sends reminders to subscribed users for today.
* `rake send_reminders:weekly` - Sends reminders to subscribed users for current week (Monday - Sunday)

## Contributing

See [CONTRIBUTING.md](https://github.com/stephenyeargin/seatshare-rails/blob/master/CONTRIBUTING.md) in the repository for more information.

## Deploying

* `@TODO`