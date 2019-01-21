Gem::Specification.new do |s|
  s.name = 'ruby_yappl'
  s.version = '0.1.4'
  s.date = '2019-01-21'
  s.summary = 'ruby gem for the yappl privacy preference language'
  s.authors = ['Thomas Peikert']
  s.email = 't.s.peikert+yappl@gmail.com'
  s.homepage = 'https://github.com/TPei/ruby_yappl'
  s.license = 'MIT'
  s.files = `git ls-files`.split($/)
  s.require_paths = ['lib']
  s.add_dependency('json-schema', '~> 2.8')
end
