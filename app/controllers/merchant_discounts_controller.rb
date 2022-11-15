require './app/poros/holiday_search'

class MerchantDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create, ]
  before_action :find_merchant_and_discount, only: [:show, :destroy, :edit, :update]
  
  def self.controller_path
    'merchants/discounts'
  end

  def index
    @holidays = HolidaySearch.create_holidays
  end

  def show
  end

  def new 
    @discount = @merchant.bulk_discounts.new
    @holiday = params[:holiday]
  end

  def create 
    @discount = @merchant.bulk_discounts.new(discount_params)
    
    if @discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:notice] = 'Fields missing or invalid'
      redirect_to new_merchant_discount_path
    end
  end

  def destroy
    @discount.destroy

    redirect_to merchant_discounts_path(@merchant)
  end

  def edit
  end 

  def update
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

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant_and_discount
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end
end