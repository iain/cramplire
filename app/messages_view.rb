class MessagesView < UIView

  attr_accessor :label

  def initWithFrame(frame)
    if super
      @label = UITextView.alloc.initWithFrame(CGRectMake(0, 0, self.frame.size.width, 50))
      @label.delegate = self
      @label.text = "This is the text"

      table.delegate = table_view_delegate
      table.dataSource = data_source

      addSubview(@label)
      addSubview(table)
    end
    self
  end

  def table_view_delegate
    @table_view_delegate ||= MessagesViewDelegate.new(table)
  end

  def data_source
    @data_source ||= MessagesDataSource.new(table)
  end

  def table
    @table ||= UITableView.alloc.initWithFrame([[0, 50], [self.frame.size.width, self.frame.size.height - 50]], style: UITableViewStylePlain)
  end

end
