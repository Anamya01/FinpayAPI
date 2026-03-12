class RemoveSchemaNameFromCompanies < ActiveRecord::Migration[8.1]
  def change
    remove_column :companies, :schema_name, :string
  end
end
