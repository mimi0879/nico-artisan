# file: mechanize-ext.rb
require 'mechanize'

module WWW
  class Mechanize
    self.class_eval {
      def post_data(url, data='', enctype=nil)
        cur_page = current_page || Page.new( nil, {'content-type'=>'text/html'})
        request_data = data
        abs_url = to_absolute_uri(url, cur_page)
        request = fetch_request(abs_url, :post)
        request.add_field('Content-Length', request_data.size.to_s)
        
        page = fetch_page(abs_url, request, cur_page, [request_data])
        add_to_history(page)
        page
      end

      class File
        def path
          return @uri.path
        end
      end
    }
  end
end
