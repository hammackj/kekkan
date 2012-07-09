# Copyright (c) 2012 Arxopia LLC.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Arxopia LLC nor the names of its contributors
#     	may be used to endorse or promote products derived from this software
#     	without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ARXOPIA LLC BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
#OF THE POSSIBILITY OF SUCH DAMAGE.

base = __FILE__
$:.unshift(File.join(File.dirname(base), 'lib'))

require 'rubygems'
require 'kekkan'

Gem::Specification.new do |s|
	s.name = "#{Kekkan::APP_NAME}"
	s.version = Kekkan::VERSION
	s.homepage = "http://www.hammackj.com/projects/kekkan"
	s.summary = "#{Kekkan::APP_NAME}"
	s.description = "#{Kekkan::APP_NAME} is a set of parsers for NVD CVE / CPE xml files"
	s.license = "BSD"

	s.author = "Jacob Hammack"
	s.email = "jacob.hammack@arxopia.com"

	s.files	= Dir['[A-Z]*'] + Dir['lib/**/*'] + ['kekkan.gemspec']
	s.bindir = "bin"
	s.executables = "#{Kekkan::APP_NAME}"
	s.require_paths = ["lib"]
	s.has_rdoc = 'yard'
	s.extra_rdoc_files = ["README.markdown", "LICENSE"]

	s.required_rubygems_version = ">= 1.8.24"
	s.rubyforge_project	= "#{Kekkan::APP_NAME}"

	#s.add_development_dependency("simplecov", [">= 0.9.9"])
	#s.add_development_dependency("yard", [">= 0.6.4"])

	#s.add_dependency('rails', ['>= 3.0.7'])
	#s.add_dependency('libxml-ruby', ['>= 1.1.4'])
end
