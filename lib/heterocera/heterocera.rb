require 'json'
require 'uri'
require 'mechanize'

require 'heterocera/ext'

module Heterocera

  class Client

    READ  = "read"
    WRITE = "write"
    TAKE  = "take"

    XML_EXT   = ".xml"
    GZ_EXT    = ".gz"
    HTML_EXT  = ".html"
    JSON_EXT  = ".json"

    ACCEPTED_SUFFIXES = [XML_EXT, GZ_EXT, HTML_EXT, JSON_EXT]

    def initialize server_address
      @base_address = URI.parse server_address
      @agent        = Mechanize.new

      true
    end

    def server_address 
      @base_address
    end

    def server_address= server_address
      @base_address = URI.parse server_address
    end

    def read(tags = [], suffix = "")
      resp = get(READ, tags, suffix).body

      case suffix
      when JSON_EXT
        resp   
      when XML_EXT
        resp
      when GZ_EXT
        # get response
        # pass back temp file
      else
        JSON.parse(resp)
      end

    end

    def write(tags = [], value = "")
      if value.class == String
        if value.bytesize < 1024
          resp = get(WRITE, tags, value).body
        else
          resp = post(WRITE, tags, value).body
        end
      else
        resp = post(WRITE, tags, value).body
      end

      JSON.parse resp
    end

    # def write_file(tags = [], path_to_file)
    # end

    def take(guid)
      resp = get(TAKE, [guid])
      resp.code == "200"
    end

    private

      def generate_url tuple_space_operation, tags
        "http://#{@base_address.host}:#{@base_address.port}/#{tuple_space_operation}/#{tags.to_path}"
      end

      def get tuple_space_operation, tags, value = "", suffix = ""
        request = generate_url tuple_space_operation, tags

        if (suffix.present? && ACCEPTED_SUFFIXES.include?(suffix))
          request << suffix 
        elsif value.present?
          request << "?value=#{value}" 
        end

        @agent.get request
      end

      def post tuple_space_operation, tags, value = ""
        request = generate_url tuple_space_operation, tags
      
        @agent.post(request, {"value" => value})
      end
  end

end
