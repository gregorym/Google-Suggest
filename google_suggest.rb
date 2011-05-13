require 'rubygems'
require 'hpricot'
require 'open-uri'

module GoogleSuggest

  URL = "http://www.google.com/complete/search"
 
  def self.search(search, lang, depth)
    suggestions = []
    suggestions << search
    1.upto(depth) do
      tmp = []
      suggestions.each do |s|
        s = URI.escape(s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        url = "#{URL}?qu=#{s}&hl=#{lang}&xml=true"
        page = Hpricot(open(url))
        doc = Hpricot.parse(page.to_s)
        (doc/:completesuggestion).each {|resp| tmp << (resp/:suggestion).first[:data] };nil
      end
      suggestions << tmp
      suggestions.flatten!
      suggestions.uniq!
    end
    return suggestions        
  end
end
