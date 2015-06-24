shared_examples 'component builder' do
  it 'should build all required components' do
    expect(@components.all? { |c| c.destination_exists? == true })
      .to be true
  end

  it 'should checkout valid refs' do
    result = @components.all? do |c|
      git(c.destination_path) { git_current_ref_matches?(c.source.ref) }
    end
    expect(result).to be true
  end
end
