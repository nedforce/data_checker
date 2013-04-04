require 'net/http'

class LinkChecker < DataChecker::Checker
  
  def apply subject
    checker_columns = subject.class.respond_to?(:checker_columns) ? Array.wrap(subject.class.checker_columns) : subject.class.columns.select{|column| column.type == :text }.map(&:name)
    checker_columns.each do |checker_column|
      subject.send(checker_column).to_s.tap do |content|
        next unless content.present?
        document = Nokogiri::XML.parse("<root>#{content}</root>")
        document.search('a[href]').each do |link|
          next if link[:href] =~ /mailto/
          
          http_status = 200
          http_message = 'OK'
          
          begin
            url = URI.parse(link[:href])
            http = Net::HTTP.new(url.host, url.port)
            
            if url.scheme == 'https' 
              http.use_ssl = true
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            end
              
            response = http.head(url.path.present? ? url.path : '/')
            http_status = response.code.to_i
            http_message = response.message
          rescue SocketError, Errno::ECONNREFUSED
            http_status = 404
            http_message = 'Not Found'
          rescue URI::InvalidURIError
            http_status = 400
            http_message = 'Invalid URI'          
          rescue Timeout::Error, Errno::ETIMEDOUT
            # Assume the page is temporarily unavailable
            http_status = 200            
          end
          
          if http_status >= 400
            message = I18n.t('data_checker.link_checker.message_template', subject: (subject.respond_to?(:to_label) ? subject.to_label : subject.to_s), field: subject.class.human_attribute_name(checker_column, default: checker_column), link: link[:href], http_status: http_status, http_message: http_message)
            warn(subject, 'invalid_link', message)
          end
          
        end
        
      end
    end
  end

end

