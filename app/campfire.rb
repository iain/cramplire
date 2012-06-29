class Campfire < Model

  attr_accessor :username, :password, :users, :messages, :rooms

  def users
    @users ||= []
  end

  def messages
    @messages ||= []
  end

  def rooms
    @rooms ||= []
  end

  def signed_in?
    api_token && subdomain && user_id
  end

  def get_api_token(delegate)
    get_response("https://#{username}:#{password}@#{subdomain}.campfirenow.com/users/me.json") do |response, data|
      if response.status_code.to_s == '200'
        p data
        self.api_token = data['user']['api_auth_token']
        self.user_id = data['user']['id']
        delegate.campfire_got_api_token(true)
      else
        delegate.campfire_got_api_token(false)
      end
    end
  end

  def api_token
    @api_token ||= get(:api_token)
  end

  def api_token=(token)
    @api_token = set(:api_token, token)
  end

  def subdomain
    @subdomain ||= get(:subdomain)
  end

  def subdomain=(subdomain)
    @subdomain = set(:subdomain, subdomain)
  end

  def user_id
    @user_id ||= get(:user_id)
  end

  def user_id=(id)
    @user_id = set(:user_id, id)
  end

  def room_id
    @room_id ||= get(:room_id)
  end

  def room_id=(id)
    @room_id = set(:room_id, id)
    self.room_name = rooms.find { |r| r.id.to_s == id.to_s }.name
  end

  def room_name
    @room_name ||= get(:room_id)
  end

  def room_name=(id)
    @room_name = set(:room_id, id)
  end

  def room_chosen?
    room_id && room_name
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
        all_received_messages = build_messages(data['messages'])
        existing_message_ids = messages.map(&:id)
        new_messages = all_received_messages.reject do |m|
          existing_message_ids.include?(m.id)
        end
        self.messages += new_messages
        if new_messages.any?
          delegate.campfire_got_messages(existing_message_ids.any?)
        end
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

  def say(message)
    data = BubbleWrap::JSON.generate({ message: { body: message }})
    BubbleWrap::HTTP.post(url_with_token("room/#{room_id}/speak.json"), payload: data, headers: { 'Content-Type' => 'application/json'})
  end

  private

  def build_messages(data)
    data.map do |hash|
      if hash['type'] == 'TextMessage'
        message = Message.new(hash)
        message.user = users.find { |user| user.id == message.user_id }
        message.by_me = (self.user_id.to_s == message.user_id.to_s)
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

  def get(field)
    value = App.user_cache.stringForKey(field.to_s)
    value = nil if value == ""
    value
  end

  def set(field, value)
    App.user_cache.setObject(value, forKey: field.to_s)
    value
  end

end
