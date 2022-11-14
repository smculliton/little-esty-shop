require 'rails_helper'

RSpec.describe BulkDiscount do 
  describe 'relationships' do 
    it { should belong_to :merchant}
  end

  describe 'validations' do 
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :threshold }
    it { should validate_numericality_of(:percentage).is_greater_than(0) }
    it { should validate_numericality_of(:percentage).is_less_than(100) }
    it { should validate_numericality_of(:threshold).is_greater_than(0) }
  end
end
