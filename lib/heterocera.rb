require "heterocera/version"
require 'json'
require 'uri'
require 'mechanize'

module HeteroceraArrayExtensions
  def to_path
    join("/")
  end
end

class Array
  include HeteroceraArrayExtensions
end

module Heterocera

  class Client

    READ = "read"
    WRTE = "write"
    TAKE = "take"

    def initialize server_address
      @base_address = URI.parse server_address
      @agent = Mechanize.new
    end

    def read(tags = [])
      resp = @agent.get request(READ, tags)
      JSON.parse(resp.body)
    end

    # def read_with_compression(tags = [])
    # end

    # def write(tags = [], value)
    # end

    # def write_json(tags = [], json)
    # end

    # def write_file(tags = [], path_to_file)
    # end

    # def take(guid)
    # end

    private

      def request tuple_space_operation, tags
        "http://#{@base_address.host}:#{@base_address.port}/#{tuple_space_operation}/#{tags.to_path}"
      end
  end

end
