require 'json'
require 'uri'
require 'mechanize'

require 'heterocera/ext'

module Heterocera

  class Client

    READ = "read"
    WRITE = "write"
    TAKE = "take"

    XML_EXT   = ".xml"
    GZ_EXT    = ".gz"
    HTML_EXT  = ".html"
    JSON_EXT  = ".json"

    ACCEPTED_SUFFIXES = [XML_EXT, GZ_EXT, HTML_EXT, JSON_EXT]

    def initialize server_address
      @base_address = URI.parse server_address
      @agent = Mechanize.new
    end

    def read(tags = [], suffix = JSON_EXT)
      resp = @agent.get get(READ, tags, suffix)
      case suffix
      when JSON_EXT
        JSON.parse(resp.body)
      when XML_EXT
      when GZ_EXT
      else
        resp.body
      end
    end

    def write(tags = [], value = "")
      resp = @agent.get "#{get(WRITE, tags)}?value=#{value}"
      JSON.parse(resp.body)
    end

    # def write_post_data(tags = [], json)
    # end

    # def write_file(tags = [], path_to_file)
    # end

    # def take(guid)
    # end

    private

      def get tuple_space_operation, tags, suffix = ""
        request = "http://#{@base_address.host}:#{@base_address.port}/#{tuple_space_operation}/#{tags.to_path}"
        request << suffix if (suffix.present? && ACCEPTED_SUFFIXES.include?(suffix))

        request
      end
  end

end
