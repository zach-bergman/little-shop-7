require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer}
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values({ "in progress" => 0, "completed" => 1, "cancelled" => 2}) }
  end
end