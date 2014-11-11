# encoding: utf-8
module Ayadn
  class Profile

    attr_reader :options, :text, :payload

    def initialize options
      if options.empty?
        @status.profile_options
        exit
      end
      @options = options
    end

    def update
      if @options[:avatar]
        FileOps.upload_avatar(@options[:avatar].join)
      elsif @options[:cover]
        FileOps.upload_cover(@options[:cover].join)
      else
        CNX.patch(Endpoints.new.user('me'), @payload)
      end
    end

    def get_text_from_user
      unless @options[:delete] || @options[:avatar] || @options[:cover]
        writer = Post.new
        input = writer.compose()
        @text = input.join("\n")
        writer.post_size_error(@text) if writer.post_size_ok?(@text) == false
      end
    end

    def prepare_payload
      @payload = \
      if @options[:bio]
        if @options[:delete]
          {'description' => {'text' => ''}}
        else
          {'description' => {'text' => @text}}
        end
      elsif @options[:name]
        if @options[:delete]
          abort("'Delete' isn't available for 'name'.\n".color(:red))
        else
          {'name' => @text}
        end
      elsif @options[:twitter]
        if @options[:delete]
          {'annotations' => [{'type' => 'net.app.core.directory.twitter'}]}
        else
          {'annotations' => [{
            'type' => 'net.app.core.directory.twitter',
            'value' => {'username' => @text}}]}
        end
      elsif @options[:blog]
        if @options[:delete]
          {'annotations' => [{'type' => 'net.app.core.directory.blog'}]}
        else
          {'annotations' => [{
            'type' => 'net.app.core.directory.blog',
            'value' => {'url' => @text}}]}
        end
      elsif @options[:web]
        if @options[:delete]
          {'annotations' => [{'type' => 'net.app.core.directory.homepage'}]}
        else
          {'annotations' => [{
            'type' => 'net.app.core.directory.homepage',
            'value' => {'url' => @text}}]}
        end
      end
    end

  end
end
