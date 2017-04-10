class AmendListColumns < ActiveRecord::Migration[5.0]
  def change
    add_column(:lists, :description, :string)
    remove_column(:lists, :name, :string)
  end
end
