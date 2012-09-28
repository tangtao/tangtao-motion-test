class Tap2Controller < UIViewController
  def viewDidLoad
    super
    @data = []
    bounds = self.view.bounds

    @table = createTableView(bounds)
    self.view.addSubview @table

    @button = createButton(bounds)
    self.view.addSubview @button

    @button.when(UIControlEventTouchUpInside) do
      @button.enabled = false

      ParseREST.list do |status, items|
        if status.to_i == 200
          @data = items
          @table.reloadData
        else
          alert = UIAlertView.new
          alert.message = "Get list Fail."
          alert.addButtonWithTitle("OK")
          alert.show
        end
        @button.enabled = true
      end
    end

    self.view.backgroundColor = UIColor.whiteColor
    self.title = "Display"
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.
        initWithStyle(UITableViewCellStyleDefault, 
                      reuseIdentifier:@reuseIdentifier)
    end

    cell.textLabel.text = @data[indexPath.row]["name"] + ' :   ' + 
                        @data[indexPath.row]["phone"]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.count
  end

  private

  def createTableView(bounds)
    table_bould = CGRectMake(bounds.origin.x, bounds.origin.y, 
        bounds.size.width, bounds.size.height - 100)
    table = UITableView.alloc.initWithFrame(table_bould)
    table.dataSource = self
    table
  end

  def createButton(bounds)
    button_bould = CGRectMake(bounds.origin.x + 10, 
                      bounds.origin.y + bounds.size.height - 100 + 5, 
                      bounds.size.width - 20, 40)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setFrame(button_bould)

    button.setTitle("Retrive", forState:UIControlStateNormal)
    button.setTitle("Loading...", forState:UIControlStateDisabled)

    button
  end

end
