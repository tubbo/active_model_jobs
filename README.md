# ActiveModel::Jobs

A model-level interface for kicking off background jobs using ActiveJob.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_model-jobs'
```

And then execute:

```bash
$ bundle
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
  include ActiveModel::Jobs

  after_commit :upload!, on: :create
end
```

Since this is just an instance method, you can call `track.upload!` to
kick off the job at any time outside of the callback lifecycle.

### Global Inclusion

You can include this module in every ActiveRecord model by inserting the
following code into an initializer at
**config/initializers/active_model_jobs.rb**:

```ruby
ActiveRecord::Base.send :include, ActiveModel::Jobs
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

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

Also see our [Code of Conduct](http://github.com/tubbo/active_model-jobs/master/tree/CODE_OF_CONDUCT.md).
