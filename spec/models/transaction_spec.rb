require "rails_helper"

RSpec.describe Transaction, type: :model do
  describe "enums" do
    it { should define_enum_for(:result).with_values({ success: 0, failed: 1 }) }
  end
end