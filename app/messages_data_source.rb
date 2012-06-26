class MessagesDataSource

  API_KEY = ''
  ROOM_ID = ''
  URL     = ''

  attr_accessor :messages, :users, :tableView

  def initialize(tableView)
    @tableView = tableView
    get_users
  end

  def messages
    @messages ||= []
  end

  def users
    @users ||= []
  end

  def tableView(tableView, numberOfRowsInSection:section)
    messages.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    message = messages[indexPath.row]
    MessageCell.cellForMessage(message, inTableView: tableView)
  end

  def get_users
    getURL "/room/#{ROOM_ID}.json" do |hash|
      hash["room"]["users"].each do |user|
        users << User.new(user)
      end
      get_messages
    end
  end

  def get_messages
    getURL "/room/#{ROOM_ID}/recent.json" do |hash|
      hash["messages"].each do |dict|
        if dict["type"] == "TextMessage"
          message = Message.new(dict)
          message.user = users.find { |user| user.id == message.user_id }
          messages << message
        end
      end
      scrollDown
    end
  end

  def scrollDown
    tableView.reloadData
    ipath = NSIndexPath.indexPathForRow(messages.size - 1, inSection: 0)
    tableView.scrollToRowAtIndexPath(ipath, atScrollPosition: UITableViewScrollPositionTop, animated: false)
  end

  def auth
    "#{API_KEY}:X"
  end

  def getURL(path, &block)
    BubbleWrap::HTTP.get("https://#{auth}@#{URL}#{path}") do |response|
      hash = BubbleWrap::JSON.parse(response.body.to_str)
      block.call(hash)
    end
  end

  def reloadRowForMessage(message)
    row = messages.index(message)
    if row
      tableView.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

end
