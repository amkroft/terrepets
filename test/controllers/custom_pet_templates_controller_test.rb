require 'test_helper'

class CustomPetTemplatesControllerTest < ActionController::TestCase
  setup do
    @custom_pet_template = custom_pet_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_pet_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_pet_template" do
    assert_difference('CustomPetTemplate.count') do
      post :create, custom_pet_template: { author: @custom_pet_template.author, description: @custom_pet_template.description, image: @custom_pet_template.image, name: @custom_pet_template.name, recipient: @custom_pet_template.recipient, rights: @custom_pet_template.rights, uploader: @custom_pet_template.uploader }
    end

    assert_redirected_to custom_pet_template_path(assigns(:custom_pet_template))
  end

  test "should show custom_pet_template" do
    get :show, id: @custom_pet_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @custom_pet_template
    assert_response :success
  end

  test "should update custom_pet_template" do
    patch :update, id: @custom_pet_template, custom_pet_template: { author: @custom_pet_template.author, description: @custom_pet_template.description, image: @custom_pet_template.image, name: @custom_pet_template.name, recipient: @custom_pet_template.recipient, rights: @custom_pet_template.rights, uploader: @custom_pet_template.uploader }
    assert_redirected_to custom_pet_template_path(assigns(:custom_pet_template))
  end

  test "should destroy custom_pet_template" do
    assert_difference('CustomPetTemplate.count', -1) do
      delete :destroy, id: @custom_pet_template
    end

    assert_redirected_to custom_pet_templates_path
  end
end
