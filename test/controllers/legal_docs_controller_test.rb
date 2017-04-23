require 'test_helper'

class LegalDocsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get legal_docs_new_url
    assert_response :success
  end

  test "should get create" do
    get legal_docs_create_url
    assert_response :success
  end

  test "should get index" do
    get legal_docs_index_url
    assert_response :success
  end

end
