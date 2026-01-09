# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "minimi"
  spec.version       = "0.1.0"
  spec.authors       = ["Oleg Larkin"]
  spec.email         = ["olegollar@gmail.com"]

  spec.summary       = "minimal theme for yaba site"
  # spec.homepage      = "yaba.su"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_data|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.4"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.9"
end
