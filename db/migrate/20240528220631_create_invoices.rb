class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.integer :status, default: 0
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
