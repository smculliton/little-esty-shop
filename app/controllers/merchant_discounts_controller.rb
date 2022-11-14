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
    @holiday = params[:holiday]
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.bulk_discounts.new(discount_params)
    
    if discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:notice] = 'Fields missing or invalid'
      redirect_to new_merchant_discount_path
    end
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
    
    if @discount.update(discount_params)
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash[:notice] = 'Fields missing or invalid'
      redirect_to edit_merchant_discount_path(@merchant, @discount)
    end
  end

  private
  def discount_params
    params.require(:bulk_discount).permit(:percentage, :threshold, :name, :holiday)
  end
end