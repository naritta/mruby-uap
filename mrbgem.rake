MRuby::Gem::Specification.new('mruby-uap') do |spec|
  spec.license= 'MIT'
  spec.authors= 'naritta'
  spec.add_dependency('mruby-io')
  spec.add_dependency('mruby-onig-regexp')
  spec.add_dependency('mruby-yaml', :github => 'AndrewBelt/mruby-yaml')
end
