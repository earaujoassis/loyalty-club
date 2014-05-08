# Loyalty Club

> A retailer’s customer loyalty program application

# Setup and running

    ```sh
    $ apt-get install postgresql-server-dev-all postgresql-contrib-9.1
    ```

Make sure to create a proper user with password for the PostgreSQL installation under Debian-based systems.

    ```sh
    $ bundle install
    $ createdb loyalty_club_development
    $ rake db:migrate
    $ thin start
    ```

## License

There is an Application written in this project as a response for a technical exercise. The Application,
named "Loyalty Club", is not intented to be used commercially nor to be used as part of any further
application.

[MIT License](http://ewerton-araujo.mit-license.org/) &copy; Ewerton Assis
