Gem::Specification.new do |spec|
  spec.name = 'usd'
  spec.version = '0.2.2'
  spec.date = '2019-11-26'
  spec.summary = "SDM REST-API-Calls"
  spec.description = "a Ruby class and a commandlinetool for SDM REST-API-Calls"
  spec.authors = ["Oliver Gaida"]
  spec.email = 'oliver.gaida@sycor.de'
  #spec.files = ["bin/rusdc", "bin/set_env", "lib/usd.rb"] # Dir["*/*"]
  spec.files = `git ls-files`.split($/)
  spec.homepage = 'https://github.com/ogaida/usd'
  spec.executables = %w(rusdc)
  spec.add_runtime_dependency 'thor', '~> 0.20', '>= 0.20.3'
  spec.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.0'
  spec.add_runtime_dependency 'json', '~> 2.1', '>= 2.1.0'
end
