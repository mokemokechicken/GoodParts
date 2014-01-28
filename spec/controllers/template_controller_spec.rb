require 'spec_helper'

describe TemplateController do

  describe "GET 'get'" do
    it "returns http success" do
      get 'get', :name => 'good_parts/param_controllers/map/view.html'
      response.should be_success
    end
  end
end
