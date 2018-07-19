module Players

class BasePlayer
  attr_reader :token

  def initialize(token)
    @token = token
  end
end

end
