module HeteroceraArrayExtensions
  def to_path
    join("/")
  end
end

class Array
  include HeteroceraArrayExtensions
end