class Message < Model

  attr_accessor :id, :user_id, :type, :created_at, :starred, :body, :room_id, :user, :by_me

  def user_name
    if user
      user.name
    else
      "ONBEKEND"
    end
  end

  def avatar
    if user
      user.profile_image
    else
      nil
    end
  end

end
