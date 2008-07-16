class Chat < ActiveRecord::Base
  belongs_to :video
  attr_accessor :query

  def self.search(params)
    c = Chat.new(params[:chat])
    c.video_id = params[:video_id] if params[:video_id]
    order = params[:order] || 'video_id,user_id,vpos'
    per_page = params[:per_page] || 100

    cond_ary = []
    cond_ary << ["video_id = ?", c.video_id] if c.video_id
    cond_ary << ["mail = ?", c.mail] if c.mail
    cond_ary << ["vpos = ?", c.vpos] if c.vpos
    cond_ary << ["(text like ? or mail like ? or user_id like ?)", "%#{c.query}%", "%#{c.query}%", "%#{c.query}%"] if c.query
    cond_ary << ["text like ?", "%#{c.text}%"] if c.text
    cond_ary << ["user_id like ?", "%#{c.user_id}%"] if c.user_id
    cond = cond_ary.map{|c| sanitize_sql(c)}.join(" and ")

    Chat.paginate(:conditions => cond, :page => params[:page], :per_page => per_page)
  end
end
