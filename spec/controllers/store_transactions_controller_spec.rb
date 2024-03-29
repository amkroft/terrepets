require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe StoreTransactionsController do

  # This should return the minimal set of attributes required to create a valid
  # StoreTransaction. As you add validations to StoreTransaction, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "user_id" => "1" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # StoreTransactionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all store_transactions as @store_transactions" do
      store_transaction = StoreTransaction.create! valid_attributes
      get :index, {}, valid_session
      assigns(:store_transactions).should eq([store_transaction])
    end
  end

  describe "GET show" do
    it "assigns the requested store_transaction as @store_transaction" do
      store_transaction = StoreTransaction.create! valid_attributes
      get :show, {:id => store_transaction.to_param}, valid_session
      assigns(:store_transaction).should eq(store_transaction)
    end
  end

  describe "GET new" do
    it "assigns a new store_transaction as @store_transaction" do
      get :new, {}, valid_session
      assigns(:store_transaction).should be_a_new(StoreTransaction)
    end
  end

  describe "GET edit" do
    it "assigns the requested store_transaction as @store_transaction" do
      store_transaction = StoreTransaction.create! valid_attributes
      get :edit, {:id => store_transaction.to_param}, valid_session
      assigns(:store_transaction).should eq(store_transaction)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new StoreTransaction" do
        expect {
          post :create, {:store_transaction => valid_attributes}, valid_session
        }.to change(StoreTransaction, :count).by(1)
      end

      it "assigns a newly created store_transaction as @store_transaction" do
        post :create, {:store_transaction => valid_attributes}, valid_session
        assigns(:store_transaction).should be_a(StoreTransaction)
        assigns(:store_transaction).should be_persisted
      end

      it "redirects to the created store_transaction" do
        post :create, {:store_transaction => valid_attributes}, valid_session
        response.should redirect_to(StoreTransaction.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved store_transaction as @store_transaction" do
        # Trigger the behavior that occurs when invalid params are submitted
        StoreTransaction.any_instance.stub(:save).and_return(false)
        post :create, {:store_transaction => { "user_id" => "invalid value" }}, valid_session
        assigns(:store_transaction).should be_a_new(StoreTransaction)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        StoreTransaction.any_instance.stub(:save).and_return(false)
        post :create, {:store_transaction => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested store_transaction" do
        store_transaction = StoreTransaction.create! valid_attributes
        # Assuming there are no other store_transactions in the database, this
        # specifies that the StoreTransaction created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        StoreTransaction.any_instance.should_receive(:update).with({ "user_id" => "1" })
        put :update, {:id => store_transaction.to_param, :store_transaction => { "user_id" => "1" }}, valid_session
      end

      it "assigns the requested store_transaction as @store_transaction" do
        store_transaction = StoreTransaction.create! valid_attributes
        put :update, {:id => store_transaction.to_param, :store_transaction => valid_attributes}, valid_session
        assigns(:store_transaction).should eq(store_transaction)
      end

      it "redirects to the store_transaction" do
        store_transaction = StoreTransaction.create! valid_attributes
        put :update, {:id => store_transaction.to_param, :store_transaction => valid_attributes}, valid_session
        response.should redirect_to(store_transaction)
      end
    end

    describe "with invalid params" do
      it "assigns the store_transaction as @store_transaction" do
        store_transaction = StoreTransaction.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        StoreTransaction.any_instance.stub(:save).and_return(false)
        put :update, {:id => store_transaction.to_param, :store_transaction => { "user_id" => "invalid value" }}, valid_session
        assigns(:store_transaction).should eq(store_transaction)
      end

      it "re-renders the 'edit' template" do
        store_transaction = StoreTransaction.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        StoreTransaction.any_instance.stub(:save).and_return(false)
        put :update, {:id => store_transaction.to_param, :store_transaction => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested store_transaction" do
      store_transaction = StoreTransaction.create! valid_attributes
      expect {
        delete :destroy, {:id => store_transaction.to_param}, valid_session
      }.to change(StoreTransaction, :count).by(-1)
    end

    it "redirects to the store_transactions list" do
      store_transaction = StoreTransaction.create! valid_attributes
      delete :destroy, {:id => store_transaction.to_param}, valid_session
      response.should redirect_to(store_transactions_url)
    end
  end

end
