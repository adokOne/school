class Array
  def to_h
    ret = {}
    self.each { |el| ret.merge! el.first => el.second }
    ret
  end
end