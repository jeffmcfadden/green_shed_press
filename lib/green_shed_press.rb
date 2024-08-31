require 'yaml'
require 'json'
require 'logger'
require 'ostruct'

require_relative "version"

module GSP
  class Error < StandardError; end
end

require_relative "green_shed_press/site"
require_relative "green_shed_press/page"
require_relative "green_shed_press/post"
require_relative "green_shed_press/micro_post"