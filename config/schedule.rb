# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, "development"
set :output, {:error => "log/cron_error.log", :standard => "log/cron_log.log"}
# job_type :runner, "cd :path && /usr/local/bin/chruby-exec ruby-2.2.1 -- bin/rails runner -e :environment ':task' :output"
job_type :runner,  "PATH=/Users/Olivia/.rubies/ruby-2.2.1/bin:/Users/Olivia/.gem/ruby/2.2.1/bin GEM_PATH=/Users/Olivia/.gem/ruby/2.2.1:/Users/Olivia/.rubies/ruby-2.2.1/lib/ruby/gems/2.2.0 GEM_HOME=/Users/Olivia/.gem/ruby/2.2.1 && cd :path && bundle exec rails runner -e :environment ':task' :output"
# 
# every 1.minute do
#   runner "StoriesApi.new"
# end
