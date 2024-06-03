require "rails_helper"

RSpec.describe "Admin Invoice Index" do
  before(:each) do
    @invoice1 = create(:invoice)
    @invoice2 = create(:invoice)
    @invoice3 = create(:invoice)
  end

  it "should show a list of invoice ids" do
    visit admin_invoices_path

    within "div#invoices-list" do
        expect(page).to have_link(@invoice1.id.to_s, href: admin_invoice_path(@invoice1))
        expect(page).to have_link(@invoice2.id.to_s, href: admin_invoice_path(@invoice2))
        expect(page).to have_link(@invoice3.id.to_s, href: admin_invoice_path(@invoice3))
    end
  end
end