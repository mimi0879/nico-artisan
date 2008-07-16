# file: nicovideo-post-ext.rb
# this is an extension for the nicovideo gem to enable comment posting via ruby scripts.
require 'rubygems'
require 'nicovideo'
require 'yaml'
require 'rexml/document'

module Nicovideo
  class VideoPage < Page
    # post(:comment => "comment", :time => "2:01.24", :command => "sage small pink")
    def post(*args)
      args = args.first if args.first.is_a?(Hash)
      time = args[:time].to_s
      command = args[:command].to_s + " 184" # always anonymous :)
      comment = args[:comment].to_s

      begin
        @params = get_params unless @params

        # getpostkey
        content = @agent.get_file(BASE_URL + "/api/getpostkey?thread=#{@params['thread_id']}&block_no=0")
        @params.merge!(content.scan(/([^&]+)=([^&]*)/).inject({}){|h, v| h[v[0]] = v[1]; h})
        raise "no postkey (#{content})" unless @params.key?('postkey')

        doc = REXML::Document.new self.comments(1).to_xml
        ticket_id = doc.elements["//packet/thread"].attributes["ticket"]
        post_url = CGI.unescape(@params['ms'])

        vpos = case time
               when /(\d+):(\d+\.\d+|\d+)/
                 ($1.to_i * 6000) + ($2.to_f * 100).to_i
               when /(\d+\.\d+|\d+)/
                 ($1.to_f * 100).to_i
               end

        body = "<chat"+ {
                 :premium => @params['is_premium'],
                 :postkey => @params['postkey'],
                 :user_id => @params['user_id'],
                 :ticket  => ticket_id,
                 :mail    => command,
                 :vpos    => vpos,
                 :thread  => @params['thread_id']
               }.map{|k,v| " #{k}=\"#{v}\"" }.join + ">#{comment}</chat>"

        info = ["posting comment : "]
        info << "  id = " + @video_id
        info << "  time = " + time
        info << "  command = " + command
        info << "  comment = " + comment
        info << "  post url = " + post_url
        info << "  post body = " + body
        puts_info info.join("\n")

        result_xml = @agent.post_data(post_url, body).body
        puts_info "result = " + result_xml
        [body, result_xml]
      end
    end
  end
end

=begin usage sample (as in sample/nv_post_comment.rb)

  require '../lib/nicovideo-post-ext'
  Nicovideo::Page::NV_DEBUG_LEVEL = 2

  # ex) ruby nv_post_comment.rb "sm9" "2:01.24" "wwwwwwwwww" "sage white"
  video_id, time, comment, command = ARGV

  # set account
  account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
  mail = account['mail']
  password = account['password']

  # create instance
  nv = Nicovideo.new(mail, password)

  # post comment
  nv.watch(video_id) {|v|
    v.post(:comment => comment, :time => time, :command => command)
  }

=end usage sample
