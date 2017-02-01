require 'test_helper'

class MashupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mashup = mashups(:one)
  end

  test "should get index" do
    get mashups_url
    assert_response :success
  end

  test "should get new" do
    get new_mashup_url
    assert_response :success
  end

  test "should create mashup" do
    assert_difference('Mashup.count') do
      post mashups_url, params: { mashup: { index: @mashup.index } }
    end

    assert_redirected_to mashup_url(Mashup.last)
  end

  test "should show mashup" do
    get mashup_url(@mashup)
    assert_response :success
  end

  test "should get edit" do
    get edit_mashup_url(@mashup)
    assert_response :success
  end

  test "should update mashup" do
    patch mashup_url(@mashup), params: { mashup: { index: @mashup.index } }
    assert_redirected_to mashup_url(@mashup)
  end

  test "should destroy mashup" do
    assert_difference('Mashup.count', -1) do
      delete mashup_url(@mashup)
    end

    assert_redirected_to mashups_url
  end
end
