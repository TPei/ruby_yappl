# Ruby Library for YaPPL

[![Build Status](https://travis-ci.com/TPei/ruby_yappl.svg?branch=master)](https://travis-ci.com/TPei/ruby_yappl)
[![Gem Version](https://badge.fury.io/rb/ruby_yappl.svg)](https://rubygems.org/gems/ruby_yappl)
[![Release](https://img.shields.io/github/release/tpei/ruby_yappl.svg)](https://github.com/TPei/ruby_yappl/releases)

## What is YaPPL?

YaPPL is a Privacy Preference Language (see [YaPPL](https://github.com/maroulb/YaPPL))

> YaPPL allows to codify legally sufficient consent and thus provides a valuable basis for GDPR-compliant consent management. In a nutshell, YaPPL is a message and file format that, in combination with the proposed service architecture, a) fulfills legal requirements for technically mediated consent provision, b) can act as an archive for expired preferences for auditing purposes, c) provides an enhanced user-centric access control model for future or unforeseen data processing requests. - Ulbricht & Pallas, 2018


## What is this?

This is a Ruby Gem to work with YaPPL policies :)

## Usage

First, you need to add this to your Gemfile: `gem 'ruby_yappl'` and then
run `bundle install`, now you have it installed. `require 'ruby_yappl'` to require the files.

The gem provides different classes to use, mainly `YaPPL::Policy` and `YaPPL::Rule`.

A policy can be created by parsing a policy file. Simply pass the json to `YaPPL::Policy.from_policy_file`.
This will instantiate a `YaPPL::Policy` and the appropriate `YaPPL::Rule` objects.

`Policy` provides a few public methods in accordance with the official
[YaPPL](https://github.com/maroulb/YaPPL) definition:

* `#create_policy` serializes the classes to their json representation to
be saved to database or file.

* `#get_excluded_purpose` returns an array of all excluded purposes

* `#get_excluded_utilizer` returns an array of all excluded utilizers

* `#new_rule(args)` adds a new rule to the Policy. `#add_rule(rule)` can
also be used if you prefer handling objects instead of parameters.

* `#get_tr_rules` returns an array of Transformation rules, including
the utilizers and purposes they depend on.

* `#archive_rule(rule_id)` expires and archives a rule.

* `#update_rule(rule_id, args)` updates a rule, archiving its old state.

Additionally, `YaPPL::Rule#expired?` can be used to see if a rule still applies.

### Demo
```ruby
require 'ruby_yappl'

# deserialize
policy = YaPPL::Policy.from_json_file(File.read('./my_policy_file.json'))

# update a rule
policy.update_rule(4, {
  permitted_purposes: ['data_analysis'],
  excluded_purposes: ['marketing'],
  permitted_utilizers: ['market_research'],
  excluded_utilizers: ['shopping', 'social_networks'],
  transformations: [{
    attribute: 'temperature',
    tr_func: 'minmax_hourly'
  }]
})

# archive a rule
policy.archive_rule(5)

# reserialize
File.new('./my_policy.json', 'w').write(policy.create_policy)

```
