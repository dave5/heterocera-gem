require 'json'
require 'uri'
require 'mechanize'

require 'heterocera/ext'

module Heterocera

  class Client

    READ  = "read"
    WRITE = "write"
    TAKE  = "take"

    # get .json for free
    XML   = ".xml"
    GZ    = ".gz"
    HTML  = ".html"
    
    OTHER_SUFFIXES = [XML, GZ, HTML]

    def initialize server_address
      @base_address = URI.parse server_address
      @agent        = Mechanize.new
    end

    def server_address 
      @base_address
    end

    def server_address= server_address
      @base_address = URI.parse server_address
    end

    def read(tags = [], suffix = "")
      resp = get(READ, tags, "", suffix).body

      case suffix
      when XML
        resp
      when GZ
        resp
      else
        JSON.parse(resp)
      end

    end

    def write(tags = [], value = "")
      raise ArgumentError, 'You must provide a String or a File'  unless value.class == String || value.class == File
      raise ArgumentError, "You can't use wildcards when writing" if tags.include? '*'

      case value.class.to_s 
      when "String"
        if value.bytesize < 1024
          resp = get(WRITE, tags, value).body
        else
          resp = post(WRITE, tags, value).body
        end
      when "File"
        raise TypeError, 'Please open files in binary mode' unless value.binmode?
        resp = post(WRITE, tags, value).body
      end

      JSON.parse resp
    end

    def take(guid)
      resp = get(TAKE, [guid])
      resp.code == "200"
    end

    private

      def generate_url tuple_space_operation, tags
        raise ArgumentError, "You must provide an array of tags ['foo', 'baa']" if tags.length == 0

        "http://#{@base_address.host}:#{@base_address.port}/#{tuple_space_operation}/#{tags.to_path}"
      end

      def get tuple_space_operation, tags, value = "", suffix = ""
        raise ArgumentError, 'You must provide a value' if value.blank? && tuple_space_operation == WRITE

        request = generate_url tuple_space_operation, tags

        if (suffix.present? && OTHER_SUFFIXES.include?(suffix))
          request << suffix 
        elsif value.present?
          request << "?value=#{value}" 
        end

        @agent.get request
      end

      def post tuple_space_operation, tags, value = ""
        raise TypeError, 'You must provide a value' unless value.present?

        request = generate_url tuple_space_operation, tags
        @agent.post(request, {"value" => value})

      end
  end

end
