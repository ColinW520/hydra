require 'test_helper'

class contactsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contacts_index_url
    assert_response :success
  end

  test "should get new" do
    get contacts_new_url
    assert_response :success
  end

  test "should get create" do
    get contacts_create_url
    assert_response :success
  end

  test "should get edit" do
    get contacts_edit_url
    assert_response :success
  end

  test "should get update" do
    get contacts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get contacts_destroy_url
    assert_response :success
  end

end
