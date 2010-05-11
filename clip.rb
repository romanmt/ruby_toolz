#!/usr/bin/env ruby
require 'fileutils'

project_name = ARGV.first

FileUtils.mkdir %w( spec lib bin )
FileUtils.mkdir ["spec/#{project_name}", "lib/#{project_name}"]

spec_helper = <<EOF
$: << File.join(File.dirname(__FILE__), "/../lib")
require '#{project_name}'
EOF

lib_helper = <<EOF
Dir.open("lib/#{project_name}").entries.select {|name| name =~ /^.*\.rb$/ }.each do |file|
  require ['lib', project_name, file].join('/')
end
EOF

File.open("lib/#{project_name}.rb", 'w+') do | file |
  file << lib_helper
end

File.open("spec/spec_helper.rb",  "w+") do | file |
  file <<  spec_helper
end

File.open("bin/#{project_name}", 'w+') do | file |
  file << "#!/usr/bin/env ruby"
end

FileUtils.chmod 0755, "bin/#{project_name}"
              
