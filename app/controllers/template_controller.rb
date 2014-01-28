class TemplateController < ApplicationController
  def get
    name = params[:name]
    path = File.expand_path("app/assets/javascripts/#{name}", Rails.root)
    path = File.absolute_path(path)
    raise unless /^#{Regexp.escape(Rails.root.to_s)}/ =~ path
    render :text => File.read(path)
  end
end
