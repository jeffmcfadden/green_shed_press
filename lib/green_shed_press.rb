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

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

end

require_relative "green_shed_press/concerns/bodyable"
require_relative "green_shed_press/concerns/frontmatterable"
require_relative "green_shed_press/concerns/content_loadable"
require_relative "green_shed_press/concerns/layoutable"
require_relative "green_shed_press/site"
require_relative "green_shed_press/content_body_extractor"
require_relative "green_shed_press/document"
require_relative "green_shed_press/frontmatter"
require_relative "green_shed_press/frontmatter_extractor"
require_relative "green_shed_press/layout"
require_relative "green_shed_press/page"
require_relative "green_shed_press/partial"
require_relative "green_shed_press/photo"
require_relative "green_shed_press/photo_page"
require_relative "green_shed_press/photo_set"
require_relative "green_shed_press/post"
require_relative "green_shed_press/micro_post"
require_relative "green_shed_press/static_file"
require_relative "green_shed_press/render_context"
