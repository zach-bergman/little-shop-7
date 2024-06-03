class AddDefaultValueToInvoiceStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :invoices, :status, default: 0
  end
end
