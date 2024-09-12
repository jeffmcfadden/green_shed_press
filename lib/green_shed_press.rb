require 'erb'
require 'fileutils'
require 'json'
require 'logger'
require 'ostruct'
require 'redcarpet'
require 'time'
require 'webrick'
require 'vips'
require 'yaml'

require "active_support"
require "active_support/core_ext"
require "active_support/concern"
require "active_support/inflector"

require_relative "version"

module GSP
  class Error < StandardError; end
  LOGGER = Logger.new($stdout)
  LOGGER.level = Logger::DEBUG
end

require_relative "green_shed_press/concerns/bodyable"
require_relative "green_shed_press/concerns/frontmatterable"
require_relative "green_shed_press/concerns/collection_object"
require_relative "green_shed_press/concerns/content_loadable"
require_relative "green_shed_press/concerns/contentable"
require_relative "green_shed_press/concerns/layoutable"
require_relative "green_shed_press/site"
require_relative "green_shed_press/content_body_extractor"
require_relative "green_shed_press/gsp_file"
require_relative "green_shed_press/frontmatter"
require_relative "green_shed_press/frontmatter_extrator"
require_relative "green_shed_press/layout"
require_relative "green_shed_press/page"
require_relative "green_shed_press/partial"
require_relative "green_shed_press/photo"
require_relative "green_shed_press/post"
require_relative "green_shed_press/micro_post"
require_relative "green_shed_press/static_file"
require_relative "green_shed_press/builder"
require_relative "green_shed_press/render_context"
require_relative "green_shed_press/renderer"
require_relative "green_shed_press/output_file_mapper"
