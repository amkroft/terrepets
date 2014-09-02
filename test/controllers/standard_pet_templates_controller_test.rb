require 'test_helper'

class StandardPetTemplatesControllerTest < ActionController::TestCase
  setup do
    @standard_pet_template = standard_pet_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:standard_pet_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create standard_pet_template" do
    assert_difference('StandardPetTemplate.count') do
      post :create, standard_pet_template: { description: @standard_pet_template.description, image: @standard_pet_template.image, name: @standard_pet_template.name, rights: @standard_pet_template.rights }
    end

    assert_redirected_to standard_pet_template_path(assigns(:standard_pet_template))
  end

  test "should show standard_pet_template" do
    get :show, id: @standard_pet_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @standard_pet_template
    assert_response :success
  end

  test "should update standard_pet_template" do
    patch :update, id: @standard_pet_template, standard_pet_template: { description: @standard_pet_template.description, image: @standard_pet_template.image, name: @standard_pet_template.name, rights: @standard_pet_template.rights }
    assert_redirected_to standard_pet_template_path(assigns(:standard_pet_template))
  end

  test "should destroy standard_pet_template" do
    assert_difference('StandardPetTemplate.count', -1) do
      delete :destroy, id: @standard_pet_template
    end

    assert_redirected_to standard_pet_templates_path
  end
end
