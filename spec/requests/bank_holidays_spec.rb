require 'rails_helper'

RSpec.describe "BankHolidays", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/bank_holidays/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/bank_holidays/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/bank_holidays/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/bank_holidays/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/bank_holidays/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
