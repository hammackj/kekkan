# Copyright (c) 2010-2012 Arxopia LLC.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Arxopia LLC nor the names of its contributors
#     	may be used to endorse or promote products derived from this software
#     	without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ARXOPIA LLC BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

module Kekkan
	module Base

		# Kekkan database Schema
		class Schema < ActiveRecord::Migration

			# Creates all of the database tables required by the parser
			#
			def self.up
				create_table :entries do |t|
					t.string :cve
					t.string :published_datetime
					t.string :last_modified_datetime
					t.string :summary
					t.string :cwe
					t.string :security_protection
				end

				#create_table :vulnerable_configurations do |t|
					#ignoring for now
				#end

				create_table :vulnerable_software_lists do |t|
					t.integer :entry_id
					t.string :product
				end

				create_table :cvsses do |t|
					t.integer :entry_id
					t.string :score
					t.string :access_vector
					t.string :access_complexity
					t.string :authenication
					t.string :confidentiality_impact
					t.string :integrity_impact
					t.string :availability_impact
					t.string :source
					t.string :generated_on_datetime
				end

				create_table :references do |t|
					t.integer :entry_id
					t.string :source
					t.string :ref_type
					t.string :reference
					t.string :href
					t.string :language
				end

				create_table :assessment_checks do |t|
					t.integer :entry_id
					t.string :name
					t.string :href
					t.string :system
				end

				create_table :scanners do |t|
					t.integer :entry_id
					t.string :name
					t.string :href
					t.string :system
				end

				create_table :versions do |t|
					t.string :version
				end
			end

			# Deletes all of the database tables created
			#
			def self.down
				drop_table :entries
				#drop_table :vulnerable_configurations
				drop_table :vulnerable_software_lists
				drop_table :cvsses
				drop_table :references
				drop_table :assessment_checks
				drop_table :scanners
				drop_table :versions
			end
		end
	end
end
