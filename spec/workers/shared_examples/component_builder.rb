shared_examples 'component builder worker' do
  before do
    subject.call
  end

  it 'should build all required components' do
    expect(components.all? { |component| component.exists? == true })
      .to be true
  end

  it 'should checkout valid refs' do
    result = components.all? do |component|
      git(component.path) do
        (git_current_ref == component.ref) || (component.ref == git_head_sha)
      end
    end
    expect(result).to be true
  end
end
