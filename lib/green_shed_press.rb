require 'erb'
require 'yaml'
require 'json'
require 'logger'
require 'ostruct'

require_relative "version"

module GSP
  class Error < StandardError; end
  LOGGER = Logger.new($stdout)
  LOGGER.level = Logger::DEBUG
end
require_relative "green_shed_press/concerns/arbitrary_metadatable"
require_relative "green_shed_press/concerns/contentable"
require_relative "green_shed_press/site"
require_relative "green_shed_press/layout"
require_relative "green_shed_press/page"
require_relative "green_shed_press/post"
require_relative "green_shed_press/micro_post"
require_relative "green_shed_press/builder"
require_relative "green_shed_press/renderer"
