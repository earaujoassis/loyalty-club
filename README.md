# Loyalty Club

> A retailer’s customer loyalty program application

## Setup and running

**Requirements**

  * Ruby 1.9+
  * Bower (Node.js + NPM)
  * Postgres 9.1


  ```sh
  $ apt-get install postgresql-server-dev-all postgresql-contrib-9.1
  ```

Make sure to create a proper user with password for the PostgreSQL installation under Debian-based systems.
Then you should be able to create a `.env` file (see `.sample.env` for instructions).

  ```sh
  $ bundle install
  $ createdb loyalty_club_development
  $ rake db:migrate db:seed
  $ thin start
  ```

## Acknowledgment

This stack is based upon [Alex MacCaw](https://twitter.com/maccaw)'s "[Structuring Sinatra Applications](http://blog.sourcing.io/structuring-sinatra)"
and his [Monocle](https://github.com/maccman/monocle) application.

## License

There is an Application written in this project as a response for a technical exercise. The Application,
named "Loyalty Club", is not intented to be used commercially nor to be used as part of any further
application.

[MIT License](http://ewerton-araujo.mit-license.org/) &copy; Ewerton Assis
