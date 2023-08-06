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

# Theme
THEME = "notmyidea"

# Social widget
SOCIAL = (('GitHub', 'https://github.com/maazinansari/'))

SUMMARY_MAX_LENGTH = 30
DEFAULT_PAGINATION = 5

# Disable authors, categories, tags, and category pages
DIRECT_TEMPLATES = ['index', 'archives']
CATEGORY_SAVE_AS = ''

DISPLAY_PAGES_ON_MENU = False
DISPLAY_CATEGORIES_ON_MENU = False # manually added in MENUITEMS

MENUITEMS = [
#    ('Statistics', '/category/statistics.html'),
    ('About', '/about'),
    ('Archives', '/archives'),
    ('Links', '/links'),
    ]

# This works without i18n_subsites:
ARTICLE_URL = 'posts/{slug}'
ARTICLE_SAVE_AS = ARTICLE_URL + '/index.html'
ARTICLE_LANG_URL = ARTICLE_URL + '-{lang}'
ARTICLE_LANG_SAVE_AS = ARTICLE_LANG_URL + '/index.html'

DRAFT_URL = 'drafts/' + ARTICLE_URL
DRAFT_SAVE_AS = DRAFT_URL + '/index.html'
DRAFT_LANG_URL = DRAFT_URL
DRAFT_LANG_SAVE_AS = DRAFT_SAVE_AS

PAGE_URL = '{slug}'
PAGE_SAVE_AS = PAGE_URL + '/index.html'
PAGE_LANG_URL = PAGE_URL + '-{lang}'
PAGE_LANG_SAVE_AS = PAGE_LANG_URL + '/index.html'

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True

# Static
STATIC_PATHS = ['static', 'img']
PLUGIN_PATHS = ['plugins/pelican-plugins']

PLUGINS = ["render_math",
#          "i18n_subsites",
]

# i18n_subsites
# I18N_SUBSITES = {
#     'es': {}
#     }
