require "yaml"

%w[
  version

  facade
  file
  scoped
].each { |name| require "store2/#{name}" }

module Store2
  extend Facade
end
