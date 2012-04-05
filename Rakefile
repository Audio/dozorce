require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir["test/*.rb"]
end

task :default => :test
