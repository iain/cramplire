class LoginViewController < UIViewController

  attr_accessor :delegate, :campfire

  def viewDidLoad
    self.navigationItem.title = "Sign in"

    navigationItem.rightBarButtonItem = sign_in_button

    view.backgroundColor = UIColor.scrollViewTexturedBackgroundColor

    view.addSubview username_text_field
    view.addSubview password_text_field
    view.addSubview subdomain_text_field
  end

  def handle_sign_in_pressed
    campfire.subdomain = subdomain_text_field.text
    campfire.username  = username_text_field.text
    campfire.password  = password_text_field.text

    campfire.get_api_token(self)
  end

  def sign_in_button
    @sign_in_button ||= UIBarButtonItem.alloc.initWithTitle("Sign in", style:UIBarButtonItemStyleDone, target: self, action: :handle_sign_in_pressed)
  end

  def campfire_got_api_token(valid)
    if valid
      delegate.signed_in
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

  private

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

end
