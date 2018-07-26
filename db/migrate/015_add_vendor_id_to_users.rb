class AddVendorIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :vendor, index: true
  end
end
