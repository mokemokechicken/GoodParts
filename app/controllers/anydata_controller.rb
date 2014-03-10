require 'graphviz'

class AnydataController < ApplicationController
  def add
    rawdata = request.raw_post
    key = Digest::SHA1.hexdigest(rawdata).to_s
    model = AnyData.find_by_key(key)
    unless model
      AnyData.create(:key => key, :data => rawdata)
    end
    response.headers['X-Data-Key'] = key
    render :json => {:key => key}, :status => 201
  end

  def get
    key = params[:key]
    content_type = params[:content_type] || 'text/plain'
    model = AnyData.find_by_key(key)
    if model
      response.headers['Content-Type'] = content_type
      render :text => model.data
    else
      render :status => 404
    end
  end
end

