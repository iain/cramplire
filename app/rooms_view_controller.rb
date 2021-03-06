class RoomsViewController < UIViewController

  attr_accessor :campfire, :delegate

  def viewDidLoad
    view.addSubview(table)
  end

  def viewWillAppear(animated)
    self.navigationItem.title = 'Choose room'
    campfire.get_rooms(self)
  end

  # callback
  def campfire_got_rooms
    table.reloadData
  end

  # callback
  def tableView(tableView, numberOfRowsInSection:section)
    campfire.rooms.size
  end

  # callback
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    room = campfire.rooms[indexPath.row]
    RoomCell.cellForRoom(room, inTableView: table)
  end

  # callback
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    50
  end

  # callback
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    delegate.room_chosen(campfire.rooms[indexPath.row])
  end

  def table
    @table ||= UITableView.alloc.initWithFrame([[0, 0], [view.size.width, view.size.height]], style: UITableViewStyleGrouped).tap do |t|
      t.delegate    = self
      t.dataSource  = self
    end
  end

end
