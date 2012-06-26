class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible
    true
  end

  def nav_controller
    @nav_controller ||= UINavigationController.alloc.initWithRootViewController(login_view_controller)
  end

  def login_view_controller
    @login_view_controller ||= LoginViewController.alloc.init.tap do |l|
      l.delegate = self
    end
  end

  def signed_in(campfire)
    nav_controller.pushViewController(messages_controller, animated: true)
  end

  def messages_controller
    MessagesController.alloc.init
  end

end
