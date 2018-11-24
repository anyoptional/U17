#
# Be sure to run `pod lib lint Bindable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
    s.name             = 'Bindable'
    s.version          = '1.0.0'
    s.summary          = 'UI-independent layer.'
    
    s.homepage         = 'Coming soon...'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Archer' => 'code4archer@163.com' }
    s.source           = { :git => 'Coming soon...', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    
    s.dependency 'RxDataSources', '~> 3.0.2'
    
    s.subspec "Core" do |cs|
        cs.source_files  = "Bindable/Classes/Core"
    end
    
end
