class MerchantDiscountsController < ApplicationController
  def self.controller_path
    'merchants/discounts'
  end

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.new
  end

  def create 
    # Needs sad path/ edge case testing
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.create!(discount_params)

    redirect_to merchant_discounts_path(@merchant)
  end

  private
  def discount_params
    params.require(:bulk_discount).permit(:percentage, :threshold)
  end
end