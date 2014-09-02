require 'test_helper'

class CustomAvatarsControllerTest < ActionController::TestCase
  setup do
    @custom_avatar = custom_avatars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_avatars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_avatar" do
    assert_difference('CustomAvatar.count') do
      post :create, custom_avatar: { author: @custom_avatar.author, image: @custom_avatar.image, name: @custom_avatar.name, rights: @custom_avatar.rights, uploader: @custom_avatar.uploader }
    end

    assert_redirected_to custom_avatar_path(assigns(:custom_avatar))
  end

  test "should show custom_avatar" do
    get :show, id: @custom_avatar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @custom_avatar
    assert_response :success
  end

  test "should update custom_avatar" do
    patch :update, id: @custom_avatar, custom_avatar: { author: @custom_avatar.author, image: @custom_avatar.image, name: @custom_avatar.name, rights: @custom_avatar.rights, uploader: @custom_avatar.uploader }
    assert_redirected_to custom_avatar_path(assigns(:custom_avatar))
  end

  test "should destroy custom_avatar" do
    assert_difference('CustomAvatar.count', -1) do
      delete :destroy, id: @custom_avatar
    end

    assert_redirected_to custom_avatars_path
  end
end
