Pod::Spec.new do |s|
  s.name             = 'TFManager'
  s.version          = '1.0.1'
  s.summary          = 'Add validations to your text fields, Group them together and navigate through them via return button and accessory view.'
  s.homepage         = 'https://github.com/abspr/TFManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Hosein Abbaspour' => 'hosein@me.com' }
  s.source           = { :git => 'https://github.com/abspr/TFManager.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/TFManager/**/*'
end
