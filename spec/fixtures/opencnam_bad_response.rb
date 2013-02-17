class OpencnamBadResponse < Net::HTTPBadRequest
  def body
    ''
  end

  def initialize
  end

  def message
    'Bad request'
  end
end
