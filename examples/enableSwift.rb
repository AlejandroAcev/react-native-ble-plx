require 'xcodeproj'

project_path = "Setup/ios/"

File.open("#{project_path}/File.swift", 'w') { |file| 
file.write <<-EOF
// This is required for Swift compilation

import Foundation

EOF
}

File.open("#{project_path}/Setup-Bridging-Header.h", 'w') { |file| 
file.write <<-EOF
// This is required for Swift compilation

EOF
}

project = Xcodeproj::Project.open("#{project_path}/Setup.xcodeproj")

swift_source = project.new_file('File.swift')
project.new_file('Setup-Bridging-Header.h')

project.targets.each do |target|
  if target.name == 'Setup'
    target.add_file_references [swift_source]
  end
  target.build_configurations.each do |config|
    config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
    config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
    config.build_settings['SWIFT_OBJC_BRIDGING_HEADER'] = 'Setup-Bridging-Header.h'
    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
    config.build_settings['SWIFT_VERSION'] = '4.2'
  end
end

project.save
