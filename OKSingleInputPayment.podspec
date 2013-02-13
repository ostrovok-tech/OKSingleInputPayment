Pod::Spec.new do |s|
  s.name         = "OKSingleInputPayment"
  s.version      = "0.0.1"
  s.summary      = "A customizable implementation of Square's single input payment for iOS."
  s.homepage     = "http://ostrovok.ru"
  s.license      = 'MIT'
  
  s.author       = { "Ryan Romanchuk" => "rromanchuk@gmail.com" }
  s.source       = { :git => "git://github.com/ostrovok-team/single-input-payment.git", :tag => "0.0.1" }
  s.platform     = :ios, '5.0'
  s.source_files = src/*.{h,m}'
  s.resource     =  'src/OKSingleInput.bundle'
  s.requires_arc = true
end
