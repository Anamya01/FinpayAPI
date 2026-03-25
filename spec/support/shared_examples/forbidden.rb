RSpec.shared_examples 'forbidden' do
  response '403', 'forbidden' do
    include_context 'authenticated'
    run_test!
  end
end
