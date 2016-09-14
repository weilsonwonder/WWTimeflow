Pod::Spec.new do |s|
  s.name         = "WWTimeflow"
  s.version      = "2.0.0"
  s.summary      = "NSDate easy manipulator for comparison and changing dates."
  s.homepage     = "https://github.com/weilsonwonder/WWTimeflow"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Weilson Wonder" => "weilson@live.com" }

  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/weilsonwonder/WWTimeflow.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"

end
