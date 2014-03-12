require 'spec_helper'

describe DownloadController do

  describe "GET 'smc'" do
    it "returns http success" do
      get 'smc'
      response.should be_success
    end
  end

end
