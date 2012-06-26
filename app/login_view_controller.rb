class LoginViewController < UIViewController

  attr_accessor :delegate

  private

  def viewDidLoad
    self.navigationItem.title = "Sign in"

    button = UIBarButtonItem.alloc.initWithTitle("Sign in", style:UIBarButtonItemStyleDone, target: self, action: :log_in)
    navigationItem.rightBarButtonItem = button
    
    view.backgroundColor = UIColor.groupTableViewBackgroundColor

    view.addSubview username_text_field
    view.addSubview password_text_field
    view.addSubview subdomain_text_field
  end

  def username_text_field
    @username_text_field ||= default_text_field [[10, 50], [view.size.width - 20, 31]] do |f|
      f.placeholder     = "username"
    end
  end

  def password_text_field
    @password_text_field ||= default_text_field [[10, 90], [view.size.width - 20, 31]] do |f|
      f.placeholder     = "password"
      f.secureTextEntry = true
    end
  end

  def subdomain_text_field
    @subdomain_text_field ||= default_text_field [[10, 130], [view.size.width - 20, 31]] do |f|
      f.placeholder     = "subdomain"
      f.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    end
  end

  def log_in
    @campfire = Campfire.log_in(subdomain_text_field.text, username_text_field.text, password_text_field.text)
    if @campfire.valid?
      delegate.signed_in(@campfire)
    else
      App.alert("Cannot log in")
    end
  end

  def default_text_field(frame, &block)
    UITextField.alloc.initWithFrame(frame).tap do |f|
      f.borderStyle     = UITextBorderStyleRoundedRect
      f.backgroundColor = UIColor.whiteColor
      f.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
      block.call(f)
    end
  end

end
