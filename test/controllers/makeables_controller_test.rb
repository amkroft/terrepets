require 'test_helper'

class MakeablesControllerTest < ActionController::TestCase
  setup do
    @makeable = makeables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:makeables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create makeable" do
    assert_difference('Makeable.count') do
      post :create, makeable: { difficulty: @makeable.difficulty, ingredients: @makeable.ingredients, item_template_id: @makeable.item_template_id }
    end

    assert_redirected_to makeable_path(assigns(:makeable))
  end

  test "should show makeable" do
    get :show, id: @makeable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @makeable
    assert_response :success
  end

  test "should update makeable" do
    patch :update, id: @makeable, makeable: { difficulty: @makeable.difficulty, ingredients: @makeable.ingredients, item_template_id: @makeable.item_template_id }
    assert_redirected_to makeable_path(assigns(:makeable))
  end

  test "should destroy makeable" do
    assert_difference('Makeable.count', -1) do
      delete :destroy, id: @makeable
    end

    assert_redirected_to makeables_path
  end
end
