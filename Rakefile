# Copyright (c) 2012-2017 Jacob Hammack.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "kekkan/version"
require 'rake'
require 'rake/testtask'

task :build do
	system "gem build #{Kekkan::APP_NAME}.gemspec"
end

task :checksum do
	built_gem_path = "#{Kekkan::APP_NAME}-#{Kekkan::VERSION}.gem"

	checksum512 = Digest::SHA512.new.hexdigest(File.read(built_gem_path))
	checksum256 = Digest::SHA256.new.hexdigest(File.read(built_gem_path))

	checksum_512_path = "checksum/#{Kekkan::APP_NAME}-#{Kekkan::VERSION}.gem.sha512"
	checksum_256_path = "checksum/#{Kekkan::APP_NAME}-#{Kekkan::VERSION}.gem.sha256"

	File.open(checksum_512_path, 'w' ) {|f| f.write(checksum512) }
	File.open(checksum_256_path, 'w' ) {|f| f.write(checksum256) }

	system "git add #{checksum_512_path} #{checksum_256_path}"
	system "git commit #{checksum_512_path} -m 'Added #{Kekkan::APP_NAME}-#{Kekkan::VERSION}.gem SHA512 checksum'"
	system "git commit #{checksum_256_path} -m 'Added #{Kekkan::APP_NAME}-#{Kekkan::VERSION}.gem SHA256 checksum'"
end

task :tag_and_bag do
	system "git tag -a v#{Kekkan::VERSION} -m 'version #{Kekkan::VERSION}'"
	system "git push --tags"
	system "git checkout master"
	system "git merge dev"
	system "git push"
end

task :push do
	system "gem push #{Kekkan::APP_NAME}-#{Kekkan::VERSION}.gem"
end

task :tweet do
	puts "Just released #{Kekkan::APP_NAME} v#{Kekkan::VERSION}. #{Kekkan::APP_NAME} is an Nessus XML parser/database/report generator. More information at #{Kekkan::SITE}"
end

task :release => [:build, :checksum, :tag_and_bag, :push, :tweet] do
end

task :clean do
	system "rm *.gem"
	system "rm *.db"
	system "rm *.cfg"
	system "rm *.pdf"
	system "rm -rf coverage"
end

task :default => [:test_unit]

Rake::TestTask.new("test_unit") { |t|
	t.libs << "test"
  t.pattern = 'test/*/*_test.rb'
  t.verbose = true
}
