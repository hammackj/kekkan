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

ActiveRecord::Migration.verbose = false

module Kekkan
	module Parsers
		class Cve2Document < Nokogiri::XML::SAX::Document

			# Sets up a array of all valid XML fields
			def initialize
				@vals = Hash.new

				@valid_elements = Array[
					"nvd", "vuln:cve-id", "vuln:published-datetime", "vuln:last-modified-datetime",
					"cvss:score", "cvss:access-vector", "cvss:access-complexity", "cvss:authentication",
					"cvss:confidentiality-impact", "cvss:integrity-impact", "cvss:availability-impact",
					"cvss:source", "cvss:generated-on-datetime", "cvss:base_metrics", "vuln:cvss",
					"vuln:summary", "vuln:reference", " vuln:source", "vuln:references", "vuln:source",
					"entry", "vuln:vulnerable-software-list", "vuln:product", "vuln:cwe",
					"vuln:security-protection", "vuln:assessment_check", "vuln:definition",
					"vuln:scanner"
				]

				@ignored_elements = Array[
					"cpe-lang:logical-test", "vuln:vulnerable-configuration", "cpe-lang:fact-ref"
				]

				@valid_elements = @valid_elements + @ignored_elements

			end

			# Callback for when the start of a XML element is reached
			#
			# @param element XML element
			# @param attributes Attributes for the XML element
			def start_element(element, attributes = [])
				@tag = element
				@vals[@tag] = ""

				if !@valid_elements.include?(element)
					puts "New XML element detected: #{element}. Please report this to #{Kekkan::EMAIL}"
				end

				case element
					when "entry"
						@entry = Kekkan::Models::Entry.create
						@entry.save

					when "vuln:cvss"
						@cvss = @entry.cvsses.create
						@cvss.save

					when "vuln:cwe"
						@entry.attributes = { :cwe => Hash[attributes]["id"] }
						@entry.save

					when "vuln:references"
						@reference = @entry.references.create
						@reference.attributes = {
							:ref_type => Hash[attributes]["reference_type"]
						}
						@reference.save

					when "vuln:reference"
						@reference.attributes = {
							:href => Hash[attributes]["href"],
							:language => Hash[attributes]["xml:lang"]
						}
						@reference.save

					when "vuln:assessment_check "
						@ass = @entry.assessment_check.create
						@ass.attributes = {
							:name => Hash[attributes]["name"],
							:href => Hash[attributes]["href"],
							:system => Hash[attributes]["system"]
						}
						@entry.save

					when "vuln:definition"
						@scanner = @entry.scanners.create
						@scanner.attributes = {
							:name => Hash[attributes]["name"],
							:href => Hash[attributes]["href"],
							:system => Hash[attributes]["system"]
						}
						@scanner.save
				end
			end

			# Called when the inner text of a element is reached
			#
			# @param text
			def characters(text)
				if @vals[@tag] == nil then
					@vals[@tag] = text.strip
				else
					@vals[@tag] << text.strip
				end
			end

			# Called when the end of the XML element is reached
			#
			# @param element
			def end_element(element)
				#puts "End element: #{element}"
				@tag = nil
				case element
					when "vuln:cve-id"
						@entry.attributes = { :cve => @vals["vuln:cve-id"] }
						@entry.save

					when "vuln:published-datetime"
						@entry.attributes = { :published_datetime => @vals["vuln:published-datetime"]	}
						@entry.save

					when "vuln:last-modified-datetime"
						@entry.attributes = { :last_modified_datetime => @vals["vuln:last-modified-datetime"]	}
						@entry.save

					when "vuln:summary"
						@entry.attributes = { :summary => @vals["vuln:summary"] }
						@entry.save

					when "vuln:security-protection"
						@entry.attributes = { :security_protection => @vals["vuln:security-protection"]}
						@entry.save

					when "vuln:product"
						@product = @entry.vulnerable_software_lists.create
						@product.attributes = { :product => @vals["vuln:product"] }
						@product.save

					when "vuln:cvss"
						@cvss.attributes = {
							:score => @vals["cvss:score"],
							:access_vector => @vals["cvss:access-vector"],
							:access_complexity  => @vals["cvss:access-complexity"],
							:authenication  => @vals["cvss:authentication"],
							:confidentiality_impact  => @vals["cvss:confidentiality-impact"],
							:integrity_impact  => @vals["cvss:integrity-impact"],
							:availability_impact  => @vals["cvss:availability-impact"],
							:source  => @vals["cvss:source"],
							:generated_on_datetime  => @vals["cvss:generated-on-datetime"]
						}
						@cvss.save

					when "vuln:references"
						@reference.attributes = {
							:source => @vals["vuln:source"],
							:reference => @vals["vuln:reference"]
						}
						@reference.save
				end
			end
		end
	end
end
