# Loyalty Club

> A retailer's customer loyalty program application

This project was developed as a technical test and a proof of concept for a selection process (May 2014).
**It is not maintained anymore**.

![Screenshot](http://earaujoassis.github.io/loyalty-club/screenshot.png)

## Requirements

 * Ruby 1.9+
 * Bower (Node.js + NPM)
 * Postgres 9.1

## Setup and running

Make sure to create a proper user with password for the PostgreSQL installation under Debian-based systems
(you must also apt-get the package `postgresql-contrib-9.x` for your installation). Then you should be
able to create a `.env` file (see `.sample.env` for instructions).

  ```sh
  $ bundle install
  $ bundle exec rake db:create db:migrate db:seed
  $ bundle exec thin start
  ```

## Development

  ```sh
  $ cd public && compass watch
  ```

## Testing

  ```sh
  $ bundle exec rake db:create PROJECT_ENV=test
  $ bundle exec rspec
  ```

## Acknowledgment

This stack is based upon [Alex MacCaw](https://twitter.com/maccaw)'s
"[Structuring Sinatra Applications](http://blog.sourcing.io/structuring-sinatra)" and his
[Monocle](https://github.com/maccman/monocle) application.

## License

There is an Application written in this project as a response for a technical exercise. The Application,
named "Loyalty Club", is not intented to be used commercially nor to be used as part of any further
application.

Code under the [MIT License](http://earaujoassis.mit-license.org/) &copy; Ewerton Assis
