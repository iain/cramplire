class RoomCell < UITableViewCell

  MessageFontSize = 14

  def self.cellForRoom(room, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(room.id) || alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:room.id)
    cell.fillWithRoom(room, inTableView:tableView)
    cell
  end

  def fillWithRoom(room, inTableView:tableView)
    self.selectionStyle = UITableViewCellSelectionStyleGray
    self.textLabel.text = room.name
    self.detailTextLabel.text = room.topic
  end

  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.detailTextLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end

end
