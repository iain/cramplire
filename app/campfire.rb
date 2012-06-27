class Campfire < Model

  attr_accessor :subdomain, :username, :password, :delegate, :token

  def login
    get_response("https://#{username}:#{password}@#{subdomain}.campfirenow.com/users/me.json") do |response, data|
      if response.status_code.to_s == '200'
        self.token = data['user']['api_auth_token']
        delegate.campfire_login(true)
      else
        delegate.campfire_login(false)
      end
    end
  end

  private

  def get_response(url, &block)
    BubbleWrap::HTTP.get(url) do |response|
      if response.ok?
        data = BubbleWrap::JSON.parse(response.body.to_str)
        block.call(response, data)
      else
        block.call(response)
      end
    end
  end

  def url_with_token(path)
    "https://#{token}:X#{subdomain}.campfirenow.com/#{path}"
  end

end
