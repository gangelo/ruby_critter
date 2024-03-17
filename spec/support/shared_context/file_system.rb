# frozen_string_literal: true

RSpec.shared_context 'when using the file system' do
  before do
    allow(RubyCritter::OS::FileSystem).to receive(:root_folder).and_return(temp_folder)
  end

  after do
    FileUtils.rm_rf(temp_folder)
  end

  let(:temp_folder) { File.join(Dir.tmpdir, 'ruby_critter') }
end

RSpec.configure do |config|
  config.include_context 'when using the file system'
end
