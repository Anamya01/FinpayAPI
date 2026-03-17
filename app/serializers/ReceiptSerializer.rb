class ReceiptSerializer
  include Alba::Resource
  include Rails.application.routes.url_helpers

  attributes :id, :expense_id

  attribute :file_url do |receipt|
    Rails.application.routes.url_helpers.rails_blob_url(receipt.file, only_path: true) if receipt.file.attached?
  end
end
