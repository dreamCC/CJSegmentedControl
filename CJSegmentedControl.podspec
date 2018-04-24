
Pod::Spec.new do |s|

  s.name         = "CJSegmentedControl"
  s.version      = "1.0.0"
  s.summary      = "A short description of CJSegmentedControl."

  s.homepage     = "https://github.com/dreamCC/CJSegmentedControl"

  s.license      = "MIT"


  s.author       = { "dreamCC" => "568644031@qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dreamCC/CJSegmentedControl.git", :tag => s.version}

  s.source_files = "CJSegmentedControl/*.{h,m}"

  s.requires_arc = true

end
