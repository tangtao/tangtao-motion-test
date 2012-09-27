class TapController < UIViewController
  def viewDidLoad
    super

    @name_field = createNameField
    self.view.addSubview @name_field

    @phone_field = createPhoneField
    self.view.addSubview @phone_field

    @button = createButton
    @button.when(UIControlEventTouchUpInside) do
      UIApplication.sharedApplication.keyWindow.endEditing(true)
      success, errors = validInput(@name_field.text, @phone_field.text)
      if success
        @button.enabled = false
        info = {'name' => @name_field.text, 'phone' => @phone_field.text}
        ParseREST.save(info) do |status|
          @name_field.text = ""
          @phone_field.text = ""
          @button.enabled = true
        end
      else
        alert = UIAlertView.new
        alert.message = errors.join(", ")
        alert.addButtonWithTitle("OK")
        alert.show
      end
    end
    self.view.addSubview @button

    self.view.backgroundColor = UIColor.whiteColor
    self.title = "Submit"

    #close Keyboard when touch the backgroud
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self,
                                          :action => :handleSingleTap)
    self.view.addGestureRecognizer(singleFingerTap)

  end


  def handleSingleTap
    UIApplication.sharedApplication.keyWindow.endEditing(true)
  end

  private

  def validInput(name,phone)
    success = true
    errors = []

    if name.nil?
      success = false
      errors << "Name can't be blank"
    end

    if phone.nil?
      success = false
      errors << "Phone number can't be blank"
    else
      match = phone =~ /^[\d\-]+$/
      if match.nil?
        success = false
        errors << "Phone number include number and hyphen only"
      end
    end

    [success, errors]
  end

  def createNameField
    field = UITextField.alloc.initWithFrame [[0,0], [220, 30]]
    field.placeholder = "user name"
    field.textAlignment = UITextAlignmentCenter
    field.autocapitalizationType = UITextAutocapitalizationTypeNone
    field.borderStyle = UITextBorderStyleRoundedRect
    field.center = CGPointMake(self.view.frame.size.width / 2, 
                      self.view.frame.size.height / 2 - 100)

    field
  end

  def createPhoneField
    field = UITextField.alloc.initWithFrame [[0,0], [220, 30]]
    field.placeholder = "phone number"
    field.textAlignment = UITextAlignmentCenter
    field.autocapitalizationType = UITextAutocapitalizationTypeNone
    field.borderStyle = UITextBorderStyleRoundedRect
    field.center = CGPointMake(self.view.frame.size.width / 2, 
                       self.view.frame.size.height / 2 - 60)
    field.setKeyboardType(UIKeyboardTypeNumbersAndPunctuation)

    field
  end

  def createButton
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle("Submit", forState:UIControlStateNormal)
    button.setTitle("loading...", forState:UIControlStateDisabled)
    button.sizeToFit
    button.center = CGPointMake(self.view.frame.size.width / 2, 
                        self.view.frame.size.height / 2 - 0)

    button
  end

end
