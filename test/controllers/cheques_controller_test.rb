require "test_helper"

class ChequesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cheque = cheques(:one)
  end

  test "should get index" do
    get cheques_url, as: :json
    assert_response :success
  end

  test "should create cheque" do
    assert_difference("Cheque.count") do
      post cheques_url, params: { cheque: {} }, as: :json
    end

    assert_response :created
  end

  test "should show cheque" do
    get cheque_url(@cheque), as: :json
    assert_response :success
  end

  test "should update cheque" do
    patch cheque_url(@cheque), params: { cheque: {} }, as: :json
    assert_response :success
  end

  test "should destroy cheque" do
    assert_difference("Cheque.count", -1) do
      delete cheque_url(@cheque), as: :json
    end

    assert_response :no_content
  end
end
