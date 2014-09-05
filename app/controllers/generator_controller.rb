class GeneratorController < ApplicationController
  def index
  end

  def view
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
