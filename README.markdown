#Kekkan

[![Gem Version](https://badge.fury.io/rb/kekkan.png)](http://badge.fury.io/rb/kekkan)
[![Build Status](https://travis-ci.org/hammack/kekkan.png?branch=master)](https://travis-ci.org/hammack/kekkan)  
[![Code Climate](https://codeclimate.com/github/hammack/kekkan/badges/gpa.svg)](https://codeclimate.com/github/hammack/kekkan)
[![Inline docs](http://inch-ci.org/github/hammack/kekkan.png)](http://inch-ci.org/github/hammack/kekkan)

Kekkan is a parser and [ActiveRecord](http://api.rubyonrails.org/classes/ActiveRecord/Base.html) database for [NVD](https://web.nvd.nist.gov) version 2.0 CVE and CPE XML files. The CVE feed can be found on the NVD [here](https://nvd.nist.gov/download.cfm#CVE_FEED).

The name comes from the Japanese word for 'flaw/defect'.

# Requirements

##Ruby
Keigan has been tested with ruby-1.9.2-p320, ruby-1.9.3-p125. Please try to use one of these versions if possible. I recommend using RVM to setup your ruby environment you can get it [here](https://rvm.beginrescueend.com/).

### RubyGems
Kekkan relies heavily on [RubyGems](http://rubygems.org/) to install other dependencies I highly recommend using it. RubyGems is included by default in the 1.9.x versions of [Ruby](http://ruby-lang.org/).

- rails
- yaml
- nokogiri

# Installation
Installation is really easy just gem install!

	% gem install kekkan

## Database Setup

	% kekkan --create-config
	% $EDITOR kekkan.cfg
	% kekkan --create-tables

1. Generate the kekkan.cfg file.
2. Edit the kekkan.cfg file, filling in the variables as needed.
3. Migrate the database schema.

## Parsing NVD CVE XML

	% kekkan nvdcve-2.0-2012.xml [nvdcve-2.0-2011.xml ...]

1. Parse the files by passing their names on the command line.

# Viewing Data
The data can be queried with a built in console or with an external database viewer. The data is mostly for consumption from another program.

	% kekkan --console

# Contributing
If you would like to contribute bug fixes/etc to Kekkan. The easiest way is to fork the project on [github](http://github.com/hammackj/kekkan) and make the changes in your fork and the submit a pull request to the project.

# Issues
If you have any problems, bugs or feature requests please use the [github issue tracker](http://github.com/hammackj/kekkan/issues).

# Contact
You can reach the team at jacob.hammack[at]hammackj[dot]com.

You can also contact the team on IRC on irc.freenode.net, #risu
