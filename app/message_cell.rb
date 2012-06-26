class MessageCell < UITableViewCell
  MessageFontSize = 14

  def self.cellForMessage(message, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(message.id) || alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:message.id)
    cell.fillWithMessage(message, inTableView:tableView)
    cell
  end

  def fillWithMessage(message, inTableView:tableView)
    self.textLabel.text = "#{message.user_name} said:"
    self.detailTextLabel.text = "#{message.body}"

    return unless message.user

    unless message.user.profile_image
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        profile_image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(message.user.avatar_url))
        if profile_image_data
          message.user.profile_image = UIImage.alloc.initWithData(profile_image_data)
          Dispatch::Queue.main.sync do
            self.imageView.image = message.user.profile_image
            tableView.dataSource.reloadRowForMessage(message)
          end
        end
      end
    else
      self.imageView.image = message.user.profile_image
    end
  end

  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.detailTextLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end

end
