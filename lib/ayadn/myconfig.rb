module Ayadn

	class MyConfig

		AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"

		attr_accessor :options, :config, :id_prefix

		def initialize
			@user_token = IO.read(File.expand_path("../../../token", __FILE__)).chomp
			@id_prefix = "me"
			@home = Dir.home + "/ayadn2/data/#{@id_prefix}"
			load_config
		end

		def build_query_options(arg)
			count = arg[:count] || @options[:counts][:default]
			directed = @options[:timeline][:directed] || 1
			deleted = arg[:deleted] || @options[:timeline][:deleted]
			html = arg[:html] || @options[:timeline][:html]
			annotations = arg[:annotations] || @options[:timeline][:annotations]
			"&count=#{count}&include_html=#{html}&include_directed=#{directed}&include_deleted=#{deleted}&include_annotations=#{annotations}"
		end

		def user_token
			@user_token
		end

		private

		def ayadn_config
			{
				paths: {
					home: @home
				}
			}
		end

		def load_config
			@config = ayadn_config
			@options = defaults # temp
			# check if installed config
			# yes => load
			# no => create from defaults then load
			config_file = @config[:paths][:home] + "/config.yml"
			unless Dir.exists?(@config[:paths][:home])
				Dir.mkdir(@config[:paths][:home])
			end
			if File.exists?(config_file)
				#load
			else
				puts "DEBUG: no config file at #{config_file}"
				puts "creating one from defaults"
				# if no file, create from defaults
			end
		end

		def defaults
			{
				timeline: {
					directed: 1,
					deleted: 0,
					html: 0,
					annotations: 1,
					show_clients: true,
					show_symbols: true,
					show_reposters: true,
					show_original_post: false
				},
				counts: {
					default: 50,
					unified: 50,
					global: 50,
					checkins: 50,
					conversations: 50,
					photos: 50,
					trending: 50,
					mentions: 50,
					posts: 50,
					messages: 50,
					search: 100,
					whoreposted: 50,
					whostarred: 50,
					whatstarred: 100
				},
				formats: {
					table: {
						width: 80
					}
				},
				colors: {
					id: :red,
					index: :red,
					username: :green,
					name: :yellow,
					date: :cyan,
					link: :magenta
				}
			}
		end

	end
end