#KwiksSystemsAlerts

Pod::Spec.new do |s|
  s.name             = 'KwiksSystemsAlerts'
  s.version          = '0.1.2'
  s.summary          = 'KwiksSystemsAlerts was designed to handle all internal full screen style blockers in the Kwiks iOS Application.'

  s.description      = <<-DESC
  'KwiksSystemsAlerts was designed to help support light frontend and easy code management solutions. The goal of this pod is to provide a one liner full screen blocker that switches the BlockerType enum.'
                       DESC

  s.homepage         = 'https://github.com/KWIKSCTO/KwiksSystemsAlerts'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'KWIKS CTO' => 'charlie@kwiks.com' }
  s.source           = { :git => 'https://github.com/NoImpactNoIdea/KwiksSystemsAlerts.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_versions = "5.0"
  s.requires_arc = true

  s.source_files = 'KwiksSystemsAlerts/Classes/**/*'
  s.resources = 'KwiksSystemsAlerts/**/*.{lproj,storyboard,xcdatamodeld,xib,xcassets,json,ttf,otf}'
  s.frameworks = 'UIKit'
   
end
