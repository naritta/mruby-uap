# mruby-uap

## install by mrbgems
```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'naritta/mruby-uap'
end
```

## Example
```ruby
user_agent = UserAgentParser.parse 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0;)'
=> #<UserAgentParser::UserAgent IE 9.0 (Windows Vista)>
user_agent.to_s
=> "IE 9.0"
user_agent.family
=> "IE"
user_agent.version.to_s
=> "9.0"
user_agent.version.major
=> "9"
user_agent.version.minor
=> "0"
operating_system = user_agent.os
=> #<UserAgentParser::OperatingSystem Windows Vista>
operating_system.to_s
=> "Windows Vista"
```

## test
tests can be executed with mruby-mtest
```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'naritta/mruby-uap
    conf.gem :github => 'iij/mruby-mtest'
end
```
Then build mruby and run tests
```
$ mruby test/mruby-uap.rb
```

## License

MIT