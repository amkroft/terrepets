class Commerce::StoreTransactionsController < ApplicationController

  def index
    @store_transactions = current_user.store_transactions.paginate(page: params[:page]).order('created_at DESC')
    current_user.update_attributes(has_new_sales: false)
  end

  # POST /store_transactions
  # POST /store_transactions.json
  # def create
  #   @store_transaction = StoreTransaction.new(store_transaction_params)

  #   respond_to do |format|
  #     if @store_transaction.save
  #       format.html { redirect_to @store_transaction, notice: 'Store transaction was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @store_transaction }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @store_transaction.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /store_transactions/1
  # DELETE /store_transactions/1.json
  # def destroy
  #   @store_transaction.destroy
  #   respond_to do |format|
  #     format.html { redirect_to store_transactions_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store_transaction
      @store_transaction = StoreTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_transaction_params
      params.require(:store_transaction).permit(:user_id, :description, :amount)
    end
end
