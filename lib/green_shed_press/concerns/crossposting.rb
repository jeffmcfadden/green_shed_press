begin
  require "mastodon"
rescue LoadError
  LOGGER.debug "Mastodon gem not found."
end

module GSP
  module Crossposting
    extend ActiveSupport::Concern

    def crosspost
      LOGGER.info "#crosspost"

      crosspost_to_mastodon
    end

    def crosspost_to_mastodon
      LOGGER.info "Crossposting to Mastodon"

      unless defined? Mastodon
        LOGGER.error "Mastodon gem not found. Please add it to your Gemfile:"
        LOGGER.error 'gem "mastodon-api", require: "mastodon", github: "mastodon/mastodon-api"'
        return
      end

      token = ENV.fetch("MASTODON_ACCESS_TOKEN", false)
      unless token
        LOGGER.error "Mastodon access token not found. Please set the MASTODON_ACCESS_TOKEN environment variable."
        return
      end

      crossposted_to_mastodon_log_filepath = File.join(@output_directory, ".crossposted_to_mastodon.txt")

      if !File.exist?(crossposted_to_mastodon_log_filepath)
        LOGGER.info "No .crossposted_to_mastodon.text file found. Building initial file."
        build_initial_crossposted_to_mastodon_log(crossposted_to_mastodon_log_filepath)
        return
      end

      crossposted_to_mastodon_log = File.open(crossposted_to_mastodon_log_filepath).read.split("\n")

      client = Mastodon::REST::Client.new(base_url: 'https://ruby.social', bearer_token: token)

      [@posts, @micro_posts].flatten.each do |item|
        if crossposted_to_mastodon_log.include?(item.output_filepath)
          LOGGER.debug "Already crossposted: #{item.output_filepath}"
          next
        end

        case item.class.to_s
        when 'GSP::Post'
          post_text = item.title
        when 'GSP::MicroPost'
          post_text = item.rendered_body_no_layout
        end

        post_text += "\n\n#{@base_url}#{item.url}"

        LOGGER.debug "Crossposting: #{item.output_filepath}"
        LOGGER.debug "Post text: #{post_text}"

        begin
          client.create_status(post_text)
          crossposted_to_mastodon_log << item.output_filepath
        rescue Mastodon::Error => e
          LOGGER.error "!! Error crossposting to Mastodon: #{e}"
        end
      end

      File.open(crossposted_to_mastodon_log_filepath, "w") do |f|
        f.write crossposted_to_mastodon_log.join("\n")
      end

    end

    def build_initial_crossposted_to_mastodon_log(filepath)
      LOGGER.info "Building initial crossposted_to_mastodon_log"

      File.open(filepath, "w") do |f|
        [@posts, @micro_posts].flatten.each do |item|
          f.write("#{item.output_filepath}\n")
        end
      end
    end


  end
end