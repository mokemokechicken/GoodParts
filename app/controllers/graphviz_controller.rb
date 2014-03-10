require 'graphviz'

class GraphvizController < ApplicationController
  def dot
    key = params[:key]
    format = params[:format]

    model = AnyData.find_by_key(key)
    if model
      data = nil
      status = 200
      begin
        g = GraphViz.parse_string(model.data)
        raise RuntimeError('no input') unless g
        case format
          when 'png'
            data = g.output({:png => String})
            response.headers['Content-Type'] = 'image/png'
          when 'xdot'
            data = g.output({:xdot => String})
            response.headers['Content-Type'] = 'application/xdot'
          else
            data = "Unknown output format #{output}"
            status = 400
        end
      rescue e
        status = 400
        data = e.inspect
      end
      render :text => data, :status => status
    else
      render :status => 404
    end
  end
end

