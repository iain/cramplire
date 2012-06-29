class AppDelegate

  attr_accessor :campfire

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible
    true
  end

  def signed_in
    nav_controller.pushViewController(rooms_view_controller, animated: true)
  end

  def room_chosen(room)
    campfire.room_id = room.id

    nav_controller.pushViewController(messages_view_controller, animated: true)
  end

  private

  def nav_controller
    @nav_controller ||= UINavigationController.alloc.initWithRootViewController(login_view_controller).tap do |n|
      if campfire.signed_in?
        n.pushViewController(rooms_view_controller, animated: false)
      end
      if campfire.room_chosen?
        n.pushViewController(messages_view_controller, animated: false)
      end
    end
  end

  def campfire
    @campfire ||= Campfire.new
  end

  def messages_view_controller
    @messages_view_controller ||= MessagesViewController.alloc.init.tap do |t|
      t.delegate  = self
      t.campfire  = campfire
    end
  end

  def rooms_view_controller
    @rooms_view_controller ||= RoomsViewController.alloc.init.tap do |t|
      t.delegate  = self
      t.campfire  = campfire
    end
  end

  def login_view_controller
    @login_view_controller ||= LoginViewController.alloc.init.tap do |t|
      t.delegate  = self
      t.campfire  = campfire
    end
  end

end
