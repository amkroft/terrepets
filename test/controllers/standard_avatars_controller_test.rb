require 'test_helper'

class StandardAvatarsControllerTest < ActionController::TestCase
  setup do
    @standard_avatar = standard_avatars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:standard_avatars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create standard_avatar" do
    assert_difference('StandardAvatar.count') do
      post :create, standard_avatar: { image: @standard_avatar.image, name: @standard_avatar.name, rights: @standard_avatar.rights }
    end

    assert_redirected_to standard_avatar_path(assigns(:standard_avatar))
  end

  test "should show standard_avatar" do
    get :show, id: @standard_avatar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @standard_avatar
    assert_response :success
  end

  test "should update standard_avatar" do
    patch :update, id: @standard_avatar, standard_avatar: { image: @standard_avatar.image, name: @standard_avatar.name, rights: @standard_avatar.rights }
    assert_redirected_to standard_avatar_path(assigns(:standard_avatar))
  end

  test "should destroy standard_avatar" do
    assert_difference('StandardAvatar.count', -1) do
      delete :destroy, id: @standard_avatar
    end

    assert_redirected_to standard_avatars_path
  end
end
