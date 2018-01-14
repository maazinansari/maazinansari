#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Maazin Ansari'
SITENAME = 'Maazin Ansari'
SITEURL = ''

PATH = 'content'

ARTICLE_PATHS = ['posts']
PAGE_PATHS = ['pages']

TIMEZONE = 'America/Chicago'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),)

# Social widget
SOCIAL = (('LinkedIn', 'https://www.linkedin.com/in/maazin-ansari/'),
          ('GitHub', 'https://github.com/maazinansari/'),
          ('Twitter', 'https://twitter.com/MaazinAnsari'),)

DEFAULT_PAGINATION = 5

DISPLAY_PAGES_ON_MENU = False
DISPLAY_CATEGORIES_ON_MENU = False # manually added in MENUITEMS

MENUITEMS = [
    ('Statistics', '/category/statistics.html'),
    ('Geography', '/category/geography.html'),
    ('Archives', '/archives'),
    ('Tags', '/tags'),
    ('About', '/en/about'),
    ]

# This works without i18n_subsites:
ARTICLE_URL = '{lang}/{slug}'
ARTICLE_SAVE_AS = ARTICLE_URL + '/index.html'
ARTICLE_LANG_URL = ARTICLE_URL
ARTICLE_LANG_SAVE_AS = ARTICLE_SAVE_AS
DRAFT_URL = 'drafts/' + ARTICLE_URL
DRAFT_SAVE_AS = DRAFT_URL + '/index.html'
DRAFT_LANG_URL = DRAFT_URL
DRAFT_LANG_SAVE_AS = DRAFT_SAVE_AS
PAGE_URL = ARTICLE_URL
PAGE_SAVE_AS = ARTICLE_SAVE_AS
PAGE_LANG_URL = ARTICLE_LANG_URL
PAGE_LANG_SAVE_AS = ARTICLE_LANG_SAVE_AS

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

# Static
STATIC_PATHS = ['images', 'static', 'img']
PLUGIN_PATHS = ['plugins/pelican-plugins']

PLUGINS = ["render_math",
#          "i18n_subsites",
          ]

# i18n_subsites
# I18N_SUBSITES = {
#     'es': {}
#     }
