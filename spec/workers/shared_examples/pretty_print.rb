shared_examples 'pretty print worker' do
  it 'should pretty-print dependency tree' do
    expected_pattern =
      'Component: base_component.*?'                             \
      'Maintainer: Grzegorz Bizon <grzegorz.bizon@ntsn.pl>.*?'   \
      'Dependencies:.*?'                                         \
      ' `component_1` component, version: ~>1.1.*?'              \
      '    Component: component_1.*?'                            \
      '    Dependencies:.*?'                                     \
      '     `leaf_component_1` component, version: 1.0.*?'       \
      '     `leaf_component_2` component, version: 1.0.*?'       \
      ' `component_2` component, version: 1.1.*?'                \
      '    Component: component_2.*?'                            \
      '    Maintainer: Grzegorz Bizon <grzesiek@ntsn.pl>.*?'     \
      '    Dependencies:.*?'                                     \
      '     `leaf_component_3` component, version: ~>1.0.*?'

    expect { subject.call }
      .to output(/^#{expected_pattern}\Z/m).to_stdout
  end
end
