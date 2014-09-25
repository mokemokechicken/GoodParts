class GeneratorController < ApplicationController
  def index
  end

  def view
  end

  def configure
    config = GoodParts2::Application.config.generator
    config[:smc_service_url].gsub!(/HTTP_HOST/, request.headers[:HTTP_HOST].to_s.split(':')[0])  # orz
    render :json => config
  end

  # generator/generate
  def generate
    Rails.logger.debug params.inspect
    lang = params[:lang]
    smc = request.raw_post
    type =
          case lang
            when /javascript/
              SMCGenerator::JAVASCRIPT
            when 'swift'
              SMCGenerator::SWIFT
            else
              raise Exception("Unknown lang #{lang}")
          end
    begin
      code = SMCGenerator.new.generate(type, smc)
      render :json => {impl: code}, :status => 201
    rescue SMCGenerator::ConvertError => e
      render :json => e.to_s
    end
  end
end
