Pod::Spec.new do |s|
s.name         = "FGSwiftUIImage"
s.version      = "1.0.0"
s.summary      = "FGSwiftUIImage is a SwiftUI web image"
s.homepage     = "https://github.com/Insfgg99x/FGSwiftUIImage"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.authors      = { "CGPointZero" => "newbox0512@yahoo.com" }
s.source       = { :git => "https://github.com/Insfgg99x/FGSwiftUIImage.git", :tag => "1.0.0"}
s.swift_version = "5.0"
s.ios.deployment_target = '13.0'
s.tvos.deployment_target = "13.0"
s.osx.deployment_target = "10.15"
s.watchos.deployment_target = "6.0"
s.source_files = ["FGSwiftUIImage/FGSwiftUIImage.swift"]
s.requires_arc = true
end

