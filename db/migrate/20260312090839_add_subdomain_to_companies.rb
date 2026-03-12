class AddSubdomainToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :subdomain, :string
  end
end
