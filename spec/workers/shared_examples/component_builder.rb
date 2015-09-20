shared_examples 'component builder worker' do
  before { subject.call }

  it 'should build all required components' do
    expect(components).to all(be_exists)
  end

  it 'should checkout valid refs' do
    valid_refs = components.map do |component|
      git(component.path) do
        (git_current_ref == component.ref) ||
        (component.ref == git_head_sha)
      end
    end
    expect(valid_refs).to all(be true)
  end
end
