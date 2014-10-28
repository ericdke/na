# require 'spec_helper'
# require 'helpers'
# require 'json'

# describe Ayadn::Annotations do

#   before do
#     Ayadn::Settings.stub(:options).and_return(
#       {
#         timeline: {
#           directed: 1,
#           deleted: 0,
#           html: 0,
#           annotations: 1,
#           show_source: true,
#           show_symbols: true,
#           show_real_name: true,
#           show_date: true,
#           show_spinner: true,
#           show_debug: false
#         },
#         counts: {
#           default: 50,
#           unified: 100,
#           global: 100,
#           checkins: 100,
#           conversations: 50,
#           photos: 50,
#           trending: 100,
#           mentions: 100,
#           convo: 100,
#           posts: 100,
#           messages: 50,
#           search: 200,
#           whoreposted: 50,
#           whostarred: 50,
#           whatstarred: 100,
#           files: 100
#         },
#         formats: {
#           table: {
#             width: 75
#           }
#         },
#         colors: {
#           id: :blue,
#           index: :red,
#           username: :green,
#           name: :magenta,
#           date: :cyan,
#           link: :yellow,
#           dots: :blue,
#           hashtags: :cyan,
#           mentions: :red,
#           source: :cyan,
#           symbols: :green,
#           debug: :red
#         },
#         backup: {
#           auto_save_sent_posts: false,
#           auto_save_sent_messages: false,
#           auto_save_lists: false
#         },
#         scroll: {
#           timer: 3
#         },
#         nicerank: {
#           threshold: 2.1,
#           cache: 48,
#           filter: true,
#           filter_unranked: false
#         },
#         nowplaying: {},
#         movie: {
#           hashtag: 'nowwatching'
#         },
#         tvshow: {
#           hashtag: 'nowwatching'
#         }
#       }
#     )
#     Ayadn::Settings.stub(:config).and_return({
#         identity: {
#           username: 'test',
#           handle: '@test'
#         },
#         post_max_length: 256,
#         message_max_length: 2048,
#         version: 'wee'
#       })
#     Ayadn::Errors.stub(:warn).and_return("warned")
#     Ayadn::Logs.stub(:rec).and_return("logged")
#     Ayadn::FileOps.stub(:make_paths).and_return(['~/your/path/cat.jpg', '~/your/path/dog.png']) # STUB1
#     Ayadn::FileOps.stub(:upload_files).and_return([{'data' => {'id' => 3312,'file_token' => '0x3312-YOLO'}},{'data' => {'id' => 5550,'file_token' => '0x5550-WOOT'}}])
#   end

# end
