require "rails_helper"

RSpec.describe "Admin Merchants Index" do
  before(:each) do
    @merchants = create_list(:merchant, 5)
    @merchant_test = create(:merchant)

    visit admin_merchants_path
  end

  describe "As an admin, when I visit the admin merchants index" do
    describe "User Story 24" do
      it "shows the name of each merchant" do
        within("div#merchants_list") do
          @merchants.each do |merchant|
            expect(page).to have_content(merchant.name)
          end
        end
      end
    end

    describe "User Story 25" do
      it "shows each merchant's name as a link" do
        within("div#merchants_list") do
          @merchants.each do |merchant|
            expect(page).to have_link(merchant.name)
          end
        end
      end

      it "directs to the admin show page when a merchant's name is clicked" do
        click_link(@merchant_test.name)

        expect(current_path).to eq(admin_merchant_path(@merchant_test.id))
      end
    end
  end

  describe "User Story 27" do
    it "has an enable or disable button next to each merchant and when one of the buttons
    is clicked, it redirects back to the index page and the merchant's status has changed" do
      enabled_merchant = create(:merchant, status: 1)
      disabled_merchant = create(:merchant, status: 0)

      within("div#merchants_list") do
        Merchant.all.each do |merchant|
          within("div#merchant_#{merchant.id}") do
            if merchant.enabled?
              expect(page).to have_button("Disable")
              expect(page).to_not have_button("Enable")
              
              click_button("Disable")
              
              expect(current_path).to eq(admin_merchants_path)
              
              expect(page).to have_button("Enable")
              expect(page).to_not have_button("Disable")
            else
              expect(page).to have_button("Enable")
              expect(page).to_not have_button("Disable")

              click_button("Enable")

              expect(current_path).to eq(admin_merchants_path)

              expect(page).to have_button("Disable")
              expect(page).to_not have_button("Enable")
            end
          end 
        end
      end
    end
  end

  describe "User Story 28" do
    it "shows enabled merchants in 'Enabled Merchants' section and disabled mercants in 'Disabled Merchants' section'" do

      within("div#enabled_merchants") do
        @merchants.each do |merchant|
          expect(page).to have_content(merchant.name) if merchant.enabled?
          expect(page).to_not have_content(merchant.name) if merchant.disabled?
        end
      end

      within("div#disabled_merchants") do
        @merchants.each do |merchant|
          expect(page).to have_content(merchant.name) if merchant.disabled?
          expect(page).to_not have_content(merchant.name) if merchant.enabled?
        end
      end
    end
  end

  describe "User Story 29" do
    it "shows a link to create a new merchant that directs to the admin merchant new page" do
      expect(page).to have_link("Create New Merchant")

      click_link("Create New Merchant")

      expect(current_path).to eq(new_admin_merchant_path)
    end
  end

  describe "User Story 30" do
    before(:each) do
      # @merchant_1 = create(:merchant, name: "One")
      # @merchant_2 = create(:merchant, name: "two")
      # @merchant_3 = create(:merchant, name: "three")
      # @merchant_4 = create(:merchant, name: "four")
      # @merchant_5 = create(:merchant, name: "five")
      # @merchant_6 = create(:merchant, name: "six")
      # @merchant_7 = create(:merchant, name: "seven")
      # @merchant_8 = create(:merchant, name: "eight")

      # @invoice_1 = create(:invoice)
      # @invoice_2 = create(:invoice)
      # @invoice_3 = create(:invoice)
      # @invoice_4 = create(:invoice)
      # @invoice_5 = create(:invoice)
      # @invoice_6 = create(:invoice)
      # @invoice_7 = create(:invoice)
      # @invoice_8 = create(:invoice)

      # @item_1 = create(:item, merchant_id: @merchant_1.id)
      # @item_2 = create(:item, merchant_id: @merchant_2.id)
      # @item_3 = create(:item, merchant_id: @merchant_3.id)
      # @item_4 = create(:item, merchant_id: @merchant_4.id)
      # @item_5 = create(:item, merchant_id: @merchant_5.id)
      # @item_6 = create(:item, merchant_id: @merchant_6.id)
      # @item_7 = create(:item, merchant_id: @merchant_7.id)
      # @item_8 = create(:item, merchant_id: @merchant_8.id)

      # @invoice_items_merchant_1 = create_list(:invoice_item, 10, unit_price: 5000, quantity: 10, invoice_id: @invoice_1.id, item_id: @item_1.id) #add merchant?
      # @invoice_items_merchant_2 = create_list(:invoice_item, 4, unit_price: 3000, quantity: 5, invoice_id: @invoice_2.id, item_id: @item_2.id) #add merchant?
      # @invoice_items_merchant_3 = create_list(:invoice_item, 6, unit_price: 2000, quantity: 6, invoice_id: @invoice_3.id, item_id: @item_3.id) #add merchant?
      # @invoice_items_merchant_4 = create_list(:invoice_item, 8, unit_price: 5000, quantity: 8, invoice_id: @invoice_4.id, item_id: @item_4.id) #add merchant?
      # @invoice_items_merchant_5 = create_list(:invoice_item, 2, unit_price: 6000, quantity: 9, invoice_id: @invoice_5.id, item_id: @item_5.id) #add merchant?
      # @invoice_items_merchant_6 = create_list(:invoice_item, 5, unit_price: 2000, quantity: 2, invoice_id: @invoice_6.id, item_id: @item_6.id) #add merchant?
      # @invoice_items_merchant_7 = create_list(:invoice_item, 4, unit_price: 1000, quantity: 4, invoice_id: @invoice_7.id, item_id: @item_7.id) #add merchant?
      # @invoice_items_merchant_8 = create_list(:invoice_item, 9, unit_price: 1000, quantity: 9, invoice_id: @invoice_8.id, item_id: @item_8.id) #add merchant?

      # create(:transaction, result: 1, invoice_id: @invoice_1.id)
      # create(:transaction, result: 1, invoice_id: @invoice_2.id)
      # create(:transaction, result: 1, invoice_id: @invoice_3.id)
      # create(:transaction, result: 0, invoice_id: @invoice_4.id)
      # create(:transaction, result: 1, invoice_id: @invoice_5.id)
      # create(:transaction, result: 1, invoice_id: @invoice_6.id)
      # create(:transaction, result: 1, invoice_id: @invoice_7.id)
      # create(:transaction, result: 1, invoice_id: @invoice_8.id)

      @merchant_7 = create(:merchant)
      @merchant_8 = create(:merchant)
      @merchant_9 = create(:merchant)
      @merchant_10 = create(:merchant)
      @merchant_11 = create(:merchant)
      @merchant_12 = create(:merchant)
      @merchant_13 = create(:merchant)
      @merchant_14 = create(:merchant)

      @invoice_7 = create(:invoice)
      @invoice_8 = create(:invoice)
      @invoice_9 = create(:invoice)
      @invoice_10 = create(:invoice)
      @invoice_11 = create(:invoice)
      @invoice_12 = create(:invoice)
      @invoice_13 = create(:invoice)
      @invoice_14 = create(:invoice)

      @item_7 = create(:item, merchant_id: @merchant_7.id)
      @item_8 = create(:item, merchant_id: @merchant_8.id)
      @item_9 = create(:item, merchant_id: @merchant_9.id)
      @item_10 = create(:item, merchant_id: @merchant_10.id)
      @item_11 = create(:item, merchant_id: @merchant_11.id)
      @item_12 = create(:item, merchant_id: @merchant_12.id)
      @item_13 = create(:item, merchant_id: @merchant_13.id)
      @item_14 = create(:item, merchant_id: @merchant_14.id)

      @invoice_items_merchant_7 = create_list(:invoice_item, 10, unit_price: 5000, quantity: 10, invoice_id: @invoice_7.id, item_id: @item_7.id, merchant: @merchant_7)
      @invoice_items_merchant_8 = create_list(:invoice_item, 4, unit_price: 3000, quantity: 5, invoice_id: @invoice_8.id, item_id: @item_8.id, merchant: @merchant_8)
      @invoice_items_merchant_9 = create_list(:invoice_item, 6, unit_price: 2000, quantity: 6, invoice_id: @invoice_9.id, item_id: @item_9.id, merchant: @merchant_9)
      @invoice_items_merchant_10 = create_list(:invoice_item, 8, unit_price: 5000, quantity: 8, invoice_id: @invoice_10.id, item_id: @item_10.id, merchant: @merchant_10)
      @invoice_items_merchant_11 = create_list(:invoice_item, 2, unit_price: 6000, quantity: 9, invoice_id: @invoice_11.id, item_id: @item_11.id, merchant: @merchant_11)
      @invoice_items_merchant_12 = create_list(:invoice_item, 5, unit_price: 2000, quantity: 2, invoice_id: @invoice_12.id, item_id: @item_12.id, merchant: @merchant_12)
      @invoice_items_merchant_13 = create_list(:invoice_item, 4, unit_price: 1000, quantity: 4, invoice_id: @invoice_13.id, item_id: @item_13.id, merchant: @merchant_13)
      @invoice_items_merchant_14 = create_list(:invoice_item, 9, unit_price: 1000, quantity: 9, invoice_id: @invoice_14.id, item_id: @item_14.id, merchant: @merchant_14)

      create(:transaction, result: 1, invoice_id: @invoice_7.id)
      create(:transaction, result: 1, invoice_id: @invoice_8.id)
      create(:transaction, result: 1, invoice_id: @invoice_9.id)
      create(:transaction, result: 0, invoice_id: @invoice_10.id)
      create(:transaction, result: 1, invoice_id: @invoice_11.id)
      create(:transaction, result: 1, invoice_id: @invoice_12.id)
      create(:transaction, result: 1, invoice_id: @invoice_13.id)
      create(:transaction, result: 1, invoice_id: @invoice_14.id)
    end

    it "lists the top five merchants by total revenue generated" do
      within("div#top_five_merchants") do      
        expect(@merchant_7.name).to appear_before(@merchant_11.name)
        expect(@merchant_11.name).to appear_before(@merchant_14.name)
        expect(@merchant_14.name).to appear_before(@merchant_9.name)
        expect(@merchant_9.name).to appear_before(@merchant_8.name)
      end
    end

    # it "shows each merchant name as a link that directs to the admin merchant show page for the merchant" do
    #   within("div#top_five_merchants") do
    #     expect(page).to have_link("#{@merchant_1.name}", href: admin_merchant_path(@merchant_1.id))
    #     expect(page).to have_link("#{@merchant_2.name}", href: admin_merchant_path(@merchant_2.id))
    #     expect(page).to have_link("#{@merchant_3.name}", href: admin_merchant_path(@merchant_3.id))
    #     expect(page).to have_link("#{@merchant_4.name}", href: admin_merchant_path(@merchant_4.id))
    #     expect(page).to have_link("#{@merchant_5.name}", href: admin_merchant_path(@merchant_5.id))
    #   end
    # end

    # it "shows the total revenue generated next to each merchant" do
    #   within("div#top_five_merchants") do
    #     expect("#{@merchant_1.name} - $1,234.00 in sales").to appear_before("#{@merchant_2.name} - $1,234.00 in sales")
    #     expect("#{@merchant_2.name} - $1,234.00 in sales").to appear_before("#{@merchant_3.name} - $1,234.00 in sales")
    #     expect("#{@merchant_3.name} - $1,234.00 in sales").to appear_before("#{@merchant_4.name} - $1,234.00 in sales")
    #     expect("#{@merchant_4.name} - $1,234.00 in sales").to appear_before("#{@merchant_5.name} - $1,234.00 in sales")
    #   end
    # end

    # it "does not show merchants that are not in top five revenue generated" do
    #   expect(page).to_not have_content(@merchant_6.name)
    #   expect(page).to_not have_content(@merchant_7.name)
    #   expect(page).to_not have_content(@merchant_8.name)
    # end
  end

  describe "User Story 31" do
    it "shows the date with the most revenue for the top five merchants, 
    and returns the most recent date if there were two days with equal number of sales" do
      invoice_1 = create(:invoice, created_at: "1994-08-29 12:12:12")
      invoice_2 = create(:invoice, created_at: "2024-06-02 12:12:12")
      invoice_3 = create(:invoice, created_at: "2024-06-02 12:12:12")

      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant_id: merchant_1.id)

      create(:invoice_item, unit_price: 2000, quantity: 5, invoice_id: invoice_1.id, item_id: item_1.id)
      create(:invoice_item, unit_price: 1000, quantity: 5, invoice_id: invoice_2.id, item_id: item_1.id)
      create(:invoice_item, unit_price: 200, quantity: 5, invoice_id: invoice_3.id, item_id: item_1.id)

      create(:transaction, result: 0, invoice_id: invoice_1.id)
      create(:transaction, result: 0, invoice_id: invoice_2.id)
      create(:transaction, result: 0, invoice_id: invoice_3.id)

      ######

      invoice_4 = create(:invoice, created_at: "1994-08-29 12:12:12")
      invoice_5 = create(:invoice, created_at: "2024-06-02 12:12:12")
      invoice_6 = create(:invoice, created_at: "2024-06-02 12:12:12")

      merchant_2 = create(:merchant)

      item_2 = create(:item, merchant_id: merchant_2.id)

      create(:invoice_item, unit_price: 1000, quantity: 2, invoice_id: invoice_4.id, item_id: item_2.id)
      create(:invoice_item, unit_price: 1000, quantity: 2, invoice_id: invoice_5.id, item_id: item_2.id)
      create(:invoice_item, unit_price: 200, quantity: 2, invoice_id: invoice_6.id, item_id: item_2.id)

      create(:transaction, result: 0, invoice_id: invoice_4.id)
      create(:transaction, result: 0, invoice_id: invoice_5.id)
      create(:transaction, result: 0, invoice_id: invoice_6.id)

      visit admin_merchants_path

      within("div#top_five_merchants") do
        expect(page).to have_content("Top day for #{merchant_1.name} was 08/29/1994")
        expect(page).to have_content("Top day for #{merchant_2.name} was 06/02/2024")
      end
    end
  end
end