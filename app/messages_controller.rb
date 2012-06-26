class MessagesController < UIViewController

  def viewDidLoad
    self.navigationItem.title = "Fixalist"
    self.view = MessagesView.alloc.initWithFrame(view.frame)
  end

end
