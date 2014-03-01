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
			@options = self.defaults # overridden later in the method by the loaded file
			home = Dir.home + "/ayadn2/data" #temp, will be /ayadn/data in v1
			@user_token = IO.read(File.expand_path("../../../token", __FILE__)).chomp #temp
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
			unless File.exist?(@config[:paths][:config] + "/identity.yml")
				resp = API.new.get_user("me")
				username = resp['data']['username']
				self.create_identity_file(username)
				@config[:identity] = username
			else
				@config[:identity] = self.read_identity_file
			end
		end

		def self.create_identity_file(username)
			f = File.new(@config[:paths][:config] + "/identity.yml", "w")
				f.write({identity: username}.to_yaml)
			f.close
		end

		def self.read_identity_file
			content = YAML.load(IO.read(@config[:paths][:config] + "/identity.yml"))
			content[:identity]
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
			#todo: unless version file exists + more checks
			begin
				FileUtils.mkdir_p(@config[:paths][:home]) unless Dir.exists?(@config[:paths][:home])
				%w{log db pagination config auth downloads backup posts messages lists}.each do |target|
					Dir.mkdir(@config[:paths][target.to_sym]) unless Dir.exists?(@config[:paths][target.to_sym])
				end
			rescue => e
				Logs.rec.error "From myconfig/create ayadn folders"
				Logs.rec.error "#{e}"
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
				backup: {
					auto_save_sent_posts: false,
					auto_save_sent_messages: false,
					auto_save_lists: false
				}
			}
		end

	end
end
