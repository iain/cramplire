class MessagesViewController < UIViewController

  attr_accessor :campfire, :delegate

  def viewDidLoad
    self.navigationItem.title = "Fixalist"

    view.addSubview(label)
    view.addSubview(table)

    campfire.get_users(self)
  end

  # callback
  def campfire_got_users
    campfire.get_messages(self)
  end

  # callback
  def campfire_got_messages
    table.reloadData
    ipath = NSIndexPath.indexPathForRow(campfire.messages.size - 1, inSection: 0)
    table.scrollToRowAtIndexPath(ipath, atScrollPosition: UITableViewScrollPositionTop, animated: false)
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
    100
  end

  # callback
  def reloadRowForMessage(message)
    row = campfire.messages.index(message)

    if row
      table.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

  def label
    @label ||= UITextView.alloc.initWithFrame(CGRectMake(0, 0, view.size.width, 50)).tap do |t|
      t.delegate    = self
      t.text        = 'Type your message'
    end
  end

  def table
    @table ||= UITableView.alloc.initWithFrame([[0, 50], [view.size.width, view.size.height - 50]], style: UITableViewStylePlain).tap do |t|
      t.delegate    = self
      t.dataSource  = self
    end
  end

end
