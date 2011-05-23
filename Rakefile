require 'rake'
require "rake/extensiontask"

task :benchmark do
   ruby 'benchmark.rb'
end

Rake::ExtensionTask.new("liboauth_ext") do |ext|
    CLEAN.include "lib/*.#{RbConfig::CONFIG['DLEXT']}"
end

begin
  require 'rspec'
  require 'rspec/core/rake_task'

  desc "Run all examples with RCov"
  RSpec::Core::RakeTask.new('spec:rcov') do |t|
    t.rcov = true
  end
  RSpec::Core::RakeTask.new('spec') do |t|
    t.verbose = true
  end

  task :default => :spec
rescue LoadError
  puts "rspec, or one of its dependencies, is not available. Install it with: sudo gem install rspec"
end

Rake::Task[:spec].prerequisites << :compile
Rake::Task[:benchmark].prerequisites << :compile
