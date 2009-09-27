require 'lib/wtf_constants'
require 'rubygems' # This feels wrong to require here ...
require 'hpricot'
require 'open-uri'

module WTF
  class PageGenerator
    attr_accessor :wtf_page

    SCRAPE_TYPES = [ 
      'input', 
      'select', 
      'a' 
    ] unless defined?(SCRAPE_TYPES)

    ##
    # PageGenerator.scrape('source.html')
    #
    def initialize
      @wtf_page = nil
    end

    ##
    #
    #
    def self.scrape(input, outputfile = nil)
      if File.exists?(input) then
        # local file condition
        doc = Hpricot(open(input))
      elsif #something # is a url
        # url condition
        doc = Hpricot(open(input))
      else
        # error cond
      end
      @wtf_page = {}
      @wtf_page['mappings'] = {}
      SCRAPE_TYPES.each do |type|
        #puts "type = #{type}"
        @wtf_page[type] = {}
        i = 1
        doc.search("//#{type}").each do |elem|
          #puts "elem = #{elem}"
          @wtf_page[type]["#{type}_#{i}"] = {}
          @wtf_page[type]["#{type}_#{i}"]['xpath'] = elem.xpath
          guess = elem.xpath.match(/@id='(.*)'/) ? [$1] : []
          if !guess.empty? && guess.first.match(/(.*)___(.*)$/) then guess = [$2] end
          @wtf_page['mappings']["#{type}_#{i}"] = guess # Add to mappings
          i += 1;
        end
      end

      @wtf_page['mappings']['instructions'] = mapping_instructions

      if outputfile then 
        File.open(outputfile, 'w') { |f| f << YAML.dump(@wtf_page) }
      else
        STDOUT << YAML.dump(@wtf_page)
      end
    end

    def self.mapping_instructions
      %Q(
This section of the page yaml is meant for identifying HTML entities of interest, for local canonicalization.
)
    end

    def post_processing
      # Comment the mappings field as a post-processing task
    end

  end # PageGenerator
end # WTF
