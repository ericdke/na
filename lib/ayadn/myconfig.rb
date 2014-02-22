module Ayadn

	class MyConfig

		AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"

		class << self
			attr_accessor :options, :config
			attr_reader :user_token
		end

		def self.build_query_options(arg)
			count = arg[:count] || @options[:counts][:default] #default as a backup, but real value comes from Endpoints
			directed = arg[:directed] || @options[:timeline][:directed]
			deleted = arg[:deleted] || @options[:timeline][:deleted]
			html = arg[:html] || @options[:timeline][:html]
			annotations = arg[:annotations] || @options[:timeline][:annotations]
			"&count=#{count}&include_html=#{html}&include_directed=#{directed}&include_deleted=#{deleted}&include_annotations=#{annotations}"
		end

		def self.load_config
			@user_token = IO.read(File.expand_path("../../../token", __FILE__)).chomp
			@options = self.defaults # overridden later in the method by the loaded file
			home = Dir.home + "/ayadn2/data/#{@options[:identity][:prefix]}" #temp, will be /ayadn/data in v1
			@config = {
				paths: {
					home: home,
					log: "#{home}/log",
					db: "#{home}/db",
					pagination: "#{home}/pagination",
					config: "#{home}/config",
					auth: "#{home}/auth",
					downloads: "#{home}/downloads",
					backup: "#{home}/backup",
					posts: "#{home}/backup/posts",
					messages: "#{home}/backup/messages",
					lists: "#{home}/backup/lists"
				},
				version: VERSION
			}
			self.create_config_folders
			self.create_config_file
			self.create_version_file
		end

		def self.create_version_file
			vf = File.new(@config[:paths][:config] + "/version.yml", "w")
				vf.write({version: @config[:version]}.to_yaml)
			vf.close
		end

		def self.create_config_file
			config_file = @config[:paths][:config] + "/config.yml"
			if File.exists?(config_file)
				# TODO: system to merge existing config file when future category are added
				begin
					@options = YAML.load(IO.read(config_file))
				rescue => e
					Logs.rec.error "From myconfig/load config.yml"
					Logs.rec.error "#{e}"
				end
			else
				begin
					self.write_config_file(config_file, @options)
				rescue => e
					Logs.rec.error "From myconfig/create config.yml from defaults"
					Logs.rec.error "#{e}"
				end
			end
		end

		def self.create_config_folders
			unless Dir.exists?(@config[:paths][:home])
				begin
					Dir.mkdir(@config[:paths][:home])
				rescue => e
					Logs.rec.fatal "From myconfig/create home data folder"
					Logs.rec.fatal "#{e}"
				end
			else
				begin
					Dir.mkdir(@config[:paths][:log]) unless Dir.exists?(@config[:paths][:log])
					Dir.mkdir(@config[:paths][:db]) unless Dir.exists?(@config[:paths][:db])
					Dir.mkdir(@config[:paths][:pagination]) unless Dir.exists?(@config[:paths][:pagination])
					Dir.mkdir(@config[:paths][:config]) unless Dir.exists?(@config[:paths][:config])
					Dir.mkdir(@config[:paths][:auth]) unless Dir.exists?(@config[:paths][:auth])
					Dir.mkdir(@config[:paths][:downloads]) unless Dir.exists?(@config[:paths][:downloads])
					Dir.mkdir(@config[:paths][:backup]) unless Dir.exists?(@config[:paths][:backup])
					Dir.mkdir(@config[:paths][:posts]) unless Dir.exists?(@config[:paths][:posts])
					Dir.mkdir(@config[:paths][:messages]) unless Dir.exists?(@config[:paths][:messages])
					Dir.mkdir(@config[:paths][:lists]) unless Dir.exists?(@config[:paths][:lists])
				rescue => e
					Logs.rec.fatal "From myconfig/create ayadn folders"
					Logs.rec.fatal "#{e}"
				end
			end
		end

		def self.write_config_file(config_file, options)
			f = File.new(config_file, "w")
				f.write(options.to_yaml)
			f.close
		end

		def self.defaults
			{
				timeline: {
					directed: 1,
					deleted: 0,
					html: 0,
					annotations: 1,
					show_source: true,
					show_symbols: true,
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
					convo: 50,
					posts: 50,
					messages: 50,
					search: 100,
					whoreposted: 50,
					whostarred: 50,
					whatstarred: 100,
					files: 66
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
					mentions: :red,
					source: :blue,
					symbols: :green
				},
				pinboard: { #move this elsewhere
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
				}
			}
		end

	end
end