require 'rexml/document'
require 'nicovideo-wayback-ext'
class Video < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  XML_ROOT = "#{RAILS_ROOT}/public/xml"
  has_many :chats, :dependent => :delete_all, :order => 'id desc'

  validates_uniqueness_of :vid, :url

  def update
    update_vid
    trim_title
  end

  def update_vid
    if url.to_s =~ /watch\/([^\/]+)/
      self.vid = $1
    end
  end

  def trim_title
    self.title = title.to_s.sub!(/‐ニコニコ動画\([^\)]+\)$/, '') if title
  end

  def dl_info(nv)
    nv.watch(vid) {|v|
      self.title = v.title
      self.tags = v.tags.join(' ')
      self.published_at = v.published_at
    }
    [trim_title, tags, published_at]
  end

  def dl_chats(nv, time=nil)
    nv.watch(vid) {|v|
      xml = v.comments(1000, time).to_xml
      File.open(xml_fullpath, "wb") {|f| f.write xml }
    }
  end

  def extract_chats
    File.open(xml_fullpath) do |xml|
      unique_ids = self.chats.collect{|c| c.no.to_s }
      new_chats = []
      doc = REXML::Document.new xml
      doc.elements.each("//packet/chat") do |el|
        next if unique_ids.include?(el.attributes["no"])
        new_chats << Chat.new(
          :video_id => self.id,
          :user_id => el.attributes["user_id"],
          :no => el.attributes["no"],
          :vpos => el.attributes["vpos"],
          :date => (el.attributes["date"].to_i > 0 ? Time.at(el.attributes["date"].to_i) : nil),
          :thread => el.attributes["thread"],
          :mail => el.attributes["mail"],
          :anonymity => el.attributes["anonymity"],
          :premium => el.attributes["premium"],
          :text => el.text
        )
      end
      new_chats.sort_by{|c| c.no}.each{|c| c.save}
    end
  end

  def iframe
    if vid and url
      %!<iframe width="312" height="176" src="http://ext.nicovideo.jp/thumb/#{vid}" scrolling="no" style="border:solid 1px #CCC;" frameborder="0"><a href="#{url}" target="_blank">【ニコニコ動画】#{title}</a></iframe>!
    else
      '<p>no vid and url</p>'
    end
  end

  def xml_path
    %!/xml/#{vid}.xml!
  end

  def xml_fullpath
    "#{XML_ROOT}/#{vid}.xml"
  end

  def xml_stat
    if File.exists?(xml_fullpath)
      s = File.stat(xml_fullpath)
      number_to_human_size(s.size) + ", " + s.mtime.to_s
    else
      'not found'
    end
  end
end
