require 'workers/shared_examples/component_dispatcher'
require 'workers/shared_examples/local_changes_guard'
require 'workers/shared_context/out_of_date_environment'

describe GitCompound do
  describe '#update' do
    include_context 'out of date environment'

    subject { -> { GitCompound.update(manifest_path!) } }

    it_behaves_like 'local changes guard worker'
    it_behaves_like 'component dispatcher worker'

    it 'removes dormant components' do
      pattern = 'Removing dormant component `component_2` '      \
                "from `component_2_destination/` !\n"            \
                'Removing dormant component `leaf_component_3` ' \
                'from `leaf_component_3_destination/`'
      expect { subject.call }
        .to output(/#{pattern}/).to_stdout
    end

    it 'updates lockfile' do
      subject.call
      components = GitCompound::Lock.new.contents[:components]
      expect(components).to be_any { |cmp| cmp[:name] == :component_1 }
      expect(components).to be_any { |cmp| cmp[:name] == :new_component }
      expect(components).to be_none { |cmp| cmp[:name] == :component_2 }
      expect(components).to be_none { |cmp| cmp[:name] == :leaf_component_3 }
    end
  end
end
