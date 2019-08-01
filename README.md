[![Build Status](https://travis-ci.org/sul-dlss/systems-dashboard.svg?branch=master)](https://travis-ci.org/sul-dlss/systems-dashboard) | [![Coverage Status](https://coveralls.io/repos/github/sul-dlss/systems-dashboard/badge.svg?branch=master)](https://coveralls.io/github/sul-dlss/systems-dashboard?branch=master) | [![Dependency Status](https://gemnasium.com/sul-dlss/systems-dashboard.svg)](https://gemnasium.com/sul-dlss/systems-dashboard)

# README

This is used to do reporting about systems in general, and any actionable
problems (open advisories, orphaned server data, etc) that the systems might
have in particular.  It is usually installed on a central server.

It pulls together data sources via YAML, each of which contains data for all
servers under a specific domain (general info, advisories, etc).  Those then
get combined and used in separate views.  Each of the data sources has a
related rake task to be run by cron regularly to keep data fresh.

The server is set to be deployed by Capistrano to development and production
servers.

Tested under Ruby 2.4.

Currently there are no database dependencies, but there might be in the future
to fulfill open product requests.

- whenever is used to create default cron jobs for the data downloads
- jquery-datatables-rails is used for adding table sorts and searches for data
