# Rails Salesforce Connect

This gem eases heroku-connect based integrations with salesforce for rails projects.

It provides:

 * A rails generator for commonly used salesforce models
 * A concern, `Connect::Record`, to include in salesforce-connected activerecord models
 * A concern, `Connect::Migration`, for migrations which should only run in development (eg because heroku connect is managing the schema in production).
 * A rake task `db:diff_schema` for describing the difference between your mapped fields in heroku and your local database.

## Usage

Add to your gemfile:

`gem "rails-salesforce-connect"`


## Status

Alpha. This has been extracted from common code across couple of projects.