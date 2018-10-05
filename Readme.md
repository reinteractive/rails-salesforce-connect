# Rails Salesforce Connect

This gem eases heroku-connect based integrations with salesforce for rails projects.

It provides:

 * A rails generator for commonly used salesforce models (`rails g connect:models`)
 * An API client constructor for RestForce (`Connect::ApiAdapter`)
 * A concern, `Connect::Record`, to include in salesforce-connected activerecord models (`require 'connect/record'`)
 * A concern, `Connect::Migration`, for migrations which should only run in development (eg because heroku connect is managing the schema in production).
 * A rake task `db:diff_schema` for describing the difference between your mapped fields in heroku and your local database.
 * A rake task `salesforce:schema:dump[heroku-app-name]` to serialize your salesforce configuration to JSON
 * A rake task `salesforce:schema:diff[old_file,new_file]` to compare two serialized salesforce configurations

## Usage

Add to your gemfile:

### Classes

To use `Connect::ApiAdapter`, you must provide the following environment variables:

 * SALESFORCE_REST_API_HOST
 * SALESFORCE_REST_API_CLIENT_ID
 * SALESFORCE_REST_API_CLIENT_SECRET
 * SALESFORCE_REST_API_USERNAME
 * SALESFORCE_REST_API_PASSWORD
 * SALESFORCE_REST_API_SECURITY_TOKEN

### Rake tasks

`gem "rails-salesforce-connect"`

To use `salesforce-connect db:diff_schema` you must specify a connection string or HC_URL env var.
For instance:

`export HC_URL="$(heroku config:get DATABASE_URL)"`

To use `salesforce-connect salesforce:schema:dump`, you must provide one of:

 * Environment variables for `Connect::ApiAdapter`, or
 * A heroku app name, which the current machine is authorized to read environment variabes from, with those variables set.

## Status

Alpha. This has been extracted from common code across couple of projects.