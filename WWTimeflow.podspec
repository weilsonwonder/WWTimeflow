Pod::Spec.new do |s|
  s.name         = "WWTimeflow"
  s.version      = "1.0.1"
  s.summary      = "NSDate easy manipulator for comparison and changing dates."
  s.homepage     = "https://github.com/weilsonwonder/WWTimeflow"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Weilson Wonder" => "weilson@live.com" }
  s.social_media_url   = "https://sg.linkedin.com/in/weilson"

  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/weilsonwonder/WWTimeflow.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"

end
