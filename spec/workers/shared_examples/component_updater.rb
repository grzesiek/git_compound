shared_examples 'component updater worker' do
  it 'prints information about components being updated' do
    expect { subject.call }
      .to output("Updating: `component_1` component, gem version: 2.0\n")
      .to_stdout
  end

  it 'checkouts new ref for updated components' do
    subject.call
    current_ref = git('component_1') { git_current_ref }
    expect(current_ref).to eq '2.0'
  end
end
