require 'json'
require 'open-uri'
require 'rexml/document'
require 'sinatra'

get '/' do
  content_type :json
  count = params[:count] || 3
  
  urls = %w[http://nouveaushamanic.tumblr.com/rss http://nicolascageeatingthings.tumblr.com/rss http://gifolas-cage.tumblr.com/rss]
  images = []
  
  urls.each do |url|
    xml_string = open(url).read
    doc = REXML::Document.new(xml_string)
    doc.elements.first.elements.first.elements.each('item') do |item|
      html_string = CGI.unescapeHTML(item.elements['description'].get_text.to_s)
      image_url = html_string.scan(/src=\\?\"([a-z:\/0-9._-]+)\\?\"/i)
      images += image_url.flatten
    end
  end
  
  image_sample = images.sample(count.to_i)
  
  { count: image_sample.count, results: image_sample }.to_json
end
