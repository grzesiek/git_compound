describe GitCompound::Manifest do
  before do
    @compound_file = 'Compoundfile'
    File.open(@compound_file, 'w') do |f|
      f.puts 'name :test_project'
    end
  end

  it 'should be loaded from file' do
    loaded = GitCompound::Manifest.load!(@compound_file)
    expect(loaded).to be_an_instance_of GitCompound::Manifest
  end
end 
