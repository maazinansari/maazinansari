---
title: Accounts - Gnucash with PostgreSQL
author: Maazin Ansari
date: 2023-08-09
slug: gnucash_001
lang: en
category: Gnucash
tags: gnucash, sql, personal-finance
summary: Explaining accounts in Gnucash
output: html_document
---

The first step to managing your personal finances is to have a practical _chart of accounts_. Think of all the financial institutions you interact with: banks, credit cards, your employer, utility companies, insurance providers. Each of them is an account with a balance that increases or decreases over time.   

# Create an account

From the accounts tab in Gnucash, right click and select _New Account..._. This first one will be your main bank account, an asset account. 

# Types of accounts

To summarize the [Gnucash Concepts Guide](https://www.gnucash.org/docs/v4/C/gnucash-guide.pdf), everything in the accounting world can fit into five groups, or account types

* Assets
    * cash, debit cards, checking and savings accounts
    * investment and retirement accounts
    * loans that are owed to you
    * homes, vehicles, and other valuable property
* Liabiliies
    * mortgages and loans
    * credit cards
    * utility, phone, medical, and other bills
* Income
    * Salary, wages, commission, and bonuses
    * Employer contributions and reimbursements
    * Insurance claim payments
    * Interest earned
* Expenses
    * Living costs: rent, groceries, gasoline, utilities, insurance premiums
    * Everyday purchases: travel, entertainment, shopping
    * Taxes
    * Interest owed on loans
    * Fees, dues, and fines
* Equity
    * Opening balances
    * Inheritance
    * Everything else, miscellaneous
    


## Liabilities - things you owe

Every loan you to others is a separate liability account. Mortgages, student loans, and car loans are the typical examples. 

Anything that is billed to you is also a liability account: credit cards, utilities, and doctors' offices.

## Income - increases assets, decreases liabilities

Your paycheck is the main income account. Employer contributions to a retirement account and 

Insurance payments are also income, even if it's not a claim check. For example, an insurance company that pays a health provider directly reduces the patient's medical bill- a liability- which makes it income in the accounting sense. 

## Expenses - decreases assets, increases liabilities

Expense accounts are probably the most important accounts for personal finance. If you want to see where your money is going, this is where to do it. Be creative and think about what you care most about: rent, groceries, restaurants, gasoline, entertainment. 

## Equity

The best way I can explain equity accounts is that they are E. None of the Above. I use it when the other four types don't make sense. These accounts are mostly technical and have no meaning for accounting purposes. 

# Keep it simple

Don't go overboard

# Liabilities vs. Expenses

The difference between liabilities and expenses might be confusing. It's mostly a matter of convenience over correctness. For example, I put my phone bills, utility bills, and HOA dues under expenses. It is probably more correct to put them in liabities, because I can choose not to pay them and keep a positive balance. If I did that, I would want to see my outstanding balance in Gnucash, and a liability account would help me. However, I pay roughly the same amount on a regular basis (monthly or annually), and I pay my balance in full and on time. Because of these conditions, I find a liability account adds unnecessary complexity for my purposes.

With credit cards, I always have a positive balance, even if I pay the previous bill in full. Here it makes sense to keep credit cards as liabilities so I know whay my next bill will be.

Payments on a loan's principal reduce liability only and are technically not expenses. Only the interest portion of the payment is an expense. If you want to see the loan payment as a monthly expense (because it sure is for many people), Gnucash does not have a good way to visualize this. This is where SQL comes in. 

# A note about currencies

Every account has one currency only

# Accounts in SQL




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

