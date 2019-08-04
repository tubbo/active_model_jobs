# ActiveModel::Jobs

[![Build Status](https://travis-ci.org/tubbo/active_model_jobs.svg?branch=master)](https://travis-ci.org/tubbo/active_model_jobs)
[![Code Climate](https://codeclimate.com/github/tubbo/active_model-jobs/badges/gpa.svg)](https://codeclimate.com/github/tubbo/active_model-jobs)
[![Test Coverage](https://codeclimate.com/github/tubbo/active_model-jobs/badges/coverage.svg)](https://codeclimate.com/github/tubbo/active_model-jobs/coverage)
[![Inline docs](http://inch-ci.org/github/tubbo/active_model-jobs.svg?branch=master)](http://inch-ci.org/github/tubbo/active_model-jobs)

A model-level interface for kicking off background jobs using ActiveJob.
Most useful inside a Rails application, it enables you to enqueue
ActiveJob jobs with a dynamically-generated instance method inside your
ActiveRecord (or ActiveModel-compatible) model class.

[Documentation](http://www.rubydoc.info/github/tubbo/active_model-jobs/master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_model-jobs'
```

And then run:

```bash
$ bundle
```

If you're using ActiveRecord, the `ActiveModel::Jobs` module will be
included in your models by default. For other ORMs or POROs that use
ActiveModel, you'll need to include the module yourself:

```ruby
class Model
  include ActiveModel::Model
  include ActiveModel::Jobs
end
```

## Usage

Given we already have a model called **Track**, generate a job
called `UploadTrackJob`:

```ruby
require 'aws/s3'

class UploadTrackJob < ActiveRecord::Base
  queue_as :default

  def perform(track)
    s3.put_object(track.file.data, track.file.attributes)
  end

  private

  def s3
    AWS::S3.new
  end
end
```

Now, you can kick off that job by calling its "action method" on your
model:

```ruby
class Track < ActiveRecord::Base
  attachment :file

  after_create :upload!
end
```

Since this is just an instance method, you can call `track.upload!` to
kick off the job at any time outside of the callback lifecycle.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/console` for an interactive prompt that will allow you
to experiment.

We follow a [semantic versioning](http://semver.org) guideline when
releasing new versions. Documentation updates do not get a new version,
it is just merged into 'master' and updated on http://rubydoc.info.

## Contributing

1. Fork it ( https://github.com/tubbo/active_model-jobs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

All contributions must be made in a pull request and include accompanying tests.
Pull requests will not be merged until they pass the CI build for all supported
Ruby and Rails versions. To install this gem onto your local machine, run
`bundle exec rake install`. To release a new version, update the version number
in `version.rb`, and then run `bundle exec rake release` to create a git
tag for the version, push git commits and tags, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

Also see our [Code of Conduct](https://github.com/tubbo/active_model-jobs/blob/master/CODE_OF_CONDUCT.md).
