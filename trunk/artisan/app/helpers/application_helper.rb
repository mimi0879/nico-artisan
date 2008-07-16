# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pre(text)
    '<pre>' + h(text).gsub(/[\r\n]/, "<br />\n") + '</pre>'
  end

  def nicolink(vid)
    thumbnail = vid.sub(/[a-z]+/, '')
    link_to h(vid)+"<br />\n<img src=\"http://tn-skr.smilevideo.jp/smile?i=#{h(thumbnail)}\" border=\"0\">", "http://www.nicovideo.jp/watch/#{h(vid)}"
  end

  def link_to_show_all(pages)
    link_to "show_all", :params => params.merge(:page => 1, :per_page => pages.total_entries)
  end
end
