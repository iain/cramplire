class AppDelegate

  attr_accessor :campfire

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible
    true
  end

  def signed_in
    nav_controller.pushViewController(messages_controller, animated: true)
  end

  private

  def nav_controller
    @nav_controller ||= UINavigationController.alloc.initWithRootViewController(login_view_controller)
  end

  def campfire
    @campfire ||= Campfire.new(room_id: '')
  end

  def messages_controller
    @messages_controller ||= MessagesViewController.alloc.init.tap do |m|
      m.delegate  = self
      m.campfire  = campfire
    end
  end

  def login_view_controller
    @login_view_controller ||= LoginViewController.alloc.init.tap do |l|
      l.delegate  = self
      l.campfire  = campfire
    end
  end

end
