class MerchantDiscountsController < ApplicationController
  def self.controller_path
    'merchants/discounts'
  end

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
end