class MessagesViewController < UIViewController

  attr_accessor :campfire, :delegate

  def viewDidLoad
    view.backgroundColor = UIColor.scrollViewTexturedBackgroundColor
    view.addSubview(input)
    view.addSubview(table)
  end

  def viewWillAppear(animated)
    self.setToolbarItems([refresh_button], animated: true)
    self.navigationItem.title = "Fixalist"
    campfire.get_users(self)
  end

  def refresh_button
    @refresh_button ||= UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh, target: self, action: "refresh_messages")
  end

  # callback
  def refresh_messages
    campfire.get_users(self)
  end

  # callback
  def campfire_got_users
    campfire.get_messages(self)
  end

  # callback
  def campfire_got_messages
    table.reloadData
    scroll_to_bottom
  end

  def scroll_to_bottom(animated = true)
    scrollIndexPath = NSIndexPath.indexPathForRow(campfire.messages.size - 1, inSection: 0)
    table.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition:UITableViewScrollPositionBottom, animated: animated)
  end

  # callback
  def tableView(table, numberOfRowsInSection:section)
    campfire.messages.size
  end

  # callback
  def tableView(table, cellForRowAtIndexPath:indexPath)
    message = campfire.messages[indexPath.row]
    MessageCell.cellForMessage(message, inTableView: table)
  end

  # callback
  def tableView(table, heightForRowAtIndexPath:indexPath)
    message = campfire.messages[indexPath.row]
    MessageCell.height(message, table.frame.size.width)
  end

  # callback
  def textFieldShouldReturn(input)
    campfire.say(input.text)
    input.text = ''
    input.resignFirstResponder
  end

  # callback
  def reloadRowForMessage(message)
    row = campfire.messages.index(message)

    if row
      table.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

  # callback
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    input.resignFirstResponder
  end

  def input
    @input ||= UITextField.alloc.initWithFrame(CGRectMake(10, 10, view.size.width - 20, 31)).tap do |t|
      t.delegate        = self
      t.placeholder     = 'Type your message'
      t.borderStyle     = UITextBorderStyleRoundedRect
      t.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
      t.backgroundColor = UIColor.whiteColor
      t.font            = UIFont.systemFontOfSize(12)
    end
  end

  def table
    @table ||= UITableView.alloc.initWithFrame([[0, 50], [view.size.width, view.size.height - 50]], style: UITableViewStylePlain).tap do |t|
      t.delegate    = self
      t.dataSource  = self
    end
  end

end
