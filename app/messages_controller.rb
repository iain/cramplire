class MessagesController < UIViewController

  def viewDidLoad
    self.view = MessagesView.alloc.initWithFrame(view.frame)
  end

end
