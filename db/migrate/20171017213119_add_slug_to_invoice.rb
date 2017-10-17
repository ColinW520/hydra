class AddSlugToInvoice < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :slug, :string
    Invoice.find_each(&:save)
  end
end
