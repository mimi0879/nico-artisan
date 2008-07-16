class Comment < ActiveRecord::Base
  belongs_to :art
  attr_accessor :time
  
  def time=(s)
    self.vpos = case s
                when /(\d+):(\d+\.\d+|\d+)/
                  ($1.to_i * 6000) + ($2.to_f * 100).to_i
                when /(\d+\.\d+|\d+)/
                  ($1.to_f * 100).to_i
                else
                  s.to_i
                end
  end

  def time
    return if vpos.nil?
    min = (vpos / 6000).to_i
    sec = (vpos / 100).to_i - (min * 60)
    dsec = vpos - ((vpos / 100).to_i * 100)
    sprintf("%d:%02d.%02d", min, sec, dsec)
  end
end
