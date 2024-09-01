module GSP
  class MicroPost
    include Contentable

    attr_reader :title, :body, :slug, :created_at, :updated_at


  end
end