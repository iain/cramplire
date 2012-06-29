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

  def scroll_to_bottom(animated = false)
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
    @input ||= UITextField.alloc.initWithFrame([[10, input_top], [view.size.width - 20, 31]]).tap do |t|
      t.delegate        = self
      t.placeholder     = 'Type your message'
      t.borderStyle     = UITextBorderStyleRoundedRect
      t.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
      t.backgroundColor = UIColor.whiteColor
      t.font            = UIFont.systemFontOfSize(12)
    end
  end

  def table
    @table ||= UITableView.alloc.initWithFrame([[0, 0], [view.size.width, table_height]], style: UITableViewStylePlain).tap do |t|
      t.delegate    = self
      t.dataSource  = self
    end
  end

  def table_height
    view.size.height - 137
  end

  def input_top
    table_height + 10
  end

  KEYBOARD_ANIMATION_DURATION = 0.3
  MINIMUM_SCROLL_FRACTION     = 0.2
  MAXIMUM_SCROLL_FRACTION     = 0.8
  PORTRAIT_KEYBOARD_HEIGHT    = 216
  LANDSCAPE_KEYBOARD_HEIGHT   = 162

  def textFieldDidBeginEditing(textField)
    textFieldRect = view.window.convertRect(textField.bounds, fromView: textField)
    viewRect = view.window.convertRect(view.bounds, fromView: view)

    midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
    numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height
    denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height
    heightFraction = numerator / denominator

    if (heightFraction < 0.0)
      heightFraction = 0.0
    elsif (heightFraction > 1.0)
      heightFraction = 1.0
    end

    orientation = UIApplication.sharedApplication.statusBarOrientation
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
      @animatedDistance = (PORTRAIT_KEYBOARD_HEIGHT * heightFraction).floor
    else
      @animatedDistance = (LANDSCAPE_KEYBOARD_HEIGHT * heightFraction).floor
    end

    viewFrame = self.view.frame
    viewFrame.origin.y -= @animatedDistance

    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(KEYBOARD_ANIMATION_DURATION)

    view.setFrame(viewFrame)

    UIView.commitAnimations
  end

  def textFieldDidEndEditing(textField)
    viewFrame = self.view.frame
    viewFrame.origin.y += @animatedDistance

    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(KEYBOARD_ANIMATION_DURATION)

    view.setFrame(viewFrame)

    UIView.commitAnimations
  end

end
