class Hash
  def to_key
    sort{ |a,b| a[0].to_s <=> b[0].to_s }.map{ |values| values.join('=') }.join
  end
end
