require 'nicovideo-post-ext'
require 'csv'

class Art < ActiveRecord::Base
  has_many :comments, :order => "vpos, id"
  belongs_to :video
  attr_accessor :vid, :chats, :nv

  def vid
    self.video.vid if self.video
  end

  def vid=(s)
    self.video = Video.find_by_vid(s)
  end

  def chats=(ids)
    Chat.find(:all, :conditions => ["id in (?)", ids]).each do |c|
      Comment.create(
        :art_id => self.id,
        :vpos => c.vpos,
        :command => c.mail.sub(/\s*184/, ''),
        :text => c.text
      )
    end
  end

  def create_comments_from_csv(csv)
    CSV.parse(csv).each do |line|
      Comment.create(
        :art_id => self.id,
        :time => line[0],
        :command => line[1],
        :text => line[2]
      )
    end
  end

  def create_comments_from_memo
    create_comments_from_csv(memo)
  end

  def nicopost(post_vid, time=nil)
    nv ||= Account.nv
    nv.watch(post_vid) do |v|
      comments.each do |c|
        vpos = time.blank? ? c.vpos / 100.0 : time
        body, result_xml = v.post(:time => vpos, :command => c.command, :comment => c.text)
        History.create(
          :art_id => self.id,
          :comment_id => c.id,
          :vid => post_vid,
          :vpos => time.to_s,
          :xml => body,
          :result => result_xml
        )
        sleep 3
      end
    end
  end
end
