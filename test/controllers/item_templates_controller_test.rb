require 'test_helper'

class ItemTemplatesControllerTest < ActionController::TestCase
  setup do
    @item_template = item_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item template" do
    assert_difference('ItemTemplate.count') do
      post :create, item_template: { description: @item_template.description, image: @item_template.image, name: @item_template.name, category: @item_template.category }
    end

    assert_redirected_to item_template_path(assigns(:item_template))
  end

  test "should show item template" do
    get :show, id: @item_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_template
    assert_response :success
  end

  test "should update item template" do
    patch :update, id: @item_template, item_template: { description: @item_template.description, image: @item_template.image, name: @item_template.name, category: @item_template.category }
    assert_redirected_to item_template_path(assigns(:item_template))
  end

  test "should destroy item template" do
    assert_difference('ItemTemplate.count', -1) do
      delete :destroy, id: @item_template
    end

    assert_redirected_to item_templates_path
  end
end
