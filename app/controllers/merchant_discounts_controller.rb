require './app/poros/holiday_search'

class MerchantDiscountsController < ApplicationController
  def self.controller_path
    'merchants/discounts'
  end

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidaySearch.create_holidays
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

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    @discount.destroy

    redirect_to merchant_discounts_path(@merchant)
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end 

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    @discount.update(discount_params)

    redirect_to merchant_discount_path(@merchant, @discount)
  end

  private
  def discount_params
    params.require(:bulk_discount).permit(:percentage, :threshold)
  end
end