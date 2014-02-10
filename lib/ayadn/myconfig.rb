module Ayadn

	class MyConfig

		AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"

		attr_accessor :options

		def initialize
			@user_token = IO.read(File.expand_path("../../../token", __FILE__)).chomp
			ayadn_config
			load_config
		end

		def build_query_options(arg)
			count = arg[:count] || @options[:counts][:unified]
			directed = @options[:timeline][:directed] || 1
			"&count=#{count}&include_html=0&include_directed=#{directed}&include_deleted=0&include_annotations=1"
		end

		def user_token
			@user_token
		end

		private

		def ayadn_config
			home = Dir.home + "/ayadn/data"
			@ayadn_config = {
				paths: {
					home: home
				}
			}
		end

		def load_config
			@options = defaults # temp
			# check if installed config
			# yes => load
			# no => create from defaults then load
			config_file = @ayadn_config[:paths][:home] + "/config.yml"
			unless File.exists?(config_file)
				#File.open(@home, 'w') {|f| f.write @options.to_yaml }
				puts "DEBUG: no config file"
			end
		end

		def defaults
			{
				timeline: {
					directed: 1,
					show_clients: true,
					show_symbols: true,
					show_reposters: true
				},
				counts: {
					unified: 50
				}
			}
		end

	end
end