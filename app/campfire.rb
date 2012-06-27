class Campfire < Model

  attr_accessor :subdomain, :username, :password,
                :api_token, :users, :messages, :room_id,
                :rooms

  def users
    @users ||= []
  end

  def messages
    @messages ||= []
  end

  def rooms
    @rooms ||= []
  end

  def get_api_token(delegate)
    get_response("https://#{username}:#{password}@#{subdomain}.campfirenow.com/users/me.json") do |response, data|
      if response.status_code.to_s == '200'
        self.api_token = data['user']['api_auth_token']
        delegate.campfire_got_api_token(true)
      else
        delegate.campfire_got_api_token(false)
      end
    end
  end

  def get_users(delegate)
    get_response(url_with_token("room/#{room_id}.json")) do |response, data|
      if response.ok?
        self.users = data['room']['users'].map { |u| User.new(u) }
        delegate.campfire_got_users
      end
    end
  end

  def get_messages(delegate)
    get_response(url_with_token("room/#{room_id}/recent.json")) do |response, data|
      if response.ok?
        self.messages = build_messages(data['messages'])
        delegate.campfire_got_messages
      end
    end
  end

  def get_rooms(delegate)
    get_response(url_with_token("rooms.json")) do |response, data|
      if response.ok?
        self.rooms = build_rooms(data['rooms'])
        delegate.campfire_got_rooms
      end
    end
  end

  private

  def build_messages(data)
    data.map do |hash|
      if hash['type'] == 'TextMessage'
        message = Message.new(hash)
        message.user = users.find { |user| user.id == message.user_id }
        message
      end
    end.compact
  end

  def build_rooms(data)
    data.map do |hash|
      Room.new(hash)
    end
  end

  def get_response(url, &block)
    puts "Getting #{url}..."

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
    "https://#{api_token}:X@#{subdomain}.campfirenow.com/#{path}"
  end

end
