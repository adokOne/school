class Fixnum

  def wrap
    [self]
  end

  def to_bool
    return true if self == 1
    return false if self == 0
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def to_date
    Time.at(self).to_date
  end
end
