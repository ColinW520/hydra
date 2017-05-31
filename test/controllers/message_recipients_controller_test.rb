require 'test_helper'

class MessageRecipientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message_recipient = message_recipients(:one)
  end

  test "should get index" do
    get message_recipients_url
    assert_response :success
  end

  test "should get new" do
    get new_message_recipient_url
    assert_response :success
  end

  test "should create message_recipient" do
    assert_difference('MessageRecipient.count') do
      post message_recipients_url, params: { message_recipient: { contact_id: @message_recipient.contact_id, error_message: @message_recipient.error_message, from_number: @message_recipient.from_number, message_id: @message_recipient.message_id, sent_at: @message_recipient.sent_at, to_number: @message_recipient.to_number, twilio_id: @message_recipient.twilio_id } }
    end

    assert_redirected_to message_recipient_url(MessageRecipient.last)
  end

  test "should show message_recipient" do
    get message_recipient_url(@message_recipient)
    assert_response :success
  end

  test "should get edit" do
    get edit_message_recipient_url(@message_recipient)
    assert_response :success
  end

  test "should update message_recipient" do
    patch message_recipient_url(@message_recipient), params: { message_recipient: { contact_id: @message_recipient.contact_id, error_message: @message_recipient.error_message, from_number: @message_recipient.from_number, message_id: @message_recipient.message_id, sent_at: @message_recipient.sent_at, to_number: @message_recipient.to_number, twilio_id: @message_recipient.twilio_id } }
    assert_redirected_to message_recipient_url(@message_recipient)
  end

  test "should destroy message_recipient" do
    assert_difference('MessageRecipient.count', -1) do
      delete message_recipient_url(@message_recipient)
    end

    assert_redirected_to message_recipients_url
  end
end
