class AddBrandRefToProducts < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :brand, foreign_key: true
  end
end
