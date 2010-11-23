require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "redline"
    gem.summary = %Q{Syncs your AR models with Braintree (Payment Gateway) and offers a lightweight reoccurring billing script}
    gem.description = %Q{Syncs your AR models with Braintree (Payment Gateway) and offers a lightweight reoccurring billing script}
    gem.email = "james@marginleft.com"
    gem.homepage = "http://github.com/jamesdaniels/redline"
    gem.authors = ["James Daniels"]
    gem.add_development_dependency "rspec", "~> 1.2.9"
    gem.add_development_dependency "metric_fu", "~> 2.0.1"
		gem.add_development_dependency 'sqlite3-ruby', '~> 1.3.1'
    gem.add_dependency 'braintree', '~> 1.2.1'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
	require 'metric_fu'
rescue
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "redline #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
