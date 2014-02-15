module Ayadn

	class MyConfig

		AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"

		attr_accessor :options, :config

		def initialize
			@user_token = IO.read(File.expand_path("../../../token", __FILE__)).chomp
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

		def load_config
			@options = defaults # to be overridden later in the method by the loaded file
			home = Dir.home + "/ayadn2/data/#{@options[:identity][:prefix]}" #temp, will be /ayadn/data in v1
			@config = {
				paths: {
					home: home,
					log: "#{home}/log",
					pagination: "#{home}/pagination",
					config: "#{home}/config",
					auth: "#{home}/auth",
					downloads: "#{home}/downloads",
					backup: "#{home}/backup",
					posts: "#{home}/backup/posts",
					messages: "#{home}/backup/messages",
					lists: "#{home}/backup/lists"
				}
			}
			unless Dir.exists?(@config[:paths][:home])
				begin
					Dir.mkdir(@config[:paths][:home])
				rescue Exception => e
					$logger.fatal "#{e}\n(in myconfig/create home data folder)"
				end
			else
				begin
					Dir.mkdir(@config[:paths][:log]) unless Dir.exists?(@config[:paths][:log])
					Dir.mkdir(@config[:paths][:pagination]) unless Dir.exists?(@config[:paths][:pagination])
					Dir.mkdir(@config[:paths][:config]) unless Dir.exists?(@config[:paths][:config])
					Dir.mkdir(@config[:paths][:auth]) unless Dir.exists?(@config[:paths][:auth])
					Dir.mkdir(@config[:paths][:downloads]) unless Dir.exists?(@config[:paths][:downloads])
					Dir.mkdir(@config[:paths][:backup]) unless Dir.exists?(@config[:paths][:backup])
					Dir.mkdir(@config[:paths][:posts]) unless Dir.exists?(@config[:paths][:posts])
					Dir.mkdir(@config[:paths][:messages]) unless Dir.exists?(@config[:paths][:messages])
					Dir.mkdir(@config[:paths][:lists]) unless Dir.exists?(@config[:paths][:lists])
				rescue Exception => e
					$logger.fatal "#{e}\n(in myconfig/create ayadn folders)"
				end
			end
			config_file = @config[:paths][:config] + "/config.yml"
			if File.exists?(config_file)
				@options = YAML.load(IO.read(config_file))
				# Utility code for debug:
				#loaded = YAML.load(IO.read(config_file))
				# unless loaded == @options
				# 	@options = loaded
				# 	begin
				# 		write_config_file(config_file, @options)
				# 	rescue Exception => e
				# 		$logger.error "#{e}\n(in myconfig/create config.yml from defaults)"
				# 	end
				# end
				# puts loaded.inspect
				# puts "\n\n"
				# puts @options.inspect
				# exit
			else
				begin
					write_config_file(config_file, @options)
				rescue Exception => e
					$logger.error "#{e}\n(in myconfig/create config.yml from defaults)"
				end
			end
		end

		def write_config_file(config_file, options)
			f = File.new(config_file, "w")
				f.write(options.to_yaml)
			f.close
		end

		private

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
					show_original_post: false,
					show_real_name: true,
					show_date: true
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
						width: 75
					}
				},
				colors: {
					id: :red,
					index: :red,
					username: :green,
					name: :magenta,
					date: :cyan,
					link: :yellow,
					dots: :blue,
					hashtags: :cyan,
					mentions: :red
				},
				pinboard: {
					login: nil,
					password: nil
				},
				backup: {
					auto_save_sent_posts: false,
					auto_save_sent_messages: false,
					auto_save_lists: false
				},
				identity: {
					prefix: "me"
				},
				skipped: {
					source: [],
					mentions: [],
					hashtags: [],
					repost_of: [],
					words: []
				}
			}
		end

	end
end