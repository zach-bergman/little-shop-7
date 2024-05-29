require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "enums" do
    it { should define_enum_for(:status).with_values({ "pending" => 0, "packaged" => 1, "shipped" => 2}) }
  end
end