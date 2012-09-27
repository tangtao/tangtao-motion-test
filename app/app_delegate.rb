class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    tab_controller = UITabBarController.alloc.
        initWithNibName(nil, bundle: nil)

    t1_controller = TapController.alloc.initWithNibName(nil, bundle: nil)
    t2_controller = Tap2Controller.alloc.initWithNibName(nil, bundle: nil)

    tab_controller.viewControllers = [t1_controller, t2_controller]
    @window.rootViewController = tab_controller
    true
  end
end
