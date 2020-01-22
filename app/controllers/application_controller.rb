class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include Pagy::Backend

  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
end
