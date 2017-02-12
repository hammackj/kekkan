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

module Kekkan
	module Base

		# Kekkan database Schema
		class Schema < ActiveRecord::Migration[4.2]

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
