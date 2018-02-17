Pod::Spec.new do |s|
  s.name         = "MBCheckboxButton"
  s.version      = "1.0"
  s.summary      = "MBCheckboxButton help you create Checkbox button without single line of code. It also help you group the Checkbox buttons. It gives animation effect and customization."
  s.homepage     = "https://github.com/swifty-iOS/RadioCheckboxButton"
  s.license      = "MIT"
  s.author       = { "Swifty-iOS" => "manishej004@gmail.com" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/swifty-iOS/RadioCheckboxButton.git", :tag =>s.version }
  s.source_files  = "Source/BaseButton/*.*", "Source/CheckboxButton/*.*"
end