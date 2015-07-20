shared_examples 'pretty print worker' do
  it 'should pretty-print dependency tree' do
    expected_pattern =
      '`component_1` component, gem version: ~>1.1.*?'        \
      '  `leaf_component_1` component, gem version: 1.0.*?'   \
      '  `leaf_component_2` component, gem version: 1.0.*?'   \
      '`component_2` component, gem version: 1.1.*?'          \
      '  `leaf_component_3` component, gem version: ~>1.0.*?'

    expect { subject.call }
      .to output(/^#{expected_pattern}\Z/m).to_stdout
  end
end
