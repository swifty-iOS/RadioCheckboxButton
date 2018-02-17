Pod::Spec.new do |s|
  s.name         = "RadioCheckboxButton"
  s.version      = "0.2"
  s.summary      = "RadioCheckboxButton help you create Radio and Checkbox. It also help you group the Radio or Checkbox buttons"
  s.homepage     = "https://github.com/swifty-iOS/RadioCheckboxButton"
  s.license      = "MIT"
  s.author       = { "Swifty-iOS" => "manishej004@gmail.com" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/swifty-iOS/RadioCheckboxButton.git", :tag =>s.version }
  s.source_files  = "Source/BaseButton/*.*", "Source/RadioButton/*.*", "Source/CheckboxButton/*.*" 
end