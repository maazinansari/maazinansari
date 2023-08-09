---
title: Gnucash with PostgreSQL - 000
author: Maazin Ansari
date: 2023-08-07
slug: gnucash_0
lang: en
category: Gnucash
tags: gnucash, sql, personal-finance
summary: Setting up PostgreSQL and Gnucash
output: html_document
---

This post is the first in a series of tutorials on personal finance with SQL. The goal is to teach technical data analysis techniques in a way that benefits you immediately. The datasets you interact with will be your own financial data, and the analyses you perform can be used for yourself.

# Download and install 

To get started, you will need to download the following software

* [Gnucash](https://www.gnucash.org/download.phtml)
* [PostgreSQL](https://www.postgresql.org/download/)
* pgAdmin (or other SQL query tool)
* [Postgres.app](https://postgresapp.com/) (recommended for macOS)

The installation instructions vary depending on your operating system. The official instructions tend to be easy to follow. There are also video tutorials available on YouTube.

# Set up PostgreSQL

Follow the installation instructions for PostgreSQL and use the default settings. 

Depending on your operating system, you may need to download and install pgAdmin separately. If you are using macOS, I recommend you also install the Postgres.app. This will make it easier to connect to your Gnucash database in the future. 

## Open pgAdmin

You will need to set a password the first time you open pgAdmin. This is not the same as the postgres user password you set when you installed PostgreSQL. You will only use this password when you want to use pgAdmin.

In the Browser panel, you will see one server _Local_ which has one database _postgres_. There is also a _postgres_ role ("user") in the _Local_ server. To avoid confusion in the future, we will create a new role _u_gnucash_ and a new database _db_gnucash_ 

## Create a new role

Select the _postgres_ database and open a new query window. Create a new _u_gnucash_ role with the statement below

```
CREATE ROLE u_gnucash WITH
  LOGIN
  SUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  PASSWORD 'your password';
```

The `PASSWORD` parameter is optional. If you omit it in the statement, you can always set a password at a later time. 

## Create a new database

```
CREATE DATABASE db_gnucash WITH 
    OWNER = u_gnucash
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
```

This database will not have any tables or data yet. We will need to set up Gnucash next.

# Set up Gnucash

Gnucash is an open source bookkeeping application that has a neat graphical user interface, and a simple database underneath. We will be taking advantage of both in later guides. Depending on the problem you are trying to solve, you might find the GUI is the better tool, and other times you might find it easier to look directly in the database.

With Gnucash open click _File > Save As..._. Change the data format from XML to Postgres. Enter the following connection details:

* Host: `localhost`
* Database: `db_gnucash`
* Username: `u_gnucash`
* Password: _The password you created above_

_If you are using macOS, make sure the server is still running in Postrgres.app_

Click Save As. Gnucash will automatically create the necessary tables to get started. 

# Check

To confirm the setup was successful, go back to pgAdmin and refresh db_gnucash. Expand the tree to _Schemas > public > Tables_ and you will see 24 tables.

In the next post we will explore what these tables mean and how they are related to each other. 

