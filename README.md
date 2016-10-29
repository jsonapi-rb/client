# jsonapi-client
Ruby gem for consuming [JSON API](http://jsonapi.org) documents.

## Status

[![Gem Version](https://badge.fury.io/rb/jsonapi-client.svg)](https://badge.fury.io/rb/jsonapi-client)
[![Build Status](https://secure.travis-ci.org/jsonapi-rb/client.svg?branch=master)](http://travis-ci.org/jsonapi-rb/client?branch=master)

## Installation
```ruby
# In Gemfile
gem 'jsonapi-client'
```
then
```
$ bundle
```
or manually via
```
$ gem install jsonapi-client
```

## Usage

First, require the gem:
```ruby
require 'jsonapi/client'
```

Then
```ruby
payload = {
  "links" => {
    "self" => "http://example.com/articles",
    "next" => "http://example.com/articles?page[offset]=2",
    "last" => "http://example.com/articles?page[offset]=10"
  },
  "data" => [
    {
      "type" => "articles",
      "id" => "1",
      "attributes" => {
        "title" => "JSON API paints my bikeshed!"
      },
      "relationships" => {
        "author" => {
          "links" => {
            "self" => "http://example.com/articles/1/relationships/author",
            "related" => "http://example.com/articles/1/author"
          },
          "data" => { "type" => "people", "id" => "9" }
        },
        "comments" => {
          "links" => {
            "self" => "http://example.com/articles/1/relationships/comments",
            "related" => "http://example.com/articles/1/comments"
          },
          "data" => [
            { "type" => "comments", "id" => "5" },
            { "type" => "comments", "id" => "12" }
          ]
        }
      },
      "links" => {
        "self" => "http://example.com/articles/1"
      }
    }
  ],
  "included" => [
    {
      "type" => "people",
      "id" => "9",
      "attributes" => {
        "first-name" => "Dan",
        "last-name" => "Gebhardt",
        "twitter" => "dgeb"
      },
      "links" => {
        "self" => "http://example.com/people/9"
      }
    }, {
      "type" => "comments",
      "id" => "5",
      "attributes" => {
        "body" => "First!"
      },
      "relationships" => {
        "author" => {
          "data" => { "type" => "people", "id" => "2" }
        }
      },
      "links" => {
        "self" => "http://example.com/comments/5"
      }
    }, {
      "type" => "comments",
      "id" => "12",
      "attributes" => {
        "body" => "I like XML better"
      },
      "relationships" => {
        "author" => {
          "data" => { "type" => "people", "id" => "9" }
        }
      },
      "links" => {
        "self" => "http://example.com/comments/12"
      }
    }
  ]
}

document = JSONAPI::Client::Document.new(json_hash)

document.data[0].relationships['author'].data.attributes['first-name']
# => "Dan"
```

## License

jsonapi-client is released under the [MIT License](http://www.opensource.org/licenses/MIT).
