# Carrier Integration Template

We produce various carrier integration gems. This is a template for a JSON API based implementation for quick setup.

## Examples of previous integrations

1. [DHL Express](https://github.com/BloomAndWild/dhl_express)
1. [Sendcloud](https://github.com/BloomAndWild/sendcloud)

# Usage

1. Click on `Use this template` on Github
1. Run `bin/setup` locally
1. Enter the request details

# What this template contains

## Requests using Faraday

There is a base operation class setup dealing with the connection to the endpoint using Faraday. This allows for easy addition of new actions with child classes built off of this.

## Auth

This is setup to use Basic Auth using a `username` and `password`.

## Error Handling

An `Error` module exists with a simple `ResponseError` setup for easy extension.

## Tests

Specs are setup to use `VCR` and `Webmock`, there are a few basic tests already setup to allow easy addition of further specs.

## Rubocop

Rubocop is used for for static code analysis with the config available within `.ruby-style.yml`


