# file: nicovideo-wayback-ext.rb
# 過去ログ取得
require 'rubygems'
require 'nicovideo'
require 'yaml'
require 'rexml/document'

module Nicovideo
  class VideoPage < Page
    def comments(num=500, time=nil)
      puts_info 'getting comment xml : id = ' + @video_id
      begin
        @params = get_params unless @params
        thread_id = @params['thread_id']
        body = %!<thread res_from="-#{num}" version="20061206" thread="#{thread_id}"/>!

        if time
          # 過去ログ
          time = Time.parse(time) if time.is_a?(String) rescue nil
          raise ArgError, "malformed time: #{time}" unless time
          raise ArgError, "not premium user!" unless @params['is_premium'] == "1"
          content = @agent.get_file(BASE_URL + '/api/getwaybackkey?thread=' + thread_id)
          puts_debug content
          @params.merge!(content.scan(/([^&]+)=([^&]*)/).inject({}){|h, v| h[v[0]] = v[1]; h})
          raise ArgError, "no waybackkey: #{content}" unless @params.key?('waybackkey')
          body.sub!(%r{(?=/>)}, {
            :user_id => @params['user_id'],
            :when => time.to_i,
            :waybackkey => @params['waybackkey']
          }.map{|k,v| %! #{k}="#{v}"!}.join)
        end

        puts_info "body : " + body
        post_url = CGI.unescape(@params['ms'])
        comment_xml = @agent.post_data(post_url, body).body
        puts_debug comment_xml
        Comments.new(@video_id, comment_xml)
      end
    end
  end
end
