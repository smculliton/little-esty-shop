class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def update
    @merchant = Merchant.find(params[:id]) 
    if params[:status]
      @merchant.update(status: params[:status])
    end

    redirect_to admin_merchants_path
  end
end