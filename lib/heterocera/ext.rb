module HeteroceraArrayExtensions
  def to_path
    join("/")
  end
end

module HeteroceraStringExtensions
  def blank?
    empty?
  end

  def present?
    !blank?
  end
end

class Array
  include HeteroceraArrayExtensions
end

class String
  include HeteroceraStringExtensions
end