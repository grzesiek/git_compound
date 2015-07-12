# Requires 'out of date environment context'

shared_examples 'component update dispatcher worker' do
  it 'should build components that need building' do
    expect { subject.call }
      .to output(/Building:    `new_component` component, gem version: 1.0/)
      .to_stdout
  end

  it 'should update components that need updating' do
    expect { subject.call }
      .to output(/Updating:  `component_1` component, gem version: 2.0/)
      .to_stdout
  end

  it 'should replace components that need replacing' do
    expect { subject.call }
      .to output(/Replacing:   `leaf_component_2` component, gem version: 1.0/)
      .to_stdout
  end

  it 'should leave alone components that did not change' do
    expect { subject.call }
      .to output(/Unchanged:   `leaf_component_1` component, gem version: 1.0/)
      .to_stdout
  end
end
