files = Dir.glob(Dir.pwd + '/**/*.rb')
files.collect! {|file| file.sub(Dir.pwd + '/', '')}
files.push('LICENSE')

Gem::Specification.new do |s|
  s.name        = 'buapi'
  s.version     = '0.0.5'
	s.date        = "#{Time.now.strftime("%Y-%m-%d")}"
	s.homepage    = 'https://github.com/jphager2/bakaupdatesapi'
  s.summary     = 'Useful interface BakaUpdates'
  s.description = 'Useful interface BakaUpdates'
  s.authors     = ['jphager2']
  s.email       = 'jphager2@gmail.com'
  s.files       = files 
  s.license     = 'MIT'
end
