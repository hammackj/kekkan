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
	module CLI

		#
		class Application
			include Kekkan::Base
			attr_accessor :database

			#
			def initialize
				@options = {}
				@database = {}

				@options[:debug] = false
			end

			#
			def create_config file=CONFIG_FILE
				File.open(file, 'w+') do |f|
					f.write("database:\n")
					f.write("  adapter: \n")
					f.write("  host: \n")
					f.write("  port: \n")
					f.write("  database: \n")
					f.write("  username: \n")
					f.write("  password: \n")
					f.write("  timeout: \n\n")
				end
			end

			#
			def load_config file=CONFIG_FILE, memory_config=false
				if File.exists?(file) == true or memory_config == true
					begin
						if memory_config
							yaml = YAML::load(file)
						else
							yaml = YAML::load(File.open(file))
						end

						@database = yaml["database"]

						puts @database.inspect if @options[:debug]

					rescue => e
						puts "[!] Error loading configuration! - #{e.message}"
						exit
					end
				else
					puts "[!] Configuration file does not exist!"
					exit
				end
			end

			# Initiator for [ActiveRecord] migrations.
			#
			# @param direction [Symbol] :up or :down
			def migrate direction
				begin
					if @database["adapter"] == nil
						return false, "[!] Invalid database adapter, please check your configuration file"
					end

					ActiveRecord::Base.establish_connection(@database)
					require 'kekkan/base/schema'
					Schema.migrate(direction)

					if direction == :up
						puts "[*] Creating tables"
						ver = Version.create
						ver.version = Kekkan::VERSION
						ver.save
					end

					puts "[*] Dropping tables" if direction == :down

				#@todo temp hack, fix this by checking the schema on :up or :down for exiting data
				rescue SQLite3::SQLException => sqlitex
					puts "#{sqlitex.message}\n #{sqlitex.backtrace}" if @options[:debug]
					continue
				rescue ActiveRecord::AdapterNotSpecified => ans
					puts "[!] Database adapter not found, please check your configuration file"
					puts "#{ans.message}\n #{ans.backtrace}" if @options[:debug]
					exit
				rescue ActiveRecord::AdapterNotFound => anf
					puts "[!] Database adapter not found, please check your configuration file"
					puts "#{ans.message}\n #{ans.backtrace}" if @options[:debug]
					exit
				rescue => e
					puts "[!] Exception! #{e.message}\n#{e.backtrace}"
					exit
				end
			end

			#
			def db_connect
				begin
					if @database["adapter"] == nil
						puts "[!] #{@database['adapter']}" if @options[:debug]

						return false, "[!] Invalid database adapter, please check your configuration file"
					end

					ActiveRecord::Base.establish_connection(@database)
					connection = ActiveRecord::Base.connection

					if @database["adapter"] =~ /sqlite/
						connection.execute("PRAGMA default_synchronous=OFF;")
						connection.execute("PRAGMA synchronous=OFF;")
						connection.execute("PRAGMA journal_mode=OFF;")
					end

					connection
				rescue ActiveRecord::AdapterNotSpecified => ans
					puts "[!] Database adapter not found, please check your configuration file"
					puts "#{ans.message}\n #{ans.backtrace}" if @options[:debug]
					exit
				rescue ActiveRecord::AdapterNotFound => anf
					puts "[!] Database adapter not found, please check your configuration file"
					puts "#{anf.message}\n #{anf.backtrace}" if @options[:debug]
					exit
				rescue => e
					puts "[!] Exception! #{e.message}\n #{e.backtrace}"
				end
			end

			#
			def test_connection?
				begin

					db_connect

					if ActiveRecord::Base.connected? == true
						return true, "[*] Connection Test Successful"
					else
						return false, "[!] Connection Test Failed"
					end
				rescue => e
					puts "[!] Exception! #{e.message}\n #{e.backtrace}"
				end
			end

			# Starts a console and executes anything in a block sent to it
			#
			# @param block Code block to transfer control
			def consolize &block

				yield

				IRB.setup(nil)
				IRB.conf[:USE_READLINE] = true
				IRB.conf[:PROMPT_MODE] = :SIMPLE

				irb = IRB::Irb.new
				IRB.conf[:MAIN_CONTEXT] = irb.context

				irb.context.evaluate("require 'irb/completion'", 0)

				trap("SIGINT") do
					irb.signal_handle
				end
				catch(:IRB_EXIT) do
					irb.eval_input
				end
			end

			#
			def parse_options
				begin
					opts = OptionParser.new do |opt|
						opt.banner =	"#{Kekkan::APP_NAME} v#{Kekkan::VERSION}\nJacob Hammack\n#{Kekkan::SITE}\n\n"
						opt.banner << "Usage: #{Kekkan::APP_NAME} [options] [files_to_parse]"

						opt.separator('')
						opt.separator('Configuration Options')

						opt.on('--config-file FILE', "Loads configuration settings for the specified file. By default #{APP_NAME} loads #{CONFIG_FILE}") do |option|
							if File.exists?(option) == true
								@options[:config_file] = option
							else
								puts "[!] Specified config file does not exist. Please specify a file that exists."
								exit
							end
						end

						opt.on('--create-config-file [FILE]',"Creates a configuration file in the current directory with the specified name, Default is #{CONFIG_FILE}") do |option|
							if option == nil
								option = CONFIG_FILE
							end

							if File.exists?(option) == true
								puts "[!] Configuration file already exists; If you wish to over-write this file please delete it."
							else
								if option == nil
									create_config
								else
									create_config option
								end

								exit
							end
						end

					opt.separator('')
						opt.separator('Database Options')

						opt.on('--test-connection','Tests the database connection settings') do |option|
							@options[:test_connection] = option
						end

						opt.on('--create-tables',"Creates the tables required for #{APP_NAME}") do |option|
							@options[:create_tables] = option
						end

						opt.on('--drop-tables', "Deletes the tables and data from #{APP_NAME}") do |option|
							@options[:drop_tables] = option
						end

					opt.separator ''
						opt.separator 'Other Options'

						opt.on_tail('-v', '--version', "Shows application version information") do
							puts "#{APP_NAME}: #{VERSION}\nRuby Version: #{RUBY_VERSION}\nRubygems Version: #{Gem::VERSION}"
							exit
						end

						opt.on('-d','--debug','Enable Debug Mode (More verbose output)') do |option|
							@options[:debug] = true
						end

						opt.on('--console', 'Starts an ActiveRecord console into the configured database') do |option|
							@options[:console] = option
						end

						opt.on_tail("-?", "--help", "Show this message") do
							puts opt.to_s + "\n"
							exit
						end
					end

					if ARGV.length != 0
						opts.parse!
					else
						puts opts.to_s + "\n"
						exit
					end
				rescue OptionParser::MissingArgument => m
					puts opts.to_s + "\n"
					exit
				rescue OptionParser::InvalidOption => i
					puts opts.to_s + "\n"
					exit
				end
			end

			#
			def parse_file file
				begin
					parser = Nokogiri::XML::SAX::Parser.new(Kekkan::Parsers::Cve2Document.new)

					parser.parse(File.open(file))

				rescue => e
					raise e
				end
			end

			#
			def run
				parse_options

				if @options[:debug]
					puts "[*] Enabling Debug Mode"
				end

				if @options[:config_file] != nil
					load_config @options[:config_file]
				else
					load_config
				end

				db_connect

				if @options[:console] != nil
					consolize do
						puts Kekkan::CLI::Banner
						puts "#{APP_NAME} Console v#{VERSION}"
					end
					exit
				end

				if @options[:test_connection] != nil
					result = test_connection?

					puts "#{result[1]}"
					exit
				end

				if @options[:create_tables] != nil
					migrate(:up)
					exit
				end

				if @options[:drop_tables] != nil
					migrate(:down)
					exit
				end

				ARGV.each do |file|
					begin
						parse_file file

					rescue => e
						puts e.inspect
						puts "[!] #{e.message}\n #{e.backtrace.join("\n")}\n"
						puts "[!] Error: #{file}"
						next
					end
				end
			end
		end
	end
end
