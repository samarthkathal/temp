require "test_helper"

class SourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @source = sources(:one)
  end

  test "should get index" do
    get sources_url, as: :json
    assert_response :success
  end

  test "should create source" do
    assert_difference("Source.count") do
      post sources_url, params: { source: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show source" do
    get source_url(@source), as: :json
    assert_response :success
  end

  test "should update source" do
    patch source_url(@source), params: { source: {  } }, as: :json
    assert_response :success
  end

  test "should destroy source" do
    assert_difference("Source.count", -1) do
      delete source_url(@source), as: :json
    end

    assert_response :no_content
  end
end
