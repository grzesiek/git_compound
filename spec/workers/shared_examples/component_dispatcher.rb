shared_examples 'component dispatcher worker' do
  it 'should build components that need building' do
    expect { subject.call }
      .to output(/^Building:\s+`new_component` component, version: 1.0.*$/)
      .to_stdout
  end

  it 'should update components that need updating' do
    expect { subject.call }
      .to output(/^Updating:\s+`component_1` component, version: 2.0.*$/)
      .to_stdout
  end

  it 'should replace components that need replacing' do
    expect { subject.call }
      .to output(/^Replacing:\s+`leaf_component_2` component, version: 1.0.*$/)
      .to_stdout
  end

  it 'should leave alone components that did not change' do
    expect { subject.call }
      .to output(/^Unchanged:\s+`leaf_component_1` component, version: 1.0.*$/)
      .to_stdout
  end
end
